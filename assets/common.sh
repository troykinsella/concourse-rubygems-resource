
attr() {
  local type=$1
  local name=$2
  local val=$(jq -r ".$type.$name // \"\"" < $payload)
  test -z "$val" && { echo "Must supply '$name' $type attribute"; exit 1; }
  echo $val
}

configure_credentials() {
  local creds=$(jq -r '.source.credentials // ""' < $payload)
  if [ -n "$creds" ]; then
    mkdir -p ~/.gem
    local creds_file=~/.gem/credentials

    touch $creds_file
    chmod 600 $creds_file
    echo "$creds" > $creds_file
  fi
}

source_option() {
  local opt_name=${1:-"--source"}
  local source_url=$(jq -r '.source.source_url // ""' < $payload)
  if [ -n "$source_url" ]; then
    echo "$opt_name $source_url"
  fi
}

prerelease_option() {
  local pre=$(jq -r '.source.prerelease // false' < $payload)
  if [ "$pre" = "true" ]; then
    echo "--prerelease"
  fi
}
