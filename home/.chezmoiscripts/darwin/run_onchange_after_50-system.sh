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
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

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

# Pinned Dock apps, in order. Apps that aren't installed are skipped.
defaults write com.apple.dock persistent-apps -array
for app in "Google Chrome" Ghostty Codex Claude; do
    for dir in /Applications "$HOME/Applications"; do
        [ -d "$dir/$app.app" ] || continue
        defaults write com.apple.dock persistent-apps -array-add \
            "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$dir/$app.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
        break
    done
done

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
# This needs XML: the {...} form stores booleans and integers as strings.
keycodes=(18 19 20 21 23 22 26 28 25)
for i in "${!keycodes[@]}"; do
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add $((118 + i)) \
        "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>${keycodes[$i]}</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>"
done
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

# Sleep: never on the charger, normal on battery.
sudo pmset -c sleep 0 displaysleep 10
sudo pmset -b sleep 5 displaysleep 2

killall Dock Finder SystemUIServer 2>/dev/null || true
