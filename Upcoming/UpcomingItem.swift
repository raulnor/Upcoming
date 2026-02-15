//
//  UpcomingItem.swift
//  Upcoming
//
//  Created by Travis Luckenbaugh on 2/15/26.
//

import Foundation

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
