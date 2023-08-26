#!/usr/bin/env bash
# Credits: Chris Banes, https://github.com/chrisbanes/tivi/blob/d12ed3bb39c7869bdead03a686669ed4c0d32e57/release/decrypt-secrets.sh
decrypt(){
  pass=$1
  input=$2
  output=$3
  gpg --quiet --batch --yes --decrypt --passphrase="$pass" --output "$output" "$input"
}

if [[ -n "$ENCRYPT_KEY" ]]; then
  decrypt "$ENCRYPT_KEY" release/google-services.gpg android/app/google-services.json
  decrypt "$ENCRYPT_KEY" release/Firebase/Debug/firebase_app_id_file.gpg ios/Runner/Firebase/Debug/firebase_app_id_file.json
  decrypt "$ENCRYPT_KEY" release/Firebase/Debug/GoogleService-Info.gpg ios/Runner/Firebase/Debug/GoogleService-Info.plist
  decrypt "$ENCRYPT_KEY" release/Firebase/Production/firebase_app_id_file.gpg ios/Runner/Firebase/Production/firebase_app_id_file.json
  decrypt "$ENCRYPT_KEY" release/Firebase/Production/GoogleService-Info.gpg ios/Runner/Firebase/Production/GoogleService-Info.plist
  decrypt "$ENCRYPT_KEY" release/local.gpg config/local.env
else
  echo "ENCRYPT_KEY environment is not set, skipping encryption"
fi
