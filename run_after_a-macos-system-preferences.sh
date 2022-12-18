#!/bin/bash
# Modified by Zouhir from ~/.macos — https://mths.be/macos

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
# osascript -e 'tell application "System Preferences" to quit'

# # Ask for the administrator password upfront
# sudo -v

# # Keep-alive: update existing `sudo` time stamp until `.macos` has finished
# while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# # System
# # Require password immediately after sleep or screen saver begins"
# defaults write com.apple.screensaver askForPassword -int 1
# defaults write com.apple.screensaver askForPasswordDelay -int 0
# # Enable highlight hover effect for the grid view of a stack (Dock)
# defaults write com.apple.dock mouse-over-hilite-stack -bool true

# # Set the icon size of Dock items to 46 pixels
# defaults write com.apple.dock tilesize -int 46
# # Enable spring loading for all Dock items
# defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true
# # Show indicator lights for open applications in the Dock
# defaults write com.apple.dock show-process-indicators -bool true
# # Don’t animate opening applications from the Dock
# defaults write com.apple.dock launchanim -bool false

# # Speed up Mission Control animations
# defaults write com.apple.dock expose-animation-duration -float 0.1
# # Don’t group windows by application in Mission Control
# # (i.e. use the old Exposé behavior instead)
# defaults write com.apple.dock expose-group-by-app -bool false
# # Disable Dashboard
# defaults write com.apple.dashboard mcx-disabled -bool true
# # Don’t show Dashboard as a Space
# defaults write com.apple.dock dashboard-in-overlay -bool true
# # Don’t automatically rearrange Spaces based on most recent use
# defaults write com.apple.dock mru-spaces -bool false
# # Remove the auto-hiding Dock delay
# defaults write com.apple.dock autohide-delay -float 0
# # Remove the animation when hiding/showing the Dock
# defaults write com.apple.dock autohide-time-modifier -float 0

# # Automatically hide and show the Dock
# defaults write com.apple.dock autohide -bool true

# # Make Dock icons of hidden applications translucent
# defaults write com.apple.dock showhidden -bool true

# # Don’t show recent applications in Dock
# defaults write com.apple.dock show-recents -bool false
# # Add iOS & Watch Simulator to Launchpad
# sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app" "/Applications/Simulator.app"
# sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator (Watch).app" "/Applications/Simulator (Watch).app"
# # Expand save panel by default
# defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
# defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
# # Disable the “Are you sure you want to open this application?” dialog
# defaults write com.apple.LaunchServices LSQuarantine -bool false

# # UI
# # Set highlight color to green
# defaults write NSGlobalDomain AppleHighlightColor -string "0.764700 0.976500 0.568600"
# # Set sidebar icon size to medium
# defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2
# # Possible values: `WhenScrolling`, `Automatic` and `Always`
# # Disable the over-the-top focus ring animation
# defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false
# # Adjust toolbar title rollover delay
# defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 0
# # Increase window resize speed for Cocoa applications
# defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
# # Hot corners
# # Possible values:
# #  0: no-op
# #  2: Mission Control
# #  3: Show application windows
# #  4: Desktop
# #  5: Start screen saver
# #  6: Disable screen saver
# #  7: Dashboard
# # 10: Put display to sleep
# # 11: Launchpad
# # 12: Notification Center
# # 13: Lock Screen
# # Top left screen corner → Mission Control
# defaults write com.apple.dock wvous-tl-corner -int 2
# defaults write com.apple.dock wvous-tl-modifier -int 0
# # Top right screen corner → Desktop
# defaults write com.apple.dock wvous-tr-corner -int 4
# defaults write com.apple.dock wvous-tr-modifier -int 0
# # Bottom left screen corner → Start screen saver
# defaults write com.apple.dock wvous-bl-corner -int 5
# defaults write com.apple.dock wvous-bl-modifier -int 0

# # Keyboard
# # Disable press-and-hold for keys in favor of key repeat
# defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# # Set a blazingly fast keyboard repeat rate
# defaults write NSGlobalDomain KeyRepeat -int 1
# defaults write NSGlobalDomain InitialKeyRepeat -int 10

# # Language
# # Enable text replacement almost everywhere"
# defaults write -g WebAutomaticTextReplacementEnabled -bool true

# # Disable automatic capitalization as it’s annoying when typing code
# defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# # Disable smart dashes as they’re annoying when typing code
# defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# # Disable automatic period substitution as it’s annoying when typing code
# defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# # Disable smart quotes as they’re annoying when typing code
# defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# # Disable auto-correct
# defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# # Mouse & Trackpad
# # Trackpad: enable tap to click for this user and for the login screen
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
# defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# # Trackpad: map bottom right corner to right-click
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
# defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
# defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# # Disable “natural” (Lion-style) scrolling
# defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# # Finder
# # Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
# defaults write com.apple.finder QuitMenuItem -bool true

# # Finder: disable window animations and Get Info animations
# defaults write com.apple.finder DisableAllAnimations -bool true

# # Set Desktop as the default location for new Finder windows
# # For other paths, use `PfLo` and `file:///full/path/here/`
# defaults write com.apple.finder NewWindowTarget -string "PfDe"
# defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"


# # Finder: show all filename extensions
# defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# # Finder: show status bar
# defaults write com.apple.finder ShowStatusBar -bool true

# # Finder: show path bar
# defaults write com.apple.finder ShowPathbar -bool true

# # Display full POSIX path as Finder window title
# defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# # Keep folders on top when sorting by name
# defaults write com.apple.finder _FXSortFoldersFirst -bool true

# # When performing a search, search the current folder by default
# defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# # Disable the warning when changing a file extension
# defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# # Enable spring loading for directories
# defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# # Remove the spring loading delay for directories
# defaults write NSGlobalDomain com.apple.springing.delay -float 0

# # Avoid creating .DS_Store files on network or USB volumes
# defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# # Automatically open a new Finder window when a volume is mounted
# defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
# defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
# defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true
# # Use list view in all Finder windows by default
# # Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
# defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# # Disable the warning before emptying the Trash
# defaults write com.apple.finder WarnOnEmptyTrash -bool false

# # Enable AirDrop over Ethernet and on unsupported Macs running Lion
# defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true
# # Expand the following File Info panes:
# # “General”, “Open with”, and “Sharing & Permissions”
# defaults write com.apple.finder FXInfoPanesExpanded -dict \
# 	General -bool true \
# 	OpenWith -bool true \
# 	Privileges -bool true

# # Safari
# # Enable the Develop menu and the Web Inspector in Safari
# defaults write com.apple.Safari IncludeDevelopMenu -bool true
# defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
# defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# # Add a context menu item for showing the Web Inspector in web views
# defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# # iMessage
# # Disable automatic emoji substitution (i.e. use plain text smileys)
# defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false

# # Disable smart quotes as it’s annoying for messages that contain code
# defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

# # Disable continuous spell checking
# defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false


# for app in "Activity Monitor" \
# 	"Address Book" \
# 	"Calendar" \
# 	"cfprefsd" \
# 	"Contacts" \
# 	"Dock" \
# 	"Finder" \
# 	"Google Chrome Canary" \
# 	"Google Chrome" \
# 	"Mail" \
# 	"Messages" \
# 	"Opera" \
# 	"Photos" \
# 	"Safari" \
# 	"SizeUp" \
# 	"Spectacle" \
# 	"SystemUIServer" \
# 	"Terminal" \
# 	"Transmission" \
# 	"Tweetbot" \
# 	"Twitter" \
# 	"iCal"; do
# 	killall "${app}" &> /dev/null
# done
# echo "Done. Note that some of these changes require a logout/restart to take effect."