//
//  UpcomingItemCell.swift
//  Upcoming
//
//  Created by Travis Luckenbaugh on 2/15/26.
//

import UIKit

class UpcomingItemCell: UITableViewCell {
    private let iconView = UIImageView()
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
        // Icon setup
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .systemBlue
        iconView.translatesAutoresizingMaskIntoConstraints = false

        // Event name label
        eventNameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        eventNameLabel.translatesAutoresizingMaskIntoConstraints = false

        // Days label
        daysLabel.font = .systemFont(ofSize: 17, weight: .medium)
        daysLabel.textColor = .systemBlue
        daysLabel.textAlignment = .right
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        daysLabel.setContentHuggingPriority(.required, for: .horizontal)
        daysLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        // Event date label
        eventDateLabel.font = .systemFont(ofSize: 14)
        eventDateLabel.textColor = .secondaryLabel
        eventDateLabel.textAlignment = .right
        eventDateLabel.translatesAutoresizingMaskIntoConstraints = false
        eventDateLabel.setContentHuggingPriority(.required, for: .horizontal)
        eventDateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        // Calendar name label
        calendarNameLabel.font = .systemFont(ofSize: 14)
        calendarNameLabel.textColor = .secondaryLabel
        calendarNameLabel.translatesAutoresizingMaskIntoConstraints = false

        // Top row container (event name + days)
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

        contentView.addSubview(iconView)
        contentView.addSubview(infoStack)

        NSLayoutConstraint.activate([
            // Icon constraints
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),

            // Info stack constraints
            infoStack.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            infoStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            infoStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            infoStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    func configure(eventName: String, eventDate: String, calendarName: String, daysRemaining: Int?, type: UpcomingItemType) {
        // Set icon based on type
        let iconName = type == .event ? "clock" : "calendar"
        iconView.image = UIImage(systemName: iconName)

        // Set event name
        eventNameLabel.text = eventName

        // Set event date
        eventDateLabel.text = eventDate

        // Set calendar name
        calendarNameLabel.text = calendarName

        // Set days remaining
        if let days = daysRemaining {
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
