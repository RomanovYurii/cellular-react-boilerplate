for componentTypeFolder in ./src/components/*; do
  rm "$componentTypeFolder"/index.js

  for componentFolder in "$componentTypeFolder"/*; do
    componentName=$(echo "$componentFolder" | cut -d'/' -f 5)

    if [[ "$componentName" != "index.js" ]]; then
      echo "import $componentName from './$componentName';" >> "$componentTypeFolder"/index.js
    fi
  done

  echo "
  export {" >> "$componentTypeFolder"/index.js

  for componentFolder in "$componentTypeFolder"/*; do
    componentName=$(echo "$componentFolder" | cut -d'/' -f 5)

    if [[ "$componentName" != "index.js" ]]; then
      echo "$componentName," >> "$componentTypeFolder"/index.js
    fi
  done

  echo "}" >> "$componentTypeFolder"/index.js
done

prettier --write ./src/components/*/*.js
