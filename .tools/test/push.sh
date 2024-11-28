
if [ $# -eq 0 ]
then msg='Update translation.';
else msg=$1;
fi

set +e

behind=0
LC_ALL=C git -C pt_BR status -sb | grep -q 'behind' && behind=1
if [ $behind = 1 ]; then
    echo "Algum repositório desatualizado."
    echo "Utilize 'git -C pt_BR status' para verificar e 'git -C pt_BR pull --rebase --autostash' para sincronizar."
    exit
else
    git -C pt_BR commit -a -m "$msg"
    git -C pt_BR push
    git -C pt_BR status
fi

set -e

