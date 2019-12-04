#!/bin/bash

#  Created by Alex Karahalios on 6/12/11
#  Edited by Brian Reinhart on 08/02/2012.
#  Last edited by Mark Klara (MrHappyAsthma) on 08/29/2016.
#
# Updates Xcode and to support LUA language for editing
#

# Parse command line flags.
for flag in "$@"
do
  case $flag in
    --beta)
    BETA=true
    shift  # Shift past argument with no value.
    ;;
    *)
           # Unknown argument.
    ;;
  esac
done

# Path were this script is located
#
SCRIPT_PATH="$(dirname "$BASH_SOURCE")"

# Filename path private framework we need to modify

# This framework is found withing the Xcode.app package and is used when Xcode is a monolithic
# install (all contained in Xcode.app)
#
  DVTFOUNDATION_LANGUAGE_PATH="/Applications/Xcode.app/Contents/SharedFrameworks/SourceModel.framework/Versions/A/Resources/LanguageSpecifications/"

  DVTFOUNDATION_METEDATA_PATH="/Applications/Xcode.app/Contents/SharedFrameworks/SourceModel.framework/Versions/A/Resources/LanguageMetadata/"


# Create Plist file of additional languages to add to 'DVTFoundation.xcplugindata'
#
cat >Xcode.SourceCodeLanguage.Lua.plist <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>commentSyntax</key>
	<array>
		<dict>
			<key>prefix</key>
			<string>--[[</string>
			<key>suffix</key>
			<string>]]</string>
		</dict>
		<dict>
			<key>prefix</key>
			<string>--</string>
		</dict>
	</array>
	<key>conformsToLanguageIdentifiers</key>
	<array>
		<string>Xcode.SourceCodeLanguage.Generic</string>
	</array>
	<key>documentationAbbreviation</key>
	<string>lua</string>
	<key>fileDataTypeIdentifiers</key>
	<array>
		<string>com.apple.xcode.lua-source</string>
	</array>
	<key>identifier</key>
	<string>Xcode.SourceCodeLanguage.Lua</string>

	<key>languageName</key>
	<string>Lua</string>
	<key>languageSpecification</key>
	<string>xcode.lang.lua</string>
</dict>
</plist>
EOF

cp Xcode.SourceCodeLanguage.Lua.plist "$DVTFOUNDATION_METEDATA_PATH"

# Get rid of the AdditionalLanguages.plist since it was just temporary
#
rm -f Xcode.SourceCodeLanguage.Lua.plist

# Copy in the xclangspecs for the languages (assumes in same directory as this shell script)
#
cp "$SCRIPT_PATH/Lua.xclangspec" "$DVTFOUNDATION_LANGUAGE_PATH"

# Remove any cached Xcode plugins
#
rm -f /private/var/folders/*/*/*/com.apple.DeveloperTools/*/Xcode/PlugInCache*.xcplugincache
