
(cd doc-base; git pull --rebase --autostash)
(cd en;       git pull --rebase --autostash)
(cd pt_BR;    git pull --rebase --autostash)

php doc-base/configure.php --with-lang=pt_BR --enable-xml-details

(cd pt_BR; git status)

