#!/bin/bash
#
# Sane macOS defaults for a new machine.
# Run once, then log out / restart for all changes to take effect.
#
set -e

echo "Applying macOS defaults..."

# Close System Preferences to prevent overriding changes
osascript -e 'tell application "System Preferences" to quit' 2>/dev/null || true

# ─── General UI ──────────────────────────────────────────────

# Dark mode
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable "Are you sure you want to open this application?"
defaults write com.apple.LaunchServices LSQuarantine -bool false

# ─── Keyboard & Input ───────────────────────────────────────

# Fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2

# Short delay until key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Disable automatic capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Disable smart dashes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable period substitution (double-space → period)
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# ─── Trackpad ────────────────────────────────────────────────

# Tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# ─── Dock ────────────────────────────────────────────────────

# Set icon size
defaults write com.apple.dock tilesize -int 48

# Minimize windows using scale effect (faster than genie)
defaults write com.apple.dock mineffect -string "scale"

# Don't show recent applications
defaults write com.apple.dock show-recents -bool false

# Auto-hide the Dock
defaults write com.apple.dock autohide -bool true

# Remove auto-hide delay
defaults write com.apple.dock autohide-delay -float 0

# Speed up auto-hide animation
defaults write com.apple.dock autohide-time-modifier -float 0.3

# ─── Finder ──────────────────────────────────────────────────

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Default to list view
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable warning when changing file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Show the ~/Library folder
chflags nohidden ~/Library

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# ─── Screenshots ─────────────────────────────────────────────

# Save screenshots to ~/Screenshots
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"

# Save screenshots as PNG
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# ─── Safari ──────────────────────────────────────────────────

# Show the full URL in the address bar
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Enable the Develop menu and Web Inspector
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true

# ─── Activity Monitor ───────────────────────────────────────

# Show all processes
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# ─── TextEdit ────────────────────────────────────────────────

# Use plain text mode by default
defaults write com.apple.TextEdit RichText -int 0

# ─── Restart affected apps ──────────────────────────────────

echo "Restarting affected apps..."
for app in "Dock" "Finder" "SystemUIServer"; do
    killall "$app" &>/dev/null || true
done

echo "macOS defaults applied. Some changes require a logout/restart."
