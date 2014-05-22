#!/bin/bash -v

# -v makes this script print commands before executing them

# Print relevant environment variables for reference in the build log
printenv | egrep XCODE | sort

set -e

# Build, and optionally run tests, depending on the value of the test flag
xctool -workspace "$TRAVIS_XCODE_WORKSPACE" -scheme "$TRAVIS_XCODE_SCHEME" -sdk "$TRAVIS_XCODE_SDK" "$TWT_XCODE_BUILD_ACTION"
