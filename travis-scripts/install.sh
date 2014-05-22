#!/bin/bash -v

# -v makes this script print commands before executing them

# install dependencies from Homebrew
brew upgrade xctool

# update CocoaPods
gem update cocoapods --no-ri --no-rdoc

# install gems
bundle install

# install pods
bundle exec pod install
