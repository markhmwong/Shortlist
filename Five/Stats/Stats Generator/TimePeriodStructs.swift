//
//  StatisticsStructs.swift
//  Five
//
//  Created by Mark Wong on 24/8/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation

// Chart structures that organises the data into their Week, Month, Year overview

protocol OverviewData {
    
}

// Day Overview
// Tranposes the data into readable variables
// We can grab the Date() object from Core Data and convert that into
// day of the week and a day date representation

struct DayOverview: OverviewData {
    
    // Represents the day of the week. Monday, Tuesday etc. Needs to be converted from CoreData
    let dayOfWeek: DayOfWeek
    
    let dayDate: Int
    
    let numberOfCompletedTasks: Int16
    
}

// Month Overview - no longer in use. We'll use the DayOverview
//struct MonthOverView: OverviewData {
//    
//    let date: Int
//    
//    var numberOfCompletedTasks: Int16
//    
//}

// A summary of a week's data
// Stores properties

struct WeekChartData {
    
    let maxTasks: Int16
    
    // Max of 30 days
    let data: [Int : DayOverview]
    
}

struct MonthOverviewChartData {
    
    let maxTasks: Int16
    
    // Max of 30/31 days
    let data: [Int : DayOverview]
    
}
