#!/usr/bin/env bash
#
# Track merged PRs in php/doc-en and create issues in doc-pt_br
# for files that need translation updates.
#
# How it works:
#   - Fetches PRs merged in doc-en during the last 7 days
#   - For each PR, checks if a matching issue already exists in doc-pt_br
#   - If not, creates one listing the PT_BR files to update
#
# Why 7 days: the action runs daily, so 7 days gives us 6 days of margin.
# Even if the action fails for a whole week, nothing is missed.
# Duplicates are prevented by searching for the PR number in existing issue titles.
#
set -euo pipefail

SINCE=$(date -u -d '7 days ago' '+%Y-%m-%dT%H:%M:%SZ')
echo "Checking doc-en PRs merged since $SINCE"

# Fetch merged PRs from the last 7 days (max 100 per page, paginate if needed)
PAGE=1
ALL_PRS="[]"
while :; do
  BATCH=$(gh api "repos/php/doc-en/pulls?state=closed&sort=updated&direction=desc&per_page=100&page=$PAGE" \
    --jq "[.[] | select(.merged_at != null and .merged_at >= \"$SINCE\")]")
  COUNT=$(echo "$BATCH" | jq 'length')
  ALL_PRS=$(echo "$ALL_PRS $BATCH" | jq -s 'add')
  echo "  Page $PAGE: $COUNT merged PR(s)"
  if [ "$COUNT" -lt 100 ]; then
    break
  fi
  PAGE=$((PAGE + 1))
done

TOTAL=$(echo "$ALL_PRS" | jq 'length')
echo "Total: $TOTAL merged PR(s) in the last 7 days"

if [ "$TOTAL" -eq 0 ]; then
  echo "Nothing to do."
  exit 0
fi

CREATED=0
SKIPPED=0

# Process each PR (write to temp file to avoid broken pipe with while loop)
echo "$ALL_PRS" | jq -c '.[]' > /tmp/prs.jsonl

while read -r PR; do
  PR_NUMBER=$(echo "$PR" | jq -r '.number')
  PR_TITLE=$(echo "$PR" | jq -r '.title')
  PR_MERGED_AT=$(echo "$PR" | jq -r '.merged_at')
  PR_MERGE_DATE=$(echo "$PR_MERGED_AT" | cut -dT -f1)

  echo ""
  echo "PR #$PR_NUMBER: $PR_TITLE"

  # Skip PRs marked with [skip-revcheck] (no translation update needed)
  if echo "$PR_TITLE" | grep -qi '\[skip-revcheck\]'; then
    echo "  -> [skip-revcheck], skipping."
    SKIPPED=$((SKIPPED + 1))
    continue
  fi

  # Deduplication: search for the doc-en PR URL in existing issues
  EXISTING=$(gh issue list --repo "$GH_REPO" --search "\"doc-en/pull/$PR_NUMBER\"" \
    --state all --json number --jq 'length')
  if [ "$EXISTING" -gt 0 ]; then
    echo "  -> Issue already exists, skipping."
    SKIPPED=$((SKIPPED + 1))
    continue
  fi

  # Get files changed in this PR
  FILES=$(gh api "repos/php/doc-en/pulls/$PR_NUMBER/files?per_page=100" \
    --jq '.[].filename' 2>/dev/null || true)

  if [ -z "$FILES" ]; then
    echo "  -> No files found, skipping."
    continue
  fi

  # Categorize files
  UPDATE_LIST=""
  NEW_LIST=""

  while IFS= read -r FILE; do
    if [ -f "$FILE" ]; then
      UPDATE_LIST="${UPDATE_LIST}- \`${FILE}\`"$'\n'
    elif [[ "$FILE" == *.xml ]]; then
      NEW_LIST="${NEW_LIST}- \`${FILE}\`"$'\n'
    fi
  done <<< "$FILES"

  # Skip if no PT_BR-relevant files
  if [ -z "$UPDATE_LIST" ] && [ -z "$NEW_LIST" ]; then
    echo "  -> No PT_BR-relevant files, skipping."
    continue
  fi

  # Build issue body
  BODY="PR: \`https://github.com/php/doc-en/pull/$PR_NUMBER\` ($PR_MERGE_DATE)"$'\n'

  if [ -n "$UPDATE_LIST" ]; then
    BODY+=$'\n'"**Arquivos PT_BR para atualizar**"$'\n'
    BODY+="$UPDATE_LIST"
  fi

  if [ -n "$NEW_LIST" ]; then
    BODY+=$'\n'"**Novos arquivos EN (ainda não traduzidos)**"$'\n'
    BODY+="$NEW_LIST"
  fi

  # Create the issue
  ISSUE_TITLE="[Sync EN] $PR_TITLE"
  echo "$BODY" | gh issue create \
    --repo "$GH_REPO" \
    --title "$ISSUE_TITLE" \
    --label "sync-en" \
    --body-file -

  echo "  -> Issue created."
  CREATED=$((CREATED + 1))
done < /tmp/prs.jsonl

echo ""
echo "Done. Created: $CREATED, Skipped (already exist): $SKIPPED"
