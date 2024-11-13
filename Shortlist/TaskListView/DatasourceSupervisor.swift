//
//  DatasourceSupervisor.swift
//  Shortlist
//
//  Created by Mark Wong on 3/8/2024.
//  Copyright © 2024 Mark Wong. All rights reserved.
//

import UIKit
import CoreData

/// In use with Diffable Datasource and CoreData with a collectionview
protocol DatasourceSupervisorBase {
    associatedtype Item: Hashable
    associatedtype SectionIdentifier: Hashable

    func configureSnapshot(data: [Item]) -> NSDiffableDataSourceSnapshot<SectionIdentifier, Item>
    func configureDatasource(view: UICollectionView)
}

protocol DatasourceSupervisorForCoreData: DatasourceSupervisorBase where Item: NSFetchRequestResult {
    func updateSnapshot(fetchedResultsController: NSFetchedResultsController<Item>)
    func refreshDatasource(fetchedResultsController: NSFetchedResultsController<Item>)
}

protocol DatasourceSupervisor: DatasourceSupervisorBase {
    func updateSnapshot(item: [Item])
    func refreshDatasource(item: [Item])
}
