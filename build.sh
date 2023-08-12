#!/bin/bash

# [ docker | podman ]
container_cmd=""

# [ true | false ]
env_check=""

function check_env() {
  local result_found error_count=0 error_files="" filename_space="";
  [[ -z ${env_check} ]] && env_check=true;
  if [[ "$(tr '[:upper:]' '[:lower:]' <<<$env_check)" == "true" ]]; then
    for f in $(find . -name *build-env | sort | sed 's|^\./||g'); do
      echo -n "Checking ENV: ${root_dir}/$f ";
      cat ${root_dir}/$f | \
        grep -nE "(^[^a-zA-Z_# ])|(['\"]+)|(^[a-zA-Z\_ ]+[a-zA-Z0-9\!-<>-$]*$)|(^[a-zA-Z\_]+[a-zA-Z0-9\!-<>-]*[ ]+)" | \
        sed -e "/^[0-9]\+:\s*#.*/d; s/^\([0-9]\+:\)\s\+/\1/" | \
        sed -e "s/\([\'\"]\)\s*#.*/\1/" | \
        grep -qvE "(=(('')|(\"\")|('[^\"']*'$)|(\"[^\"']*\"$)))";
      result_found="$?";
      
      if [[ "${result_found}" == 0 ]]; then
        echo "ERROR";
        error_count=$(( error_count + 1 ))
        error_files="${error_files}| - ${root_dir}/${f}"
        filename_space="|"
        echo "- - - - - - - - - - - - - - - -"
        cat ${root_dir}/$f | \
          grep -nE "(^[^a-zA-Z_# ])|(['\"]+)|(^[a-zA-Z\_ ]+[a-zA-Z0-9\!-<>-$]*$)|(^[a-zA-Z\_]+[a-zA-Z0-9\!-<>-]*[ ]+)" | \
          sed -e "/^[0-9]\+:\s*#.*/d; s/^\([0-9]\+:\)\s\+/\1/" | \
          sed -e "s/\([\'\"]\)\s*#.*/\1/" | \
          grep -vE "(=(('')|(\"\")|('[^\"']*'$)|(\"[^\"']*\"$)))" | \
          sed -e "s/^\([0-9]\+\):\([a-zA-Z0-9\!-<>-$]\+\)=\([a-zA-Z0-9\!-$ ]\+\)/Line \1: \2 = \3 \t<-- (invalid value)/g; s/^\([0-9]\+\):\([a-zA-Z0-9\!-$ ]*\)/Line \1: \2 \t<-- (invalid name format or no '=')/g"
          
        # cannot put comment on multiline command, adding it here
        # grep -nE "(['\"]+)|(^[0-9])|(^[a-zA-Z\_ ]+[a-zA-Z0-9\!-<>-$]*$)|(^[a-zA-Z\_]+[a-zA-Z0-9\!-<>-]*[ ]+)" | \  # find possibbly invalid ENV
        # sed -e "/^[0-9]\+:\s*#.*/d; s/^\([0-9]\+:\)\s\+/\1/"                # remove comment line and leading whitespace before varname
        # sed -e "s/\([\'\"]\)\s*#.*/\1/" | \                                 # adding single double quotes
        # grep -vE "(=(('')|(\"\")|('[^\"']*'$)|(\"[^\"']*\"$)))" | \         # reverse remove valid ENV FORMAT
        # grep --colour -E "^[a-zA-Z0-9\!-<>-$]+[^=]";                        # Just for COLORING
        # sed -e "s/^\([0-9]\+\):\([a-zA-Z0-9\!-<>-$]\+\)=\([a-zA-Z0-9\!-$ ]\+\)/Line \1: \2 = \3 \t<-- (invalid value)/g; s/^\([0-9]\+\):\([a-zA-Z0-9\!-$ ]*\)/Line \1: \2 \t<-- (invalid name format or no '=')/g"
        echo ""
      else
        echo "OK";
      fi
    done

    echo -e "\n### - - - - - -- - check_env summary - - - -- - - - - -"
    echo    "error_count: ${error_count} file(s)"
    if [[ $error_count -gt 0 ]]; then
      echo "error_files: $(echo ${error_files} | tr '|' '\n')"
      echo -e  "\nWARNING: \nbuild-env check results are based on predefined basic validation and may not cover all scenarios."
      echo -e   "### - - - - - - - - - - - - - - - - - - - - - - - - - -\n"
      exit 1
    fi
    echo -e  "\nWARNING: \nbuild-env check results are based on predefined basic validation and may not cover all scenarios."
    echo -e   "### - - - - - - - - - - - - - - - - - - - - - - - - - -\n"
  else
    echo "Skipping ENV Check..."
  fi
}

