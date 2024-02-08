#!/usr/bin/env bash

encrypt(){
  pass=$1
  input=$2
  output=$3
  gpg --batch --yes --passphrase="$pass" --cipher-algo AES256 --symmetric --output "$output" "$input"
}

# when ENCRYPT_KEY env is set, encrypt secrets
if [[ -n "$ENCRYPT_KEY" ]]; then
  encrypt "$ENCRYPT_KEY" release/google-services.json release/google-services.gpg
  encrypt "$ENCRYPT_KEY" release/Firebase/Debug/firebase_app_id_file.json release/Firebase/Debug/firebase_app_id_file.gpg
  encrypt "$ENCRYPT_KEY" release/Firebase/Debug/GoogleService-Info.plist release/Firebase/Debug/GoogleService-Info.gpg
  encrypt "$ENCRYPT_KEY" release/Firebase/Production/firebase_app_id_file.json release/Firebase/Production/firebase_app_id_file.gpg
  encrypt "$ENCRYPT_KEY" release/Firebase/Production/GoogleService-Info.plist release/Firebase/Production/GoogleService-Info.gpg
  encrypt "$ENCRYPT_KEY" release/local.env release/local.gpg
else
  echo "ENCRYPT_KEY environment is not set, skipping encryption"
fi
