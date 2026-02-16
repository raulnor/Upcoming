//
//  UpcomingItem.swift
//  Upcoming
//
//  Created by Travis Luckenbaugh on 2/15/26.
//

import Foundation
internal import EventKit

enum UpcomingItemType: String, Codable {
    case event
    case calendar
}

struct UpcomingItem: Codable, Identifiable {
    let id: UUID
    let calendarIdentifier: String
    let type: UpcomingItemType

    init(calendarIdentifier: String, type: UpcomingItemType) {
        self.id = UUID()
        self.calendarIdentifier = calendarIdentifier
        self.type = type
    }
}

func getNextDate(for item: UpcomingItem) -> Date? {
    switch item.type {
    case .event:
        return EventKitManager.shared.getEvent(withIdentifier: item.calendarIdentifier)?.startDate
    case .calendar:
        if let calendar = EventKitManager.shared.getCalendar(withIdentifier: item.calendarIdentifier) {
            return EventKitManager.shared.getNextEvent(for: calendar)?.startDate
        }
        return nil
    }
}

func getDaysRemaining(for item: UpcomingItem) -> Int? {
    guard let nextDate = getNextDate(for: item) else { return nil }
    let calendar = Calendar.current
    let components = calendar.dateComponents([.day], from: Date(), to: nextDate)
    return components.day
}

func getDaysRemaining(for date: Date) -> Int? {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.day], from: Date(), to: date)
    return components.day
}
