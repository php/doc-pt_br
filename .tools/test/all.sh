
(cd doc-base; git pull)
(cd en;       git pull)
(cd pt_BR;    git pull)

php doc-base/configure.php --with-lang=pt_BR --enable-xml-details

rm revcheck.html
php doc-base/scripts/revcheck.php pt_BR > revcheck.html
nohup xdg-open revcheck.html </dev/null >/dev/null 2>&1 &

echo
(cd pt_BR; git status)
echo

