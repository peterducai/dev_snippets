#!/bin/bashPARAMS=""while (( "$#" )); do
  case "$1" in
    -f|--flag-with-argument)
      FARG=$2
      shift 2
      ;;
    --) # end argument parsing
      shift
      break
      ;;
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done# set positional arguments in their proper place
eval set -- "$PARAMS"
