ID=$(id -u)
if [ $ID -ne 0 ]; then
  echo You should run this Script as a Root User or Sudo User
  exit 1
fi

StatusCheck() {
  if [ $1 -eq 0 ]; then
    echo -e Status = "\e[32mSUCCESS\e[0m"
  else
    echo -e Status = "\e[32mSUCCESS\e[0m"
    exit 1
  fi
}