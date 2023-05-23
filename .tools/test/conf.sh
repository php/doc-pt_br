
(cd doc-base; git pull)
(cd en;       git pull)
(cd pt_BR;    git pull)

php doc-base/configure.php --with-lang=pt_BR --enable-xml-details

(cd pt_BR; git status)

