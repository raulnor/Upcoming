//
//  EventDetailViewController.swift
//  Upcoming
//
//  Created by Travis Luckenbaugh on 2/15/26.
//

import UIKit
import EventKit

class EventDetailViewController: UIViewController {
    private let event: EKEvent
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()

    init(event: EKEvent) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Event Details"

        setupScrollView()
        setupContentStackView()
        displayEventDetails()
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

    private func displayEventDetails() {
        addDetailRow(label: "Title", value: event.title ?? "Untitled")

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short

        addDetailRow(label: "Start", value: dateFormatter.string(from: event.startDate))
        addDetailRow(label: "End", value: dateFormatter.string(from: event.endDate))

        if let calendar = event.calendar {
            addDetailRow(label: "Calendar", value: calendar.title)
        }

        if let location = event.location, !location.isEmpty {
            addDetailRow(label: "Location", value: location)
        }

        if let notes = event.notes, !notes.isEmpty {
            addDetailRow(label: "Notes", value: notes)
        }

        if event.isAllDay {
            addDetailRow(label: "All Day", value: "Yes")
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
