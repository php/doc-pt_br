
(cd en;    git clean -f -d)
(cd en;    git checkout .)
(cd en;    git reset  --hard )
(cd en;    git pull --rebase )
(cd en;    git rebase --skip )

(cd pt_BR; git clean -f -d)
(cd pt_BR; git checkout .)
(cd pt_BR; git reset  --hard )
(cd pt_BR; git pull --rebase )
(cd pt_BR; git rebase --skip )

(cd doc-base; git pull)
(cd en;       git pull)
(cd pt_BR;    git pull)

(cd en;    git status)
(cd pt_BR; git status)

