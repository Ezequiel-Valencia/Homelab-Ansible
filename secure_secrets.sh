


encrypt(){
  find . -name "secrets.tf" | while read -r file; do
    status=$(sops filestatus "$file" 2>/dev/null)
    if echo "$status" | grep -q '"encrypted":true'; then
      echo "Skipping (already encrypted): $file"
    else
      echo "Encrypting: $file"
      sops --encrypt "$file" > "$file".encrypted
    fi
  done
}


decrypt(){
  export SOPS_AGE_KEY=$(age --decrypt ~/.ssh/sops.priv)
  find . -name "secrets.tf.encrypted" | while read -r file; do
    status=$(sops filestatus "$file" 2>/dev/null)
    if echo "$status" | grep -q '"encrypted":true'; then
      echo "Decrypting: $file"
      dir=$(dirname "$file")
      sops --decrypt "$file" > "$dir/secrets.tf"
    else
      echo "Skipping (already decrypted): $file"
    fi
  done
}

remove_all_decrypted(){
  find . -name "secrets.tf" | while read -r file; do
    echo "Removing secret: $file"
    rm "$file"
  done
}

action="${1:-}"

case "$action" in
  decrypt) decrypt ;;
  encrypt) encrypt ;;
  clean_up) remove_all_decrypted ;;
  *) echo "Usage: secure_secrets [decrypt|encrypt|clean_up]"; return 1 ;;
esac


