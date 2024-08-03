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
protocol DatasourceSupervisor {
    associatedtype Item: Hashable & NSFetchRequestResult
    associatedtype SectionIdentifier: Hashable
    
    func configureSnapshot(data: [Item]) -> NSDiffableDataSourceSnapshot<SectionIdentifier, Item>
    
    func updateSnapshot(fetchedResultsController: NSFetchedResultsController<Item>)
    
    func refreshDatasource(fetchedResultsController: NSFetchedResultsController<Item>)
    
    func configureDatasource(view: UICollectionView)
}
