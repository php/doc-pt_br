
if [ $# -eq 0 ]
then msg='Update translation.';
else msg=$1;
fi

(cd pt_BR; git commit -a -m "$msg")
(cd pt_BR; git push)
(cd pt_BR; git status)

