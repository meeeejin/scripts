#!/bin/bash
ORG='FlashSQL'
RESULT_DIR='/home/mijin/starlab'

cd $RESULT_DIR

# Get the total info
curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/orgs/$ORG/repos > $RESULT_DIR/${ORG}.txt

# url
echo "Repo"
grep "full_name" ${ORG}.txt | awk '{ print $2 }' | sed 's/"//g; s/,//g'
echo

# watch
echo "# of Watchers"
grep "watchers_count" ${ORG}.txt | awk '{ print $2 }' | sed 's/,//g'
echo

# star
echo "# of Stars"
grep "stargazers_count" ${ORG}.txt | awk '{ print $2 }' | sed 's/,//g'
echo

# fork
echo "# of Forks"
grep "forks_count" ${ORG}.txt | awk '{ print $2 }' | sed 's/,//g'
echo

# issue
echo "# of Issues"
grep "open_issues_count" ${ORG}.txt | awk '{ print $2 }' | sed 's/,//g'
echo
     
# commit

# branch

# release

# contributors

# license
echo "License"
grep -A 2 "license" ${ORG}.txt | grep "name" | awk '{first = $1; $1 = ""; print $0; }' | sed 's/"//g; s/,//g'
echo

# commiter

# downloads

# visitor
