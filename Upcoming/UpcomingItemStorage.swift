//
//  UpcomingItemStorage.swift
//  Upcoming
//
//  Created by Travis Luckenbaugh on 2/15/26.
//

import Foundation

class UpcomingItemStorage {
    private static let storageKey = "upcomingItems"

    static func save(_ items: [UpcomingItem]) {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }

    static func load() -> [UpcomingItem] {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let items = try? JSONDecoder().decode([UpcomingItem].self, from: data) else {
            return []
        }
        return items
    }
}
