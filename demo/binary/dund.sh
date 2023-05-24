#!/bin/bash

port=8080

tomcat_path=/home/nico/apache
webapps=webapps
script_path=$(readlink -f "$0")
script_dir=$(dirname "$script_path")
war_file_path=$(find "$script_dir" -type f -name "*.war")
war_filename="$(basename "$war_file_path")"
username=""
password=""
endpoint=""

function undeploy {
  apps_directory="$tomcat_path""/""$webapps""/"
  deployed_file="$apps_directory""$war_filename"
  if [ -f "$deployed_file" ]
  then
    rm "$deployed_file"
    echo "$war_filename was removed"
  else
    echo "$war_filename was not found in $apps_directory"
  fi

  deployed_directory="${deployed_file%.*}"
  if [ -d "$deployed_directory" ]
  then
    directory="${deployed_directory%.*}"
    rm -R "$directory"
    echo "${war_filename%.*} was removed from $apps_directory"
  else
    echo "${war_filename%.*} was not found in $apps_directory"
  fi
}

function deploy {
  if [ ! -f "$war_file_path" ]
  then
    echo "$war_filename was not found"
    echo "Check if it is in the directory with this script"
    exit 1
  fi

  apps_directory="$tomcat_path""/""$webapps""/"
  cp "$war_file_path" "$apps_directory"
  echo "$war_filename was placed in $apps_directory"
}

function curl_undeploy {
  if [[ -n ${username+x} ]] && [[ -n ${password+x} ]]
  then
    res=$(curl -o /dev/null -s -w "%{http_code}" -u "$username"":""$password" http://localhost:"$port"/manager/text/undeploy?path=/"${war_filename%.*}")
      echo "Response:"
      echo $res
  fi
}

function curl_deploy {
  if [[ -n ${username+x} ]] && [[ -n ${password+x} ]]
  then
    res=$(curl -o /dev/null -s -w "%{http_code}" -u "$username"":""$password" http://localhost:"$port"/manager/text/deploy?path=/"$endpoint""&war=file:""$war_file_path""&update=true")
    echo "Response:"
    echo $res
  fi
}

for opt in "$@"
do
  case $opt in
    -u)
      echo "Try to undeploy"
      undeploy
      ;;
    -d)
      echo "Try to deploy"
      deploy
      ;;
    -tomcat_path)
      tomcat_path=$2
      ;;

    --username=*)
      username="${1#*=}"
      ;;
    --password=*)
      password="${1#*=}"
      ;;
    --endpoint=*)
      endpoint="${1#*=}"
      ;;
    --war_path=*)
      war_file_path="${1#*=}"
      ;;
    --port=*)
      port="${1#*=}"
      ;;
    --uc)
      echo "Try to undeploy using curl"
      curl_undeploy
      ;;
    --dc)
      echo "Try deploy using curl"
      curl_deploy
      ;;
    *) echo "Invalid option: $opt"
  esac
  shift
done