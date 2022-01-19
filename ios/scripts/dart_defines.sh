#!/bin/zsh

ITEMS=($(echo $DART_DEFINES | tr "," "\n"))

for ITEM in ${ITEMS[@]}; do 
  DECODED_ITEM=$(echo $ITEM | base64 --decode)
  echo $DECODED_ITEM | grep "FLAVOR"
  if [ $? = 0 ]; then
    FLAVOR=${DECODED_ITEM#*=}
    break
  fi
done

if [ $FLAVOR = "Production" ]; then
  DISPLAY_NAME="A Flutter"
  BUNDLE_IDENTIFIER="tech.watanave.MyFlutterPlayground"
else
  DISPLAY_NAME="A Mock"
  BUNDLE_IDENTIFIER="tech.watanave.MyFlutterPlayground.mock"
fi

INFO_PLIST_PATH="${TEMP_DIR}/Preprocessed-Info.plist"
PLIST_BUDDY="/usr/libexec/PlistBuddy"

$PLIST_BUDDY -c "Set :CFBundleDisplayName $DISPLAY_NAME" $INFO_PLIST_PATH
$PLIST_BUDDY -c "Set :CFBundleIdentifier $BUNDLE_IDENTIFIER" $INFO_PLIST_PATH
