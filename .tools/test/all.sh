
git -C doc-base pull --rebase --autostash
git -C en       pull --rebase --autostash
git -C pt_BR    pull --rebase --autostash

php doc-base/configure.php -q --disable-sources-file --enable-xml-details --with-lang=pt_BR

rm -f revcheck.html
php doc-base/scripts/revcheck.php pt_BR > revcheck.html
nohup xdg-open revcheck.html </dev/null >/dev/null 2>&1 &

echo
git -C pt_BR status
echo

php doc-base/scripts/translation/configure.php pt_BR

echo
echo Rodando testes de sincronia...

php doc-base/scripts/broken.php pt_BR
php doc-base/scripts/translation/qaxml-revtag.php

php doc-base/scripts/translation/qaxml-attributes.php
php doc-base/scripts/translation/qaxml-entities.php
php doc-base/scripts/translation/qaxml-pi.php
php doc-base/scripts/translation/qaxml-tags.php --detail
php doc-base/scripts/translation/qaxml-ws.php

php doc-base/scripts/translation/qaxml-tags.php --content=acronym
php doc-base/scripts/translation/qaxml-tags.php --content=classname
php doc-base/scripts/translation/qaxml-tags.php --content=constant
php doc-base/scripts/translation/qaxml-tags.php --content=envar
php doc-base/scripts/translation/qaxml-tags.php --content=function
php doc-base/scripts/translation/qaxml-tags.php --content=interfacename
php doc-base/scripts/translation/qaxml-tags.php --content=parameter
php doc-base/scripts/translation/qaxml-tags.php --content=type
php doc-base/scripts/translation/qaxml-tags.php --content=classsynopsis
php doc-base/scripts/translation/qaxml-tags.php --content=constructorsynopsis
php doc-base/scripts/translation/qaxml-tags.php --content=destructorsynopsis
php doc-base/scripts/translation/qaxml-tags.php --content=fieldsynopsis
php doc-base/scripts/translation/qaxml-tags.php --content=funcsynopsis
php doc-base/scripts/translation/qaxml-tags.php --content=methodsynopsis

php doc-base/scripts/translation/qaxml-tags.php --content=code
php doc-base/scripts/translation/qaxml-tags.php --content=computeroutput
php doc-base/scripts/translation/qaxml-tags.php --content=filename
php doc-base/scripts/translation/qaxml-tags.php --content=literal
php doc-base/scripts/translation/qaxml-tags.php --content=varname
