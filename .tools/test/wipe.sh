
git -C doc-base clean -fdx --quiet
git -C doc-base restore .
git -C doc-base pull --rebase

git -C en rebase --abort
git -C en clean -fd
git -C en clean -fdx --quiet
git -C en restore .
git -C en pull --rebase

git -C pt_BR rebase --abort
git -C pt_BR clean -fd
git -C pt_BR clean -fdx --quiet
git -C pt_BR restore .
git -C pt_BR pull --rebase

git -C doc-base status
git -C en       status
git -C pt_BR    status

