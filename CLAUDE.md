# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Upcoming is an iOS application that tracks upcoming calendar events and calendars. Users can select specific events or entire calendars to monitor, and the app displays the number of days remaining until each event. The app uses EventKit to access calendar data and requires calendar permissions.

The project is built with UIKit using a programmatic UI approach with minimal storyboards (only LaunchScreen.storyboard is used).

## Build and Run Commands

Build the project:
```bash
xcodebuild -project Upcoming.xcodeproj -scheme Upcoming -configuration Debug build
```

Build for iOS Simulator:
```bash
xcodebuild -project Upcoming.xcodeproj -scheme Upcoming -configuration Debug -sdk iphonesimulator build
```

Build for release:
```bash
xcodebuild -project Upcoming.xcodeproj -scheme Upcoming -configuration Release build
```

Clean build artifacts:
```bash
xcodebuild -project Upcoming.xcodeproj -scheme Upcoming clean
```

## Architecture

### Application Structure

- **AppDelegate.swift**: Main application entry point. Creates a UINavigationController with UpcomingViewController as the root.
- **UpcomingViewController.swift**: Main view controller displaying a list of upcoming items with a UITableView. Handles adding, deleting, and tapping items.
- **ItemPickerViewController.swift**: Modal view for selecting new calendar events or calendars to track. Uses a segmented control to switch between events and calendars.
- **EventDetailViewController.swift**: Shows details for a selected event (title, dates, location, notes).
- **CalendarDetailViewController.swift**: Shows details for a selected calendar including the next upcoming event.

### Data Layer

- **UpcomingItem.swift**: Data model representing a tracked item. Contains a calendar identifier (EventKit UUID) and type (event or calendar).
- **UpcomingItemStorage.swift**: Persistence layer using UserDefaults to save/load the list of tracked items as JSON.
- **EventKitManager.swift**: Singleton manager for EventKit operations including permission requests, fetching events/calendars, and calculating next events.

### UI Components

- **UpcomingItemCell.swift**: Custom UITableViewCell displaying item title, type, and days remaining.

### Key Features

1. **Calendar Permissions**: App requests calendar access on launch using EventKit (NSCalendarsUsageDescription in Info.plist).
2. **Date Calculation**: Calculates days remaining by comparing event start dates to the current date. For calendars, finds the next event in that calendar.
3. **Sorting**: Items are sorted by next event date (earliest first).
4. **Swipe to Delete**: Standard UITableView swipe-to-delete removes items from tracking.
5. **Persistence**: Tracked items persist across app launches using UserDefaults.
6. **Detail Views**: Tapping an item navigates to a detail view showing event or calendar information from EventKit.

### Project Structure

```
Upcoming/
├── AppDelegate.swift                    # Application lifecycle and window setup
├── UpcomingViewController.swift         # Main list view with table view
├── ItemPickerViewController.swift       # Event/calendar selection view
├── EventDetailViewController.swift      # Event detail view
├── CalendarDetailViewController.swift   # Calendar detail view
├── UpcomingItemCell.swift               # Custom table view cell
├── UpcomingItem.swift                   # Data model
├── UpcomingItemStorage.swift            # Persistence layer
├── EventKitManager.swift                # EventKit wrapper
├── Assets.xcassets/                     # Image and color assets
├── Base.lproj/
│   └── LaunchScreen.storyboard          # Launch screen only
└── Info.plist                           # App configuration (includes calendar permission)
```

## Development Notes

- The project favors programmatic UI creation over storyboards
- All UI is built using Auto Layout with NSLayoutConstraint
- EventKit calendar identifiers are stored as strings and used to fetch events/calendars on demand
- The app handles iOS 17+ permission changes with conditional compilation for `requestFullAccessToEvents`
