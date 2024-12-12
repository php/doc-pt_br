#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 [pr number]" >&2
    exit 1
fi

rm -f list.txt
rm -f merge.txt
rm -f patch.txt

wget "https://patch-diff.githubusercontent.com/raw/php/doc-pt_br/pull/$1.diff" -O patch.txt

# Verbose check

if ! $( git -C pt_BR apply --check ../patch.txt ); then
    echo
    echo "Patch does not apply correctly. Trying to merge some chunks."
    echo
fi

git -C pt_BR apply --reject --whitespace=fix ../patch.txt 2>&1 | tee ../merge.txt;
git -C pt_BR ls-files --modified --others > ../list.txt

php doc-base/configure.php -q --disable-sources-file --enable-xml-details --disable-xpointer-reporting --with-lang=pt_BR
git -C pt_BR status
git -C pt_BR diff
git -C pt_BR diff --name-only

echo
echo
echo "If OK, accept the pull on GitHub and then "
echo "    ./wipe.sh"
echo ""
