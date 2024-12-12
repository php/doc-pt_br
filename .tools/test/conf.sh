
git -C doc-base pull --rebase --autostash
git -C en       pull --rebase --autostash
git -C pt_BR    pull --rebase --autostash

php doc-base/configure.php -q --disable-sources-file --enable-xml-details --disable-xpointer-reporting --with-lang=pt_BR

git -C pt_BR ls-files --modified --others > ../list.txt
git -C pt_BR status
