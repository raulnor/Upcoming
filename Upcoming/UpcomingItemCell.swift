//
//  UpcomingItemCell.swift
//  Upcoming
//
//  Created by Travis Luckenbaugh on 2/15/26.
//

import UIKit
internal import EventKit

class UpcomingItemCell: UITableViewCell {
    private let eventNameLabel = UILabel()
    private let daysLabel = UILabel()
    private let eventDateLabel = UILabel()
    private let calendarNameLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = UIColor.appBackground
        
        eventNameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        eventNameLabel.textColor = UIColor.appPrimaryLabel
        eventNameLabel.translatesAutoresizingMaskIntoConstraints = false

        daysLabel.font = .systemFont(ofSize: 17, weight: .medium)
        daysLabel.textColor = UIColor.appAccent
        daysLabel.textAlignment = .right
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        daysLabel.setContentHuggingPriority(.required, for: .horizontal)
        daysLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        eventDateLabel.font = .systemFont(ofSize: 14)
        eventDateLabel.textColor = UIColor.appSecondaryLabel
        eventDateLabel.textAlignment = .right
        eventDateLabel.translatesAutoresizingMaskIntoConstraints = false
        eventDateLabel.setContentHuggingPriority(.required, for: .horizontal)
        eventDateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        calendarNameLabel.font = .systemFont(ofSize: 14)
        calendarNameLabel.textColor = UIColor.appSecondaryLabel
        calendarNameLabel.translatesAutoresizingMaskIntoConstraints = false

        let topRowStack = UIStackView(arrangedSubviews: [eventNameLabel, daysLabel])
        topRowStack.axis = .horizontal
        topRowStack.spacing = 8
        topRowStack.translatesAutoresizingMaskIntoConstraints = false

        // Bottom row container (calendar name + date)
        let bottomRowStack = UIStackView(arrangedSubviews: [calendarNameLabel, eventDateLabel])
        bottomRowStack.axis = .horizontal
        bottomRowStack.spacing = 8
        bottomRowStack.translatesAutoresizingMaskIntoConstraints = false

        // Vertical stack for event info
        let infoStack = UIStackView(arrangedSubviews: [topRowStack, bottomRowStack])
        infoStack.axis = .vertical
        infoStack.spacing = 4
        infoStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(infoStack)

        NSLayoutConstraint.activate([
            // Info stack constraints
            infoStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            infoStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            infoStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            infoStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(for calendar: EKCalendar) {
        if let nextEvent = EventKitManager.shared.getNextEvent(for: calendar) {
            eventNameLabel.text = nextEvent.title ?? "Untitled Event"
            eventDateLabel.text = formatDate(nextEvent.startDate, isAllDay: nextEvent.isAllDay)
            calendarNameLabel.text = nextEvent.calendar.title
            if let days = getDaysRemaining(for: nextEvent.startDate) {
                if days == 0 {
                    daysLabel.text = "Today"
                } else if days == 1 {
                    daysLabel.text = "Tomorrow"
                } else if days > 1 {
                    daysLabel.text = "\(days) days"
                } else {
                    daysLabel.text = "Past"
                }
            } else {
                daysLabel.text = "No events"
            }
        }
    }
    
    func configure(for event: EKEvent) {
        eventNameLabel.text = event.title ?? "Untitled Event"
        eventDateLabel.text = formatDate(event.startDate, isAllDay: event.isAllDay)
        calendarNameLabel.text = event.calendar.title
        if let days = getDaysRemaining(for: event.startDate) {
            if days == 0 {
                daysLabel.text = "Today"
            } else if days == 1 {
                daysLabel.text = "Tomorrow"
            } else if days > 1 {
                daysLabel.text = "\(days) days"
            } else {
                daysLabel.text = "Past"
            }
        } else {
            daysLabel.text = "No events"
        }
    }
}
