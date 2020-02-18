//
//  StatisticsStructs.swift
//  Five
//
//  Created by Mark Wong on 24/8/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation

// Chart structures that organises the data into their Week, Month, Year overview

protocol ChartData {
    var title: String { get }
    var maxTasks: Int64 { get }
    var data: [ Int : DayOverview ] { get }
    var average: Int16 { get }
    var minRange: String { get }
    var maxRange: String { get }
}

struct DayOverview {
    
    // Represents the day of the week. Monday, Tuesday etc. Needs to be converted from CoreData
    let dayOfWeek: DayOfWeek
    
    let dayDate: Int
    
    let numberOfCompletedTasks: Int64
    
    let incompleteTasks: Int64
}

// A summary of the last 7 days
// Stores properties

struct WeekChartData: ChartData {
    
    // Since the app allows for 5 - 15 (not sure of the max amount yet), we'll need to iterate and find the largest value
    var maxTasks: Int64
    
    // Should be a maximum of 7 days
    var data: [Int : DayOverview]
    
    var average: Int16
    
    var title: String

    var minRange: String
    
    var maxRange: String
    
}

// rename
struct MonthOverviewChartData {
    
    let maxTasks: Int16
    
    // Max of 30/31 days
    let data: [Date : DayOverview]
    
    var title: String
    
    var mean: Int16
//
//    var minRange: String
//
//    var maxRange: String

}
