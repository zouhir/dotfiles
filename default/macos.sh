#!/usr/bin/env bash

###############################################################################
# Dock                                                                        #
###############################################################################
defaults write com.apple.dock "tilesize" -int "36"
defaults write com.apple.dock "autohide" -bool "true"
defaults write com.apple.dock "autohide-time-modifier" -float "0"
# Dock only opens if the mouse doesn't move for 0.4 seconds.
defaults write com.apple.dock "autohide-delay" -float "0.4"
defaults write com.apple.dock "show-recents" -bool "false"
# No over-the-top Dock minimize animation.
defaults write com.apple.dock "mineffect" -string "scale"

###############################################################################
# Sleep settings                                                              #
###############################################################################
# Disable machine sleep while charging
sudo pmset -c sleep 0
# Sleep the display after 15 minutes
sudo pmset -a displaysleep 15
# Set machine sleep to 15 minutes on battery
sudo pmset -b sleep 15
# Set standby delay to 24 hours (default is 1 hour)
sudo pmset -a standbydelay 86400

###############################################################################
# Safari                                                                      #
###############################################################################
# Show full website address.
osascript <<EOF
tell application "Safari"
    set ShowFullURLInSmartSearchField to true
end tell
EOF

# Enable the Develop menu and the Web Inspector in Safari
osascript <<EOF
tell application "Safari"
    set IncludeDevelopMenu to true
    set WebKitDeveloperExtrasEnabledPreferenceKey to true
end tell
EOF

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

###############################################################################
# Finder                                                                      #
###############################################################################
# Show all file extensions in the Finder.
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
# Show path bar in the bottom of the Finder windows.
defaults write com.apple.finder "ShowPathbar" -bool "true"
# Set the default search scope when performing a search to the current folder.
defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf"
# Small Finder sidebar icons.
defaults write NSGlobalDomain "NSTableViewDefaultSizeMode" -int "1"
# Keep folders on top when sorting by name.
defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true"

###############################################################################
# Desktop                                                                     #
###############################################################################
defaults write com.apple.finder "_FXSortFoldersFirstOnDesktop" -bool "true"

###############################################################################
# Keyboard                                                                    #
###############################################################################
# Repeats the key as long as it is held down.
defaults write NSGlobalDomain "ApplePressAndHoldEnabled" -bool "false"
defaults write -g NSAutomaticCapitalizationEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

###############################################################################
# Mouse & Trackpad                                                            #
###############################################################################
# Disable "natural" scrolling.
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

###############################################################################
# Hot corner                                                                  #
# https://github.com/mathiasbynens/dotfiles/blob/main/.macos                  #
###############################################################################
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# 13: Lock Screen
# Top left screen corner → Mission Control
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right screen corner → Desktop
defaults write com.apple.dock wvous-tr-corner -int 4
defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom left screen corner → Start screen saver
defaults write com.apple.dock wvous-bl-corner -int 5
defaults write com.apple.dock wvous-bl-modifier -int 0

###############################################################################
# Screen                                                                      #
###############################################################################
# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Activity Monitor" \
	"Dock" \
	"Finder" \
	"Safari"; do
	killall "${app}" &> /dev/null
done
