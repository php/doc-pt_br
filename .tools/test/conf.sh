
(cd doc-base; git pull --rebase)
(cd en;       git pull --rebase)
(cd pt_BR;    git pull --rebase)

php doc-base/configure.php -q --with-lang=pt_BR --enable-xml-details --disable-xpointer-reporting

(cd pt_BR; git ls-files --modified --others > ../list.txt)
(cd pt_BR; git status)

