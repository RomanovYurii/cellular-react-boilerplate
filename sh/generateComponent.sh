componentType=""
componentsFolder="./src/components"

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do
  case $1 in
  -sh | --shared)
    componentType="shared"
    componentsFolder="./src/components/shared"
    ;;
  esac
  shift
done
if [[ "$1" == '--' ]]; then shift; fi

for componentName; do
  # Create folder
  componentFolder="$componentsFolder/$componentName"
  mkdir "$componentFolder"
  # Create component
  touch "$componentFolder/$componentName.js"
  echo "import React from 'react';const $componentName = () => {return <div></div>;};
  export default $componentName;" >>"$componentFolder/$componentName.js"
  # Create exporter
  touch "$componentFolder/index.js"
  echo "import $componentName from './$componentName';export default $componentName;" >>"$componentFolder/index.js"
  # Create styles
  touch "$componentFolder/$componentName.styles.scss"
  echo "@import '$componentFolder/$componentName.styles';" >>"./src/index.scss"
  # Create test
  touch "$componentFolder/$componentName.test.js"
  echo "import React from 'react';
    import $componentName from './$componentName';
    import renderer from 'react-test-renderer';

    test('$componentName renders correctly', () => {
    const tree = renderer.create(<$componentName/>).toJSON();
    expect(tree).toMatchSnapshot();
    });" >>"$componentFolder/$componentName.test.js"
  yarn test -u --watchAll=false
  # Prettify
  prettier --write .
  # Commit
  git add .
  git commit -a -m "Created $componentType component $componentName"
done

git push
