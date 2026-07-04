//
//  DestinationPickerViewController.swift
//  Shortlist
//
//  Created by Mark Wong on 4/7/2026.
//  Copyright © 2026 Mark Wong. All rights reserved.
//

import UIKit
import MapKit

protocol DestinationPickerDelegate: AnyObject {
    func destinationPicker(didSelect lat: Double, long: Double, placeName: String?)
}

final class DestinationPickerViewController: UIViewController {

    weak var delegate: DestinationPickerDelegate?

    private let searchCompleter = MKLocalSearchCompleter()
    private var searchResults: [MKLocalSearchCompletion] = []

    private var selectedAnnotation: MKPointAnnotation?
    private var selectedCoordinate: CLLocationCoordinate2D?
    private var selectedPlaceName: String?

    private let searchField: UISearchTextField = {
        let f = UISearchTextField()
        f.translatesAutoresizingMaskIntoConstraints = false
        f.placeholder = "Search for a place..."
        f.returnKeyType = .search
        return f
    }()

    private let suggestionsTable: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "suggestion")
        tv.isHidden = true
        return tv
    }()

    private let mapView: MKMapView = {
        let m = MKMapView()
        m.translatesAutoresizingMaskIntoConstraints = false
        m.showsUserLocation = true
        return m
    }()

    private lazy var setButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Set as Destination"
        config.cornerStyle = .large
        config.baseBackgroundColor = .label
        config.baseForegroundColor = .systemBackground
        let b = UIButton(configuration: config)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.isEnabled = false
        b.alpha = 0.5
        b.addTarget(self, action: #selector(handleSet), for: .touchUpInside)
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Set Destination"
        view.backgroundColor = .systemBackground

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))

        searchCompleter.delegate = self
        searchCompleter.resultTypes = [.address, .pointOfInterest]

        searchField.delegate = self
        suggestionsTable.dataSource = self
        suggestionsTable.delegate = self

        [searchField, mapView, suggestionsTable, setButton].forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            searchField.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            searchField.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),

            mapView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 8),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: setButton.topAnchor, constant: -16),

            // Suggestions float over the map
            suggestionsTable.topAnchor.constraint(equalTo: searchField.bottomAnchor),
            suggestionsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            suggestionsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            suggestionsTable.heightAnchor.constraint(equalToConstant: 220),

            setButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            setButton.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            setButton.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            setButton.heightAnchor.constraint(equalToConstant: 54),
        ])
    }

    @objc private func handleCancel() {
        dismiss(animated: true)
    }

    @objc private func handleSet() {
        guard let coord = selectedCoordinate else { return }
        delegate?.destinationPicker(didSelect: coord.latitude,
                                     long: coord.longitude,
                                     placeName: selectedPlaceName)
        dismiss(animated: true)
    }

    private func selectResult(_ completion: MKLocalSearchCompletion) {
        let request = MKLocalSearch.Request(completion: completion)
        MKLocalSearch(request: request).start { [weak self] response, _ in
            guard let self, let item = response?.mapItems.first else { return }
            let coord = item.placemark.coordinate
            self.selectedCoordinate = coord
            self.selectedPlaceName = item.name ?? completion.title

            DispatchQueue.main.async {
                self.mapView.removeAnnotations(self.mapView.annotations)
                let ann = MKPointAnnotation()
                ann.coordinate = coord
                ann.title = self.selectedPlaceName
                self.mapView.addAnnotation(ann)
                self.mapView.setRegion(
                    MKCoordinateRegion(center: coord, latitudinalMeters: 800, longitudinalMeters: 800),
                    animated: true)

                self.setButton.isEnabled = true
                UIView.animate(withDuration: 0.15) { self.setButton.alpha = 1 }
                self.suggestionsTable.isHidden = true
                self.searchField.resignFirstResponder()
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension DestinationPickerViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let current = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        searchCompleter.queryFragment = current
        suggestionsTable.isHidden = current.isEmpty
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        suggestionsTable.isHidden = true
        return true
    }
}

// MARK: - MKLocalSearchCompleterDelegate

extension DestinationPickerViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = Array(completer.results.prefix(6))
        suggestionsTable.reloadData()
    }
}

// MARK: - UITableView DataSource / Delegate

extension DestinationPickerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestion", for: indexPath)
        let result = searchResults[indexPath.row]
        var config = cell.defaultContentConfiguration()
        config.text = result.title
        config.secondaryText = result.subtitle
        cell.contentConfiguration = config
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectResult(searchResults[indexPath.row])
    }
}
