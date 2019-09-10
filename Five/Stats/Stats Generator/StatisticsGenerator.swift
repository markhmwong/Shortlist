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
    
    // Converting the coredata data to readable data for the chart for each day
    func calculateStats(chartTitle: String) -> MonthOverviewChartData {
        var totalTasksForDay: Int16 = 0
        var totalCompletedForTimePeriod: Int16 = 0
        var convertedData: [Date : DayOverview] = [:]
        var taskLimit: Int16 = 0
        var meanTasksCompleted: Int16 = 0
        var incompleteTasks: Int16 = 0
        let chartTitle: String = chartTitle
        
        guard let dayArray = dayArray else {
            return MonthOverviewChartData(maxTasks: 0, data: [:], title: chartTitle, mean: 0)
        }
        
        for day in dayArray {
            taskLimit = mostAmountOfTasksForDay(currLimit: day.taskLimit, newLimit: taskLimit)
            totalCompletedForTimePeriod += day.totalCompleted
            totalTasksForDay += day.totalTasks
            incompleteTasks = day.totalTasks - day.totalCompleted
            
            let date = Calendar.current.dayOfWeek(date: day.createdAt! as Date)
            print(day.createdAt!)
            guard let dayOfWeek = DayOfWeek(rawValue: Int16(date)) else {
                fatalError("Day Type does not exist")
            }
            
            let dayOverview: DayOverview = DayOverview(dayOfWeek: dayOfWeek, dayDate: Int(day.day), numberOfCompletedTasks: day.totalCompleted, incompleteTasks: incompleteTasks)
            
            convertedData[day.createdAt! as Date] = dayOverview
        }
        meanTasksCompleted = meanTasks(Float(totalCompletedForTimePeriod), Float(dayArray.count))
        
        return MonthOverviewChartData(maxTasks: taskLimit, data: convertedData, title: chartTitle, mean: meanTasksCompleted)
    }
    
    func meanTasks(_ completedTasks: Float, _ numberOfDays: Float) -> Int16 {
        if numberOfDays != 0 {
            return Int16(round(completedTasks / numberOfDays))
        }
        return 0
    }
    
    // Week beginning from Sunday
    func calculateStatsForWeek() -> Void {
        var totalTasks: Int = 0
        var totalCompletedForTimePeriod: Int = 0
        var weekData: [DayOverview] = []
        var incompleteTasks: Int16 = 0

        guard let dayArray = dayArray else {
            return
        }
        
        for day in dayArray {
            totalCompletedForTimePeriod += Int(day.totalCompleted)
            totalTasks += day.dayToTask?.count ?? 0
            
            guard let dayType = DayOfWeek(rawValue: day.day) else {
                fatalError("Day Type does not exist")
            }
            incompleteTasks = day.totalTasks - day.totalCompleted
            let dayStruct: DayOverview = DayOverview(dayOfWeek: dayType, dayDate: Int(day.day), numberOfCompletedTasks: day.totalCompleted, incompleteTasks: incompleteTasks)
            weekData.append(dayStruct)
        }
    }
    
    // Add Indicator to show highest amount of tasks complete for bar.
    func mostAmountOfTasksForDay(currLimit: Int16, newLimit: Int16) -> Int16 {
        return currLimit < newLimit ? newLimit : currLimit
    }
}
