
if [ $# -eq 0 ]
then msg='Update translation.';
else msg=$1;
fi

set +e
cd pt_BR

behind=0
LC_ALL=C git status -sb | grep -q 'behind' && behind=1
if [ $behind = 1 ]; then
    echo "Algum repositório desatualizado."
    echo "Utilize 'git status' para verificar e 'git pull --rebase --autostash' para sincronizar."
    exit
else
    git commit -a -m "$msg"
    git push
    git status
fi

set -e
cd ..
