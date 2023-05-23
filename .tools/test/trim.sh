(cd pt_BR; git diff --name-only) | xargs -I %f -- dos2unix "pt_BR/%f"
(cd pt_BR; git diff --name-only) | xargs -I %f -- php spce.php "pt_BR/%f"
