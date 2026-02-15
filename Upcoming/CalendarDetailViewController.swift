//
//  CalendarDetailViewController.swift
//  Upcoming
//
//  Created by Travis Luckenbaugh on 2/15/26.
//

import UIKit
import EventKit

class CalendarDetailViewController: UIViewController {
    private let calendar: EKCalendar
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()

    init(calendar: EKCalendar) {
        self.calendar = calendar
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Calendar Details"

        setupScrollView()
        setupContentStackView()
        displayCalendarDetails()
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupContentStackView() {
        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        contentStackView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }

    private func displayCalendarDetails() {
        addDetailRow(label: "Title", value: calendar.title)

        if let source = calendar.source {
            addDetailRow(label: "Source", value: source.title)
        }

        addDetailRow(label: "Type", value: calendar.type.description)
        addDetailRow(label: "Allows Modifications", value: calendar.allowsContentModifications ? "Yes" : "No")

        if let nextEvent = EventKitManager.shared.getNextEvent(for: calendar) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .short

            addDetailRow(label: "Next Event", value: nextEvent.title ?? "Untitled")
            addDetailRow(label: "Next Event Date", value: dateFormatter.string(from: nextEvent.startDate))
        } else {
            addDetailRow(label: "Next Event", value: "No upcoming events")
        }
    }

    private func addDetailRow(label: String, value: String) {
        let labelView = UILabel()
        labelView.text = label
        labelView.font = .systemFont(ofSize: 14, weight: .semibold)
        labelView.textColor = .secondaryLabel

        let valueView = UILabel()
        valueView.text = value
        valueView.font = .systemFont(ofSize: 16)
        valueView.numberOfLines = 0

        contentStackView.addArrangedSubview(labelView)
        contentStackView.addArrangedSubview(valueView)
    }
}

extension EKCalendarType {
    var description: String {
        switch self {
        case .local: return "Local"
        case .calDAV: return "CalDAV"
        case .exchange: return "Exchange"
        case .subscription: return "Subscription"
        case .birthday: return "Birthday"
        @unknown default: return "Unknown"
        }
    }
}
