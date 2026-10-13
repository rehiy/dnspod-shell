@echo off

SET Program86path=C:\"Program Files (x86)"\Git\bin\bash.exe
SET Program64path=C:\"Program Files"\Git\bin\bash.exe

if exist %Program86path% (
  start /b %Program86path% ddnspod.sh
) else (
  if exist %Program64path% (
    start /b %Program64path% ddnspod.sh
  ) else (
    echo "No git bash found, please install git bash"
  )
)

exit 0