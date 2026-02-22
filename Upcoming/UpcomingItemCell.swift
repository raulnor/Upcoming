//
//  UpcomingItemCell.swift
//  Upcoming
//
//  Created by Travis Luckenbaugh on 2/15/26.
//

import UIKit
internal import EventKit

class UpcomingItemCell: UITableViewCell {
    private let iconLabel = UILabel()
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

        iconLabel.font = .systemFont(ofSize: 24)
        iconLabel.textAlignment = .center
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        iconLabel.setContentHuggingPriority(.required, for: .horizontal)
        iconLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

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

        contentView.addSubview(iconLabel)
        contentView.addSubview(eventNameLabel)
        contentView.addSubview(daysLabel)
        contentView.addSubview(calendarNameLabel)
        contentView.addSubview(eventDateLabel)

        NSLayoutConstraint.activate([
            iconLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            eventNameLabel.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 12),
            eventNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            eventNameLabel.trailingAnchor.constraint(equalTo: daysLabel.leadingAnchor, constant: -8),

            daysLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            daysLabel.centerYAnchor.constraint(equalTo: eventNameLabel.centerYAnchor),

            calendarNameLabel.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 12),
            calendarNameLabel.topAnchor.constraint(equalTo: eventNameLabel.bottomAnchor, constant: 4),
            calendarNameLabel.trailingAnchor.constraint(equalTo: eventDateLabel.leadingAnchor, constant: -8),
            calendarNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            eventDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            eventDateLabel.centerYAnchor.constraint(equalTo: calendarNameLabel.centerYAnchor)
        ])
    }
    
    func configure(for calendar: EKCalendar) {
        if let nextEvent = EventKitManager.shared.getNextEvent(for: calendar) {
            if nextEvent.calendar.type == .birthday {
                iconLabel.text = "🎂"
            } else {
                iconLabel.text = "📅"
            }

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
        if event.calendar.type == .birthday {
            iconLabel.text = "🎂"
        } else if event.hasRecurrenceRules {
            iconLabel.text = "🔁"
        } else {
            iconLabel.text = "🎯"
        }

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
