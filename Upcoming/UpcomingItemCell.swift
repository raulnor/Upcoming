//
//  UpcomingItemCell.swift
//  Upcoming
//
//  Created by Travis Luckenbaugh on 2/15/26.
//

import UIKit

class UpcomingItemCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let daysLabel = UILabel()
    private let typeLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        titleLabel.font = .systemFont(ofSize: 17, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        daysLabel.font = .systemFont(ofSize: 15)
        daysLabel.textColor = .secondaryLabel
        daysLabel.translatesAutoresizingMaskIntoConstraints = false

        typeLabel.font = .systemFont(ofSize: 13)
        typeLabel.textColor = .tertiaryLabel
        typeLabel.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView(arrangedSubviews: [titleLabel, typeLabel, daysLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    func configure(title: String, daysRemaining: Int?, type: UpcomingItemType) {
        titleLabel.text = title
        typeLabel.text = type == .event ? "Event" : "Calendar"

        if let days = daysRemaining {
            if days == 0 {
                daysLabel.text = "Today"
            } else if days == 1 {
                daysLabel.text = "Tomorrow"
            } else if days > 1 {
                daysLabel.text = "\(days) days"
            } else {
                daysLabel.text = "Past event"
            }
        } else {
            daysLabel.text = "No upcoming events"
        }
    }
}
