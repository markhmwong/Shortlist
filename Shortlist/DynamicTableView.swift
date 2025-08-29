//  DynamicTableView.swift
//  Shortlist
//
//  Created for dynamic multi-section UITableView support.
//

import UIKit

/// A protocol representing any type of row data in a dynamic table view.
///
/// Conforming types represent the data model for individual rows in the table view.
/// This allows sections in the table view to be heterogeneous with different row types if needed.
public protocol DynamicTableRow {}

/// A generic struct representing a section in a dynamic table view.
///
/// - Parameter RowType: The type of row data contained in this section, conforming to `DynamicTableRow`.
///
/// This struct groups rows into a section and optionally holds a header title for that section.
public struct DynamicTableSection<RowType> {
    /// The optional title for the section header.
    public let headerTitle: String?
    /// The array of rows contained within this section.
    public let rows: [RowType]
    
    /// Creates a new dynamic table section with an optional header title and an array of rows.
    ///
    /// - Parameters:
    ///   - headerTitle: An optional string to be displayed as the section header title.
    ///   - rows: An array of row data contained in this section.
    public init(headerTitle: String? = nil, rows: [RowType]) {
        self.headerTitle = headerTitle
        self.rows = rows
    }
}

/// A protocol defining delegate methods for configuring and responding to events in a `DynamicTableView`.
///
/// Implement this protocol to provide cell configuration and handle user interaction with rows.
///
/// - Note: `RowType` must conform to `DynamicTableRow`. `CellType` must be a `UITableViewCell` subclass.
public protocol DynamicTableViewDelegate: AnyObject {
    /// The type representing the row data for the table view.
    associatedtype RowType: DynamicTableRow
    /// The type of cell used to display the row data.
    associatedtype CellType: UITableViewCell
    
    /// Asks the delegate for a configured cell corresponding to a given row at an index path.
    ///
    /// - Parameters:
    ///   - tableView: The table view requesting the cell.
    ///   - row: The data model for the row to be displayed.
    ///   - indexPath: The index path specifying the location of the row.
    /// - Returns: A fully configured cell of type `CellType` ready for display.
    func dynamicTableView(_ tableView: UITableView, cellForRow row: RowType, at indexPath: IndexPath) -> CellType
    
    /// Tells the delegate that a row was selected.
    ///
    /// - Parameters:
    ///   - tableView: The table view notifying the delegate of the selection.
    ///   - row: The data model for the selected row.
    ///   - indexPath: The index path specifying the location of the selected row.
    func dynamicTableView(_ tableView: UITableView, didSelectRow row: RowType, at indexPath: IndexPath)
}

/// A generic, reusable UITableView subclass supporting dynamic, multi-section data with heterogeneous row types.
///
/// - Parameters:
///   - RowType: The data type for rows, conforming to `DynamicTableRow`.
///   - Delegate: The delegate type conforming to `DynamicTableViewDelegate` that handles cell configuration and user interaction.
///
/// Use this class to easily manage table views with multiple sections and different row data types. Set the
/// `sections` property to update content and assign a `dynamicDelegate` to handle cell creation and row selection.
public class DynamicTableView<RowType: DynamicTableRow, Delegate: DynamicTableViewDelegate>: UITableView, UITableViewDataSource, UITableViewDelegate where Delegate.RowType == RowType {
    /// The array of sections displayed in the table view.
    ///
    /// Setting this property reloads the table view data automatically.
    public var sections: [DynamicTableSection<RowType>] = [] {
        didSet { reloadData() }
    }

    /// The delegate responsible for configuring cells and handling row selection events.
    ///
    /// This delegate must conform to `DynamicTableViewDelegate` with the matching `RowType`.
    public weak var dynamicDelegate: Delegate?

    /// Initializes a dynamic table view with the specified style.
    ///
    /// - Parameter style: The style of the table view (plain or grouped). Defaults to `.plain`.
    public init(style: UITableView.Style = .plain) {
        super.init(frame: .zero, style: style)
        self.dataSource = self
        self.delegate = self
    }

    /// Initializes a dynamic table view from a decoder (e.g. storyboard or nib).
    ///
    /// - Parameter coder: The coder to initialize from.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.dataSource = self
        self.delegate = self
    }

    // MARK: - UITableViewDataSource

    /// Returns the number of sections in the table view.
    ///
    /// - Parameter tableView: The table view requesting this information.
    /// - Returns: The count of sections currently set.
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    /// Returns the number of rows in a given section.
    ///
    /// - Parameters:
    ///   - tableView: The table view requesting this information.
    ///   - section: The index of the section.
    /// - Returns: The number of rows in the specified section.
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }

    /// Asks the delegate for a cell to insert in a particular location of the table view.
    ///
    /// - Parameters:
    ///   - tableView: The table view requesting the cell.
    ///   - indexPath: The index path specifying the location of the cell.
    /// - Returns: A configured table view cell corresponding to the row at the given index path.
    ///
    /// - Note: This method will cause a runtime error if `dynamicDelegate` is not set.
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let delegate = dynamicDelegate else {
            fatalError("DynamicTableViewDelegate not set or incorrect type")
        }
        let section = sections[indexPath.section]
        let row = section.rows[indexPath.row]
        return delegate.dynamicTableView(tableView, cellForRow: row, at: indexPath)
    }

    // MARK: - Section headers

    /// Provides the title for the header of the specified section.
    ///
    /// - Parameters:
    ///   - tableView: The table view requesting this information.
    ///   - section: The index of the section.
    /// - Returns: The header title string for the section, or nil if none is set.
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].headerTitle
    }

    // MARK: - UITableViewDelegate

    /// Tells the delegate that the specified row is now selected.
    ///
    /// - Parameters:
    ///   - tableView: The table view notifying the delegate.
    ///   - indexPath: The index path of the selected row.
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = dynamicDelegate else { return }
        let section = sections[indexPath.section]
        let row = section.rows[indexPath.row]
        delegate.dynamicTableView(tableView, didSelectRow: row, at: indexPath)
    }
}

// Usage:
// 1. Define a struct or enum conforming to DynamicTableRow for your row data.
// 2. Subclass DynamicTableView or set up with your section/row types.
// 3. Implement DynamicTableViewDelegate for cell configuration and row selection.
