//
//  ItemPickerViewController.swift
//  Upcoming
//
//  Created by Travis Luckenbaugh on 2/15/26.
//

import UIKit
internal import EventKit

protocol ItemPickerDelegate: AnyObject {
    func didSelectItem(_ item: UpcomingItem)
}

class ItemPickerViewController: UIViewController {
    weak var delegate: ItemPickerDelegate?

    private let segmentedControl = UISegmentedControl(items: ["Events", "Calendars"])
    private let tableView = UITableView()

    private var events: [EKEvent] = []
    private var calendars: [EKCalendar] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.appBackground
        title = "Add Upcoming Item"

        setupNavigationBar()
        setupSegmentedControl()
        setupTableView()
        loadData()
    }

    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
    }

    private func setupSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(segmentedControl)

        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            segmentedControl.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16)
        ])
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(UpcomingItemCell.self, forCellReuseIdentifier: "UpcomingItemCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)

        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: guide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: segmentedControl.topAnchor)
        ])
    }

    private func loadData() {
        events = EventKitManager.shared.getAllEvents()
        calendars = EventKitManager.shared.getAllCalendars()
        tableView.reloadData()
    }

    @objc private func cancelTapped() {
        dismiss(animated: true)
    }

    @objc private func segmentChanged() {
        tableView.reloadData()
    }

    private var isShowingEvents: Bool {
        return segmentedControl.selectedSegmentIndex == 0
    }
}

// MARK: - UITableViewDataSource
extension ItemPickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isShowingEvents ? events.count : calendars.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingItemCell", for: indexPath) as! UpcomingItemCell
        
        if isShowingEvents {
            let event = events[indexPath.row]
            cell.configure(for: event)
        } else {
            let calendar = calendars[indexPath.row]
            cell.configure(for: calendar)
        }

        return cell
    }
}

// MARK: - UITableViewDelegate
extension ItemPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item: UpcomingItem

        if isShowingEvents {
            let event = events[indexPath.row]
            item = UpcomingItem(calendarIdentifier: event.eventIdentifier, type: .event)
        } else {
            let calendar = calendars[indexPath.row]
            item = UpcomingItem(calendarIdentifier: calendar.calendarIdentifier, type: .calendar)
        }

        delegate?.didSelectItem(item)
        dismiss(animated: true)
    }
}
