#!/bin/sh
componentType=""
componentsFolder="./src/components"

# shellcheck disable=SC2039
while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do
  case $1 in
  -sh | --shared)
    componentType=" shared"
    componentsFolder="./src/components/shared"
    ;;
  -p | --parent )
    shift; parent=$1
    mkdir "$componentsFolder/$parent/children"
    componentsFolder+="/$parent/children"
    ;;
  esac
  shift
done
# shellcheck disable=SC2039
if [[ "$1" == '--' ]]; then shift; fi

componentNames=""
for componentName; do
  # shellcheck disable=SC2039
  componentNames+=$componentName
  # shellcheck disable=SC2039
  componentNames+=" "

  # Create folder
  componentFolder="$componentsFolder/$componentName"
  mkdir "$componentFolder"

  # Create component
  echo "
    import React from 'react';
    import './$componentName.styles.scss';
    import * as constants from './$componentName.constants';
    const $componentName = () => {
      return <div></div>;
    };
    export default $componentName;
  " >>"$componentFolder/$componentName.js"

  # Create exporter
  echo "import $componentName from './$componentName';export default $componentName;" >>"$componentFolder/index.js"

  # Create redux subfolder
  mkdir "$componentFolder/rdx"

  # Create actions
  touch "$componentFolder/rdx/$componentName.actions.js"

  # Create actionTypes
  touch "$componentFolder/rdx/$componentName.actionTypes.js"

  # Create reducer
  echo "
    const initialState = {};

    export default (state = initialState, action) => {
      const {payload, type} = action;

      switch (type) {
        default:
          return state;
      }
    };
  " >> "$componentFolder/rdx/$componentName.reducer.js"

  # Create constants
  echo "export default {componentName: '$componentName'};" >> "$componentFolder/$componentName.constants.js"

  # Create styles
  touch "$componentFolder/$componentName.styles.scss"

  # Create test
  echo "
    import React from 'react';
    import $componentName from './$componentName';
    import renderer from 'react-test-renderer';

    test('$componentName renders correctly', () => {
    const tree = renderer.create(<$componentName/>).toJSON();
    expect(tree).toMatchSnapshot();
    });
  " >>"$componentFolder/$componentName.test.js"

  # Prettify
  prettier --write .

done

# Success message
echo "Created$componentType component(s): $componentNames"

# Update snapshots
yarn test -u --watchAll=false

# Commit changes
git add .
git commit -a -m "Created$componentType component(s): $componentNames"
git push
