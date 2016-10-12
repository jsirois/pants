#!/usr/bin/env bash

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd ${REPO_ROOT}

source build-support/common.sh

function usage() {
  echo "Checks import sort order for python files, optionally fixing incorrect"
  echo "sorts."
  echo
  echo "Usage: $0 (-h|-f)"
  echo " -h    print out this help message"
  echo " -f    instead of erroring on files with bad import sort order, fix"
  echo "       those files"
  if (( $# > 0 )); then
    die "$@"
  else
    exit 0
  fi
}

isort_args=(
  --check-only
)

while getopts "hf" opt
do
  case ${opt} in
    h) usage ;;
    f) isort_args=() ;;
    *) usage "Invalid option: -${OPTARG}" ;;
  esac
done

to_sort=$(mktemp -t changed.isort.XXXXX)
trap "rm -f ${to_sort}" EXIT
if [[ "$(./pants changed | tee ${to_sort})" != "" ]]
then
  ./pants -q --target-spec-file=${to_sort} fmt.isort -- ${isort_args[@]}
fi
