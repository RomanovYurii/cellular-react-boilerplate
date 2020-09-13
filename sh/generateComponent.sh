#!/bin/sh
componentType=""
componentsFolder="./src/components/cells"
withRedux=0

# shellcheck disable=SC2039
while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do
  case $1 in
  -c | --cell)
    componentType=" cell"
    componentsFolder="./src/components/0_cells"
    ;;
  -t | --tissue)
    componentType=" tissue"
    componentsFolder="./src/components/1_tissues"
    ;;
  -u | --unit)
    componentType=" unit"
    componentsFolder="./src/components/2_units"
    ;;
  -o | --organism)
    componentType=" organism"
    componentsFolder="./src/components/3_organisms"
    ;;
  -e | --eco | --ecosystem)
    componentType=" ecosystem"
    componentsFolder="./src/components/4_ecosystems"
    ;;
  --withRedux)
    shift; withRedux=1
    ;;
  --help | -h)
    echo;
    echo "Shell components generator commands"
    echo "-c | --cell               Create cell component(s)"
    echo "-t | --tissue             Create tissue component(s)"
    echo "-u | --unit               Create unit component(s)"
    echo "-o | --organ              Create organism component(s)"
    echo "-e | --eco | --ecosystem  Create ecosystem component(s)"
    echo "--withRedux               Add redux files to the component folder"
    echo "-h | --help               Call this menu"
    echo;
    exit;
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

    const $componentName = () => {
      return <div></div>;
    };

    export default $componentName;
  " >>"$componentFolder/$componentName.js"

  # Create exporter
  echo "import $componentName from './$componentName';export default $componentName;" >>"$componentFolder/index.js"

  if [[ "$withRedux" = 1 ]]; then
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
  fi

  # Create constants
  touch "$componentFolder/$componentName.constants.js"

  # Create styles
  touch "$componentFolder/$componentName.styles.scss"

  # Prettify
  prettier --write "$componentFolder"/*
done

# Success message
echo "Created$componentType component(s): $componentNames"

# Commit changes
git add .
git commit -a -m "Created$componentType component(s): $componentNames"
git push
