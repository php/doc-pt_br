
git -C doc-base pull --rebase --autostash
git -C en       pull --rebase --autostash
git -C pt_BR    pull --rebase --autostash

php doc-base/configure.php -q --with-lang=pt_BR --enable-xml-details --disable-xpointer-reporting

git -C pt_BR ls-files --modified --others > ../list.txt
git -C pt_BR status
