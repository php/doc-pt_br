#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 [pr number]" >&2
    exit 1
fi

rm -f list.txt
rm -f merge.txt
rm -f patch.txt

wget "https://patch-diff.githubusercontent.com/raw/php/doc-pt_br/pull/$1.diff" -O patch.txt

if ! $(cd pt_BR; git apply --check ../patch.txt); then

    (cd pt_BR; git apply --verbose ../patch.txt;)

else

    (cd pt_BR; git apply ../patch.txt 2>&1 | tee ../merge.txt;)
    (cd pt_BR; git diff --name-only > ../list.txt)

    php doc-base/configure.php --with-lang=pt_BR --enable-xml-details    
    (cd pt_BR; git status)
    (cd pt_BR; git diff)
    (cd pt_BR; git diff --name-only)

    echo
    echo "If OK, accept the pull on GitHub and then "
    echo "    ./wipe.sh"
    echo ""

fi
