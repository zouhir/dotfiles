#!/bin/bash
set -euo pipefail

# Interface and typing
defaults write NSGlobalDomain AppleInterfaceStyle -string Dark
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Trackpad
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Dock and desktop
defaults write com.apple.dock tilesize -int 48
defaults write com.apple.dock mineffect -string scale
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.3
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.WindowManager StandardHideWidgets -bool true

# Finder
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXPreferredViewStyle -string Nlsv
defaults write com.apple.finder FXDefaultSearchScope -string SCcf
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
chflags nohidden ~/Library

# Screenshots
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"
defaults write com.apple.screencapture disable-shadow -bool true

# Ctrl+1..9 switches desktops. Create nine desktops once in Mission Control.
for i in 1 2 3 4 5 6 7 8 9; do
    keycode=(0 18 19 20 21 23 22 26 28 25)
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add $((117 + i)) \
        "{enabled = 1; value = {parameters = ($((48 + i)), ${keycode[$i]}, 262144); type = standard;};}"
done
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

# Sleep: never on the charger, normal on battery.
sudo pmset -c sleep 0 displaysleep 10
sudo pmset -b sleep 5 displaysleep 2

killall Dock Finder SystemUIServer 2>/dev/null || true
