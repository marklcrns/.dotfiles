if [[ -n $VIRTUAL_ENV && -e "${VIRTUAL_ENV}/bin/activate" ]]; then
  source "${VIRTUAL_ENV}/bin/activate"
fi

# Export Windows username if in WSL
if [[ "$(grep -i microsoft /proc/version)" ]]; then
  # 2>/dev/null to suppress UNC paths are not supported error
  export WIN_USERNAME=$(cmd.exe /c "<nul set /p=%USERNAME%" 2>/dev/null)
fi
