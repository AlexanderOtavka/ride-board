#!/bin/bash

SCRIPT_NAME="initialize.sh"

FULL_RESET=false
HELP=false

# Parse command line args
POSITIONAL=()
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -R|--reset-all)
            FULL_RESET=true
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
    echo "$SCRIPT_NAME initializes the imagine-grinnell rails application"
    echo "$SCRIPT_NAME [no parameters]"
    echo "  -h or --help         Print this message"
    echo "  -R or --reset-all    Remove all temporary files and clear the database"
    exit 0
fi

# $RAILS_ON_DOCKER is set to "yes" by the dockerfile, and can be used to tell if
# we're running in the docker environment
if [[ -v RAILS_ON_DOCKER ]] && [[ "$RAILS_ON_DOCKER" == "YES" ]] ; then
    true # Pass for now
fi

PROJECT_DB_PREFIX="imagine_grinnell"
DROP_TEST_DB_COMMAND="DROP DATABASE IF EXISTS ${PROJECT_DB_PREFIX}_test;"
DROP_DEV_DB_COMMAND="DROP DATABASE IF EXISTS ${PROJECT_DB_PREFIX}_development;"

if $FULL_RESET ; then
    echo "==Removing logs and temp files=="
    rails log:clear tmp:clear
    echo "==Removing all database information=="
    rake db:drop:all
    # Drop the databases anyways
    psql -h db -U postgres \
         -c "$DROP_TEST_DB_COMMAND" \
         -c "$DROP_DEV_DB_COMMAND"
fi


echo "==Setting up database=="
rake db:setup --trace
