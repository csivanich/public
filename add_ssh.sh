#!/usr/bin/env bash

VERSION='0.1.0'
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KEY_DIR="$BASE_DIR/ssh"

usage(){
    echo "USAGE: $0 <key_file>"
    echo "VERSION ${VERSION}"
}

fail(){
    echo "$*" >&2
    exit 1
}


is_private_key(){
    key_file=$1
    test -r || return 1
    grep "BEGIN RSA PRIVATE KEY" < $key_file &>/dev/null
}

if [ $# -lt 1 ];then
    usage
    fail "Missing key_file"
fi


key_file="$1"
is_private_key "$key_file" && key_file="${key_file}.pub"
key_id="$( cat $key_file | cut -d ' ' -f3 )"

echo "Backup ${key_id}? (y/N)"
read answer

[[ "$answer" != "y" ]] && fail "Exited on user request."
test -d "$KEY_DIR" || mkdir -p "$KEY_DIR" || fail "Could not create directory $KEY_DIR"
cp "$key_file" -v "$KEY_DIR/${key_id}.pub"

exit 0
