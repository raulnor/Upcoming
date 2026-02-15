//
//  EventKitManager.swift
//  Upcoming
//
//  Created by Travis Luckenbaugh on 2/15/26.
//

import EventKit
import Foundation

class EventKitManager {
    static let shared = EventKitManager()
    private let eventStore = EKEventStore()

    private init() {}

    func requestAccess(completion: @escaping (Bool) -> Void) {
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents { granted, error in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        } else {
            eventStore.requestAccess(to: .event) { granted, error in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        }
    }

    func getEvent(withIdentifier identifier: String) -> EKEvent? {
        return eventStore.event(withIdentifier: identifier)
    }

    func getCalendar(withIdentifier identifier: String) -> EKCalendar? {
        return eventStore.calendar(withIdentifier: identifier)
    }

    func getNextEvent(for calendar: EKCalendar) -> EKEvent? {
        let now = Date()
        let oneYearFromNow = Calendar.current.date(byAdding: .year, value: 1, to: now)!

        let predicate = eventStore.predicateForEvents(withStart: now, end: oneYearFromNow, calendars: [calendar])
        let events = eventStore.events(matching: predicate)

        return events.first
    }

    func getAllCalendars() -> [EKCalendar] {
        return eventStore.calendars(for: .event)
    }

    func getAllEvents() -> [EKEvent] {
        let now = Date()
        let oneYearFromNow = Calendar.current.date(byAdding: .year, value: 1, to: now)!

        let predicate = eventStore.predicateForEvents(withStart: now, end: oneYearFromNow, calendars: nil)
        return eventStore.events(matching: predicate)
    }
}
