BRANCHES=(
master
UnowhyY13
AN515-57
)
ORIGINALBRANCH=`git status | head -n1 | cut -c13-`
for BRANCH in "${BRANCHES[@]}";
do
    git checkout $BRANCH;
    git push
done
    git checkout $ORIGINALBRANCH