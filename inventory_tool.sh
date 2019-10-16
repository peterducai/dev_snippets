#!/bin/bash

# Array help

# ${#arrayname[@]} - length of array
# echo ${arrayname[@]}  - print array
# arrayname=("${arrayname[@]}" "value") - append to array

###############################
# Static variables            #
###############################

# TERMINAL COLORS

readonly NONE='\033[00m'
readonly RED='\033[01;31m'
readonly GREEN='\033[01;32m'
readonly YELLOW='\033[01;33m'
readonly BLACK='\033[30m'
readonly BLUE='\033[34m'
readonly VIOLET='\033[35m'
readonly CYAN='\033[36m'
readonly GREY='\033[37m'

###############################
# Dynamic variables and arrays#
###############################


invtool_version="1.0"

# totaldown=0
# totalup=0
# total_clients=0
# total_groups=0
# groups_index=()
# groups_name=()
# groups_id=()



#########################################
# increment and set to 2 decimal places #
#########################################
# function example_function {
#     echo -e "${GREEN}total download:${totaldown} upload:${totalup}${NONE}"
#     echo -e "${GREEN}========================================================${NONE}"
#     echo -e "${YELLOW}total ${totalgroups} groups and ${totalsubs} subgroups ${NONE}"
# }

#########################################
# Process inventory files               #
#########################################
function process_input {
  echo "using $1 as input"

  # Create global array/tree of groups
  unset GROUPS
  declare -A GROUPS

  IFS=','
  for i in $1;
  do
    echo -e "${BLUE}processing $i ${NONE}"
    grp=""
    #f=$(cat -s $i)

    # parse file
    while read -r line
    do
      # GROUPS
      if [[ ${line} = [*  ]]
      then
        #line="${line#?}" # remove [
        #line="${line%?}" # remove ]
        grp=${line}
        echo -e "found group ${grp}"

        # GROUPS already containes this group, process HOSTS
        if [[ " ${GROUPS[@]} " =~ " ${line} " ]]; then
          echo -e "${YELLOW}..duplicate ${line}${NONE}"
        fi

        # GROUPS doesn't contain this group
        if [[ ! " ${GROUPS[@]} " =~ " ${line} " ]]; then
          GROUPS[${grp}]=${grp}
        fi
      else
        # HOSTS
        #GROUPS[${line}]="host_${line}"
        echo -e "....${line} from ${grp}"
      fi


    done < $i
  done

  echo -e "- [ TREE ] ------------------"
  IFS=$'\n'
  echo "${GROUPS[*]}" 
}

###############
# MAIN        #
###############
echo " "
echo "----------------------------------------------------------------------------------------"
echo "Inventory Tool"
echo "----------------------------------------------------------------------------------------"

PARAMS=""
input=""
input_file=""
output_file=""

while (( "$#" )); do
  case "$1" in
    -i|--input)
      FARG=$2
      input=$2
      shift 2
      ;;
    -o|--output)
      FARG=$2
      shift 2
      ;;
    --) #end argument parsing
      shift
      break
      ;;
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) #preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done #set positional arguments in their proper place
eval set -- "$PARAMS"


if [ -n "${input}" ]
then
  process_input $input
else
  echo -e "${RED}NO --input DEFINED!${NONE}"
fi

#exit $?
