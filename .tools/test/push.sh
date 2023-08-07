
if [ $# -eq 0 ]
then msg='Update translation.';
else msg=$1;
fi

set +e
cd pt_BR

git pull --rebase --autostash
git commit -a -m "$msg"
git push
git status

set -e
cd ..
