(cd pt_BR; git diff --name-only) | xargs -I %f -- php pt_BR/.tools/test/spce.php "pt_BR/%f"
cat list.txt                     | xargs -I %f -- php pt_BR/.tools/test/spce.php "pt_BR/%f"
