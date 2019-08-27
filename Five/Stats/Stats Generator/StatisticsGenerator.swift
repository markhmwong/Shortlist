//
//  Statistics.swift
//  Five
//
//  Created by Mark Wong on 22/8/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation

class StatisticsGenerator: NSObject {
    
    // input data
    var dayArray: [Day]?
    
    init(withArray arr: [Day]) {
        self.dayArray = arr
    }
    
    // Calculate for year
    func calculateStatsForYear() -> Void {
        
    }
    
    // Calculate for month
    func calculateStatsForMonth() -> MonthOverviewChartData {
        var totalTasksForDay: Int16 = 0
        var totalCompletedForTimePeriod: Int = 0
        var convertedData: [Int : DayOverview] = [:]
        var maxTaskLimit: Int16 = 0
        
        guard let dayArray = dayArray else {
            return MonthOverviewChartData(maxTasks: 0, data: [:])
        }
        for day in dayArray {
            print("day.day \(day.day)")
            if (day.taskLimit > maxTaskLimit) {
                maxTaskLimit = Int16(day.taskLimit)
            }
            
            totalCompletedForTimePeriod += Int(day.totalCompleted)
            totalTasksForDay += day.totalTasks
            
            let date = Calendar.current.dayOfWeek(date: day.createdAt! as Date)
            guard let dayOfWeek = DayOfWeek(rawValue: Int16(date)) else {
                fatalError("Day Type does not exist")
            }
            
//            let month: MonthOverView = MonthOverView(date: Int(day.day), numberOfCompletedTasks: day.totalCompleted)
            
            let dayOverview: DayOverview = DayOverview(dayOfWeek: dayOfWeek, dayDate: Int(day.day), numberOfCompletedTasks: day.totalCompleted)
            
            convertedData[Calendar.current.dayDate(date: day.createdAt! as Date)] = dayOverview
        }
        return MonthOverviewChartData(maxTasks: maxTaskLimit, data: convertedData)
    }
    
    // Week beginning from Sunday
    func calculateStatsForWeek() -> Void {
        var totalTasks: Int = 0
        var totalCompletedForTimePeriod: Int = 0
        var weekData: [DayOverview] = []
        guard let dayArray = dayArray else {
            return
        }
        
        for day in dayArray {
            totalCompletedForTimePeriod += Int(day.totalCompleted)
            totalTasks += day.dayToTask?.count ?? 0
            
            guard let dayType = DayOfWeek(rawValue: day.day) else {
                fatalError("Day Type does not exist")
            }
            
            let dayStruct: DayOverview = DayOverview(dayOfWeek: dayType, dayDate: Int(day.day), numberOfCompletedTasks: day.totalCompleted)
            weekData.append(dayStruct)
        }
    }
}

