#!/bin/sh

#
TEAM_ID=
PROVISIONING_PROFILE=

# project
SCHEME_NAME=BitTrader
EXPORT_PATH=$HOME/Desktop/build
EXPORT_OPTIONS_PLIST=exportOptions.plist

#
WORKSPACE_NAME=$SCHEME_NAME.xcworkspace
ARCHIVE_PATH=$EXPORT_PATH/$SCHEME_NAME.xcarchive

#
sed -i "" -e "s/TEAM_ID/$TEAM_ID/" $EXPORT_OPTIONS_PLIST

# archive
xcodebuild -scheme "$SCHEME_NAME" -workspace "$WORKSPACE_NAME" -sdk iphoneos -archivePath "$ARCHIVE_PATH" -configuration Release PROVISIONING_PROFILE="$PROVISIONING_PROFILE" archive
# ipa
xcodebuild -exportArchive -archivePath "$ARCHIVE_PATH" -exportOptionsPlist "$EXPORT_OPTIONS_PLIST" -exportPath "$EXPORT_PATH"