function source_safe() {
  local source_files="$@"
  # echo "sourcing: $source_files"
  source <(
    for src in ${source_files}; do
      cat ${src}; echo
    done | \
    grep -vE "^(([a-zA-Z\_]+[a-zA-Z0-9\-\_]*=$)|#|$)" | \
    sed -e "s/^[ \t]\+//" | \
    sed -e "s/\([\'\"]\)\s*#.*/\1/; s/\s#.*[^\'\"]$//; s/[\'\"]//g; s/=/='/; s/$/'/"

    # cannot put comment on multiline command, adding it here
  # grep -vE "^(([a-zA-Z\_]+[a-zA-Z0-9\-\_]*=$)|#|$)" | \     # Reverse grep for possibly invalid line for env variable
  # sed -e "s/^[ \t]\+//" | \                                 # remove leading whitespace, so we can load it
  # sed -e "s/\([\'\"]\)\s*#.*/\1/; s/\s#.*[^\'\"]$//; s/[\'\"]//g; s/=/='/; s/$/'/"        # Add and remove some characters
  )
}

function image_push_tag() {
  source_image_tag="$1"
  dest_image_tag="$2"
  push_image="$3"
  echo "TAG: ${source_image_tag} > ${dest_image_tag}"
  echo "RUN: ${container_cmd} tag ${source_image_tag} ${dest_image_tag}"
  ${container_cmd} tag ${source_image_tag} ${dest_image_tag}

  if [[ ! -z ${push_image} && "${push_image}" == "true" ]]; then
    echo "PUSH: ${dest_image_tag}"
    echo "RUN: ${container_cmd} push ${dest_image_tag}"
    ${container_cmd} push "${dest_image_tag}"
  fi
}

