#!/bin/bash

if [ -s "${FILELIST}" ]; then
  # Get the ruleset to use (the one provided in this repo or
  # the one provided by the extension triggering the action)
  #
  FILES=`cat $FILELIST | paste -sd "," -`
  RULESET=${GITHUB_ACTION_PATH}/phpmd-ruleset.xml

  if [ -f "${GITHUB_WORKSPACE}/phpmd-ruleset.xml" ]; then
    RULESET="${GITHUB_WORKSPACE}/phpmd-ruleset.xml"
    echo "Using a custom PHP-MD ruleset provided by the extension at ${RULESET}"
  elif [ -f "${GITHUB_WORKSPACE}/src/phpmd-ruleset.xml" ]; then
    # A previous step may have moved all extension files to a 'src' directory
    RULESET="${GITHUB_WORKSPACE}/src/phpmd-ruleset.xml"
    echo "Using a custom PHP-MD ruleset provided by the extension at ${RULESET}"
  fi

  # Run PHPMD
  #
  echo "Running PHPMD with RULESET ${RULESET} on ${FILES}"
  phpmd $FILES sarif $RULESET --exclude 'vendor/*' --reportfile phpmd-results.sarif
  RETVAL=$?

  echo "The following files were tested against the PHP-MD ruleset:"; echo
  cat -n "$FILELIST";
  rm "$FILELIST"

  # Store the error code (it will be consumed by next pipeline steps later on)
  #
  if [ $RETVAL -ne 0 ]; then
    echo "ok=false" >> "$GITHUB_OUTPUT"
  else
    echo "ok=true" >> "$GITHUB_OUTPUT"
  fi

else
  echo "There are no changes in PHP files (no PHP-MD test performed)"
  echo "ok=true" >> "$GITHUB_OUTPUT"
fi

# Propagate the error code from PHPMD
#
exit $RETVAL
