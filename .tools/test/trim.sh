git -C pt_BR diff --name-only    | xargs -I %f -- php pt_BR/.tools/test/spce.php "pt_BR/%f"
[ -f list.txt ] && cat list.txt  | xargs -I %f -- php pt_BR/.tools/test/spce.php "pt_BR/%f"
