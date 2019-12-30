#!/bin/bash

SCRIPT_NAME="test.sh"

RUBY_TESTS=false
CHECK_YARN_INTEGRETY=false
HELP=false

# Parse command line args
POSITIONAL=()
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -Y|--yarn-integrity)
            CHECK_YARN_INTEGRETY=true
            shift # past argument
            ;;
        -R|--ruby)
            RUBY_TESTS=true
            shift # past argument
            ;;
        -h|--help)
            HELP=true
            shift # past argument
            ;;
        *)    # unknown option
            POSITIONAL+=("$1") # save it in an array for later
            shift # past argument
            ;;
    esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

# Unofficial Strict mode
set -euo pipefail
IFS=$'\n\t'

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

if $HELP ; then
    echo "$SCRIPT_NAME runs tests for ride-board"
    echo "$SCRIPT_NAME [no parameters]"
    echo "  -h or --help           Print this message"
    echo "  -R or --ruby           Run ruby tests"
    echo "  -Y or --yarn-integrity Run yarn integrity check"
    echo
    echo "Note: calling this script with no options will run all"
    echo "tests. Calling this script with any subset of the tests will"
    echo "only run those tests."
    exit 0
fi

EXIT_STATUS="0"

if $RUBY_TESTS || ! $CHECK_YARN_INTEGRETY ; then
    echo
    echo "Running ruby tests..."
    echo
    rake test || \
        EXIT_STATUS="1"
fi

if $CHECK_YARN_INTEGRETY || ! $RUBY_TESTS ; then
    echo
    echo "Running yarn integrity check..."
    echo
    yarn check --integrity || \
        EXIT_STATUS="1"
fi

exit $EXIT_STATUS