function image_build() {
  local env_parent env_subdir env_all="" env_files="" env_overwrite="";
  env_parent="${build_context_parent}/.build-env"
  env_subdir="${build_context_dir}/.build-env"
  [[ -f $env_parent ]] && env_files="${env_files} ${env_parent}"
  [[ -f $env_subdir ]] && env_files="${env_files} ${env_subdir}"

  if [[ ! -z ${env_files} ]]; then
    env_all="$(
      grep -vhE "^(([a-zA-Z\_]+[a-zA-Z0-9\-\_]*=$)|#|$)" ${BUILD_ENV} ${env_files} | \
      sed -e "s/^[ \t]\+//; s/=.*//" | \
      sort -u | tr '\n' ' ')
      "
    env_overwrite=$(
      grep -vhE "^(([a-zA-Z\_]+[a-zA-Z0-9\-\_]*=$)|#|$)" ${env_files} | \
      sed -e "s/^[ \t]\+//; s/=.*//" | \
      sort -u | tr '\n' ' '
    )
    local ${env_overwrite}
  else
    env_all="$(
      grep -vhE "^(([a-zA-Z\_]+[a-zA-Z0-9\-\_]*=$)|#|$)" ${BUILD_ENV} ${env_files} | \
      sed -e "s/^[ \t]\+//; s/=.*//" | \
      sort -u | tr '\n' ' ')
      "
  fi
  if [[ -f ${env_parent} ]]; then
    echo -e "\nINFO: found ${env_parent}"
    source_safe "${env_parent}"
  fi
  if [[ -f ${env_subdir} ]]; then
    echo "INFO: found ${env_subdir}"
    source_safe "${env_subdir}"
  fi
  echo -e "ENV Overwrite: ${env_overwrite}"

  echo -e "\n### - - - - - build-env - - - - - - -"
  for e in ${env_all}; do 
    echo "${e}: ${!e}"
  done
  echo -e   "### - - - - - - - - - - - - - - - - -\n"
  
  if [[ ! -z ${SOURCE_NAME} && ! -z $SOURCE_TAG} ]]; then
    build_image_arg="--build-arg SOURCE_IMAGE=${SOURCE_NAME}:${SOURCE_TAG}"
    echo "ARGS: ${build_image_arg}"
  else
    echo "ARGS: ${build_image_arg} (NO args)"
  fi

  build_image_cmd="${container_cmd} build ${build_image_arg} -t ${build_image_tag} ${build_context_dir}"
  echo "Building image: ${build_image_tag}"
  echo "RUN : ${build_image_cmd}"
  ${build_image_cmd}
  
  repo_list=$(echo "$BUILD_REPOS" | sed 's/,/ /g')
  env_latest=$(tr '[:upper:]' '[:lower:]' <<<$BUILD_LATEST)
  env_push=$(tr '[:upper:]' '[:lower:]' <<<$PUSH_IMAGE)

  BUILD_NAME="${main_dir}"
  BUILD_TAG="${subdir}"
  for repo in $repo_list; do
    echo ""
    image_push_tag "${build_image_tag}" "$repo/$BUILD_NAME:$BUILD_TAG" "${env_push}"
    if [ "$env_latest" == "true" ]; then
      echo -e "\nTAG: mark as latest > $repo/$BUILD_NAME:latest"
      image_push_tag "${build_image_tag}" "$repo/$BUILD_NAME:latest" "${env_push}"
    fi
  done
}

### - - - - - - - - Start Here
root_dir=${PWD}
BUILD_ENV="${root_dir}/.build-env"
if [ -f ${BUILD_ENV} ]; then
    check_env;
    echo -e "Loading BUILD_ENV: ${BUILD_ENV}"
    source_safe "${BUILD_ENV}"

    if [[ -z ${container_cmd} ]]; then
      if [[ $(which docker) ]]; then
        container_cmd="docker"
        echo "container_cmd: ${container_cmd}"
      elif [[ $(which podman) ]]; then
        container_cmd="podman"
        echo "container_cmd: ${container_cmd}"
      fi
    else
      echo "container_cmd: ${container_cmd}"
    fi

    echo -n "TEST_CMD: '${container_cmd} info' ... "
    if [[ ! $(${container_cmd} info) ]]; then
      echo "Failed"
      echo "ERROR: running command '${container_cmd} info'"
      exit 1
    else
      echo "OK"
    fi
      set -e
      for main_dir in $(cat containerfiles-dir.txt); do
        build_context_parent="${root_dir}/${main_dir}"
        echo -e "\n# = = = = = = = = = = = = = = = = = = =  = = ="
        echo -e   " * build_context_parent: ${build_context_parent}"
        if [[ -d "${build_context_parent}" ]]; then
          context_subdirs=$(ls ${build_context_parent})
          for subdir in ${context_subdirs}; do
            build_context_dir="${build_context_parent}/${subdir}"
            echo -e "\n> - - - - - - - - - - - - - - - - - - - - - -"
            echo -e    " - build_context_dir: ${build_context_dir}"
            ls -lah ${build_context_dir} | tail -n+4

            build_image_tag="${main_dir}:${subdir}"
            image_build;

          done
        else
          echo "Skipping ${build_context_parent}, directory does not exist! "
        fi
      done
else
    cat ${root_dir}/usage.md
    echo ""
    echo "- - - - - - - - - - - - - - - - - - -"
    echo "Generating sample... '.build-env'"
    cat ${root_dir}/usage.md | grep "=" > .build-env
fi

echo 'Finish'