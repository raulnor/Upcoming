//
//  UpcomingDetailViewController.swift
//  Upcoming
//
//  Created by Travis Luckenbaugh on 2/15/26.
//

import UIKit
internal import EventKit

class UpcomingDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let titleLabel = UILabel()
    private let detailLabel = UILabel()
    private let tableView = UITableView()
    
    private let item: UpcomingItem
    private var event: EKEvent?
    private var calendar: EKCalendar?
    private var futureEvents: [EKEvent] = []

    init(item: UpcomingItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.appBackground
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        view.addSubview(titleLabel)
        
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.textColor = .secondaryLabel
        view.addSubview(detailLabel)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UpcomingItemCell.self, forCellReuseIdentifier: "UpcomingItemCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        loadData()
        
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: 8),
            
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            detailLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 8),
            detailLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: 8),
            
            tableView.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -8)
        ])
    }
    
    private func loadData() {
        switch item.type {
        case .calendar:
            calendar = EventKitManager.shared.getCalendar(withIdentifier: item.calendarIdentifier)
            event = EventKitManager.shared.getNextEvent(for: calendar)
        case .event:
            event = EventKitManager.shared.getEvent(withIdentifier: item.calendarIdentifier)
            calendar = event?.calendar
        }
        futureEvents = EventKitManager.shared.getAllEvents(calendars: calendar != nil ? [calendar!] : [])
        if let event {
            titleLabel.text = event.title
            detailLabel.text = formatEventDate(event)
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return futureEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingItemCell", for: indexPath) as! UpcomingItemCell
        let event = futureEvents[indexPath.row]
        
        cell.configure(for: event)

        return cell
    }
}

