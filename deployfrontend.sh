rsync -r src/ docs/
rsync build/contracts/* docs/
git add .
git commit -m "Compiiles assets for Github Pages"
git push -u origin master