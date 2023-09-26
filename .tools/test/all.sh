
(cd doc-base; git pull --rebase --autostash)
(cd en;       git pull --rebase --autostash)
(cd pt_BR;    git pull --rebase --autostash)

php doc-base/configure.php -q --with-lang=pt_BR --enable-xml-details

rm revcheck.html
php doc-base/scripts/revcheck.php pt_BR > revcheck.html
nohup xdg-open revcheck.html </dev/null >/dev/null 2>&1 &

echo
(cd pt_BR; git status)
echo

if [ -d "doc-base/scripts/translation" ];
then
    php doc-base/scripts/translation/configure.php pt_BR

    php doc-base/scripts/translation/qaxml.a.php
    php doc-base/scripts/translation/qaxml.e.php
    php doc-base/scripts/translation/qaxml.p.php
    php doc-base/scripts/translation/qaxml.t.php

    php doc-base/scripts/translation/qaxml.t.php acronym
    php doc-base/scripts/translation/qaxml.t.php classname
    php doc-base/scripts/translation/qaxml.t.php constant
    php doc-base/scripts/translation/qaxml.t.php envar
    php doc-base/scripts/translation/qaxml.t.php function
    php doc-base/scripts/translation/qaxml.t.php interfacename
    php doc-base/scripts/translation/qaxml.t.php parameter
    php doc-base/scripts/translation/qaxml.t.php type
    php doc-base/scripts/translation/qaxml.t.php classsynopsis
    php doc-base/scripts/translation/qaxml.t.php constructorsynopsis
    php doc-base/scripts/translation/qaxml.t.php destructorsynopsis
    php doc-base/scripts/translation/qaxml.t.php fieldsynopsis
    php doc-base/scripts/translation/qaxml.t.php funcsynopsis
    php doc-base/scripts/translation/qaxml.t.php methodsynopsis

    php doc-base/scripts/translation/qaxml.t.php code
    php doc-base/scripts/translation/qaxml.t.php computeroutput
    php doc-base/scripts/translation/qaxml.t.php filename
    php doc-base/scripts/translation/qaxml.t.php literal
    php doc-base/scripts/translation/qaxml.t.php varname
fi
