//
//  EventKitManager.swift
//  Upcoming
//
//  Created by Travis Luckenbaugh on 2/15/26.
//

internal import EventKit
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
    
    func getNextEvent(withIdentifier identifier: String) -> EKEvent? {
        guard let rootEvent = eventStore.event(withIdentifier: identifier) else { return nil }
        if rootEvent.startDate < Date() && rootEvent.recurrenceRules?.first != nil {
            let now = Date()
            let end = Calendar.current.date(byAdding: .year, value: 1, to: now)!
            let predicate = eventStore.predicateForEvents(withStart: now, end: end, calendars: [rootEvent.calendar])
            return eventStore.events(matching: predicate)
                .first { $0.calendarItemIdentifier == rootEvent.calendarItemIdentifier }
        }
        return rootEvent
    }

    func getCalendar(withIdentifier identifier: String) -> EKCalendar? {
        return eventStore.calendar(withIdentifier: identifier)
    }

    func getNextEvent(for calendar: EKCalendar?) -> EKEvent? {
        guard let calendar else { return nil }
        let now = Date()
        let end = Calendar.current.date(byAdding: .year, value: 1, to: now)!

        let predicate = eventStore.predicateForEvents(withStart: now, end: end, calendars: [calendar])
        let events = eventStore.events(matching: predicate)

        return events.first
    }

    func getAllCalendars() -> [EKCalendar] {
        return eventStore.calendars(for: .event)
    }

    func getAllEvents(calendars: [EKCalendar]? = nil) -> [EKEvent] {
        let now = Date()
        let oneYearFromNow = Calendar.current.date(byAdding: .year, value: 1, to: now)!

        let predicate = eventStore.predicateForEvents(withStart: now, end: oneYearFromNow, calendars: calendars)
        return eventStore.events(matching: predicate)
    }
}
