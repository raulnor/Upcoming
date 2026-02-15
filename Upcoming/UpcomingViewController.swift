//
//  UpcomingViewController.swift
//  Upcoming
//
//  Created by Travis Luckenbaugh on 2/15/26.
//

import UIKit
import EventKit

class UpcomingViewController: UIViewController {
    private var upcomingItems: [UpcomingItem] = []
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"

        setupNavigationBar()
        setupTableView()
        requestCalendarAccess()
        loadItems()
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addItemTapped)
        )
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UpcomingItemCell.self, forCellReuseIdentifier: "UpcomingItemCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func requestCalendarAccess() {
        EventKitManager.shared.requestAccess { granted in
            if !granted {
                self.showAccessDeniedAlert()
            }
        }
    }

    private func showAccessDeniedAlert() {
        let alert = UIAlertController(
            title: "Calendar Access Required",
            message: "Please enable calendar access in Settings to track upcoming events.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func loadItems() {
        upcomingItems = UpcomingItemStorage.load()
        sortItems()
        tableView.reloadData()
    }

    private func saveItems() {
        UpcomingItemStorage.save(upcomingItems)
    }

    private func sortItems() {
        upcomingItems.sort { item1, item2 in
            guard let date1 = getNextDate(for: item1),
                  let date2 = getNextDate(for: item2) else {
                return false
            }
            return date1 < date2
        }
    }

    private func getNextDate(for item: UpcomingItem) -> Date? {
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

    private func getDaysRemaining(for item: UpcomingItem) -> Int? {
        guard let nextDate = getNextDate(for: item) else { return nil }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: nextDate)
        return components.day
    }

    @objc private func addItemTapped() {
        let pickerVC = ItemPickerViewController()
        pickerVC.delegate = self
        let navController = UINavigationController(rootViewController: pickerVC)
        present(navController, animated: true)
    }

    private func deleteItem(at indexPath: IndexPath) {
        upcomingItems.remove(at: indexPath.row)
        saveItems()
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    private func showEventOrCalendar(for item: UpcomingItem) {
        switch item.type {
        case .event:
            if let event = EventKitManager.shared.getEvent(withIdentifier: item.calendarIdentifier) {
                showEventDetail(event)
            } else {
                showItemNotFoundAlert()
            }
        case .calendar:
            if let calendar = EventKitManager.shared.getCalendar(withIdentifier: item.calendarIdentifier) {
                showCalendarDetail(calendar)
            } else {
                showItemNotFoundAlert()
            }
        }
    }

    private func showEventDetail(_ event: EKEvent) {
        let detailVC = EventDetailViewController(event: event)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    private func showCalendarDetail(_ calendar: EKCalendar) {
        let detailVC = CalendarDetailViewController(calendar: calendar)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    private func showItemNotFoundAlert() {
        let alert = UIAlertController(
            title: "Item Not Found",
            message: "This event or calendar no longer exists.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension UpcomingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingItemCell", for: indexPath) as! UpcomingItemCell
        let item = upcomingItems[indexPath.row]

        var eventName = ""
        var eventDate = ""
        var calendarName = ""

        switch item.type {
        case .event:
            if let event = EventKitManager.shared.getEvent(withIdentifier: item.calendarIdentifier) {
                eventName = event.title ?? "Untitled Event"
                eventDate = formatDate(event.startDate, isAllDay: event.isAllDay)
                calendarName = event.calendar.title
            }
        case .calendar:
            if let calendar = EventKitManager.shared.getCalendar(withIdentifier: item.calendarIdentifier) {
                if let nextEvent = EventKitManager.shared.getNextEvent(for: calendar) {
                    eventName = nextEvent.title ?? "Untitled Event"
                    eventDate = formatDate(nextEvent.startDate, isAllDay: nextEvent.isAllDay)
                } else {
                    eventName = "No upcoming events"
                    eventDate = ""
                }
                calendarName = calendar.title
            }
        }

        let daysRemaining = getDaysRemaining(for: item)
        cell.configure(eventName: eventName, eventDate: eventDate, calendarName: calendarName, daysRemaining: daysRemaining, type: item.type)

        return cell
    }

    private func formatDate(_ date: Date, isAllDay: Bool) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = isAllDay ? .none : .short
        return formatter.string(from: date)
    }
}

// MARK: - UITableViewDelegate
extension UpcomingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = upcomingItems[indexPath.row]
        showEventOrCalendar(for: item)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteItem(at: indexPath)
        }
    }
}

// MARK: - ItemPickerDelegate
extension UpcomingViewController: ItemPickerDelegate {
    func didSelectItem(_ item: UpcomingItem) {
        upcomingItems.append(item)
        sortItems()
        saveItems()
        tableView.reloadData()
    }
}

