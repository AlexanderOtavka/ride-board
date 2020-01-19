#!/bin/bash

SCRIPT_NAME="initialize.sh"

FULL_RESET=false
INITIALIZE_BLAZER_AND_HYPERSHIELD=false
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
        --analyitics-dash)
            INITIALIZE_BLAZER_AND_HYPERSHIELD=true
            shift # past argument
            ;;
        *)  # unknown option
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
    echo "$SCRIPT_NAME initializes the ride-board rails application"
    echo "$SCRIPT_NAME [no parameters]"
    echo "  -h or --help         Print this message"
    echo "  -R or --reset-all    Remove all temporary files and clear the database"
    echo "  --analyitics-dash    Initialize blazer and hypershield for analytics dashboard"
    exit 0
fi

# $RAILS_ON_DOCKER is set to "yes" by the dockerfile, and can be used to tell if
# we're running in the docker environment
if [[ -v RAILS_ON_DOCKER ]] && [[ "$RAILS_ON_DOCKER" == "YES" ]] ; then
    true # Pass for now
fi

PROJECT_DB_PREFIX="ride_board"
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

if $FULL_RESET || $INITIALIZE_BLAZER_AND_HYPERSHIELD ; then
    BLAZER_PASSWORD="hello"
    INITIALIZE_BLAZER_AND_HYPERSHIELD_COMMAND="BEGIN;
CREATE ROLE blazer LOGIN PASSWORD '${BLAZER_PASSWORD}';
CREATE SCHEMA hypershield;
GRANT CONNECT ON DATABASE ${PROJECT_DB_PREFIX}_development TO blazer;
/*GRANT CONNECT ON DATABASE ${PROJECT_DB_PREFIX}_production  TO blazer;*/
GRANT USAGE ON SCHEMA hypershield TO blazer;
ALTER ROLE blazer SET search_path TO hypershield, public;
COMMIT;"
    echo
    echo "==Intializing blazer and hypershield in postgres=="
    echo
    psql -h db -U postgres \
         -c "$INITIALIZE_BLAZER_AND_HYPERSHIELD_COMMAND"

    echo
    echo "==Initializing hypershield=="
    echo
    rake hypershield:refresh
fi

if ! $INITIALIZE_BLAZER_AND_HYPERSHIELD || $FULL_RESET ; then
    echo "==Setting up database=="
    rake db:setup --trace
fi
