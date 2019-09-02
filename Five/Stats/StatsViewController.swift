//
//  StatsViewController.swift
//  Five
//
//  Created by Mark Wong on 19/8/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

//  This view controller will display the current month's progress.

import UIKit

class StatsViewController: UIViewController {
    
    weak var coordinator: StatsCoordinator?

    var persistentContainer: PersistentContainer?
    
    var barChart: BarChart?
    
    var weeklyBarChart: BarChart?
    
    init(persistentContainer: PersistentContainer, coordinator: StatsCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
        self.persistentContainer = persistentContainer
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        
        calculateStatsForLastThirtyDays()
        calculateStatsForLastSevenDays()
//        calculateStatsForMonth()
//        calculateStatsForYear()
//        calculateStatsForWeek()
    }
    
    // A month overview
    func calculateStatsForMonth() {
        guard let monthly = persistentContainer?.fetchAllTasksByMonth(forMonth: Calendar.current.monthToInt(), year: Calendar.current.yearToInt()) else {
            return
        }
        let stats = StatisticsGenerator(withArray: monthly)
        let monthlyStats: MonthOverviewChartData = stats.calculateStatsForMonth()
        
        barChart = BarChart(inputData: monthlyStats)
        guard let barChart = barChart else { return }
        view.addSubview(barChart)
        barChart.anchorView(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: view.bounds.height / 3.0))
        barChart.layoutIfNeeded()
        barChart.prepareChartWithData()
    }
    
    // A month overview
    func calculateStatsForLastThirtyDays() {
        let from = Calendar.current.thirtyDaysFromToday()
        guard let monthly = persistentContainer?.fetchRangeOfDays(from: from, to: Calendar.current.today()) else {
            return
}
        
        let stats = StatisticsGenerator(withArray: monthly)
        let monthlyStats: MonthOverviewChartData = stats.calculateStats(chartTitle: "Last 30 Days")
        
        barChart = BarChart(inputData: monthlyStats)
        guard let barChart = barChart else { return }
        view.addSubview(barChart)
        barChart.anchorView(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: view.bounds.width, height: view.bounds.height / 3.0))
        barChart.layoutIfNeeded()
        barChart.prepareChartWithData()
    }
    
    func calculateStatsForLastSevenDays() {
        let from = Calendar.current.sevenDaysFromToday()
        guard let dayArray = persistentContainer?.fetchRangeOfDays(from: from, to: Calendar.current.today()) else {
            return
        }
        print(dayArray)
        let stats = StatisticsGenerator(withArray: dayArray)
        let monthlyStats: MonthOverviewChartData = stats.calculateStats(chartTitle: "Last 7 Days")
        
        weeklyBarChart = BarChart(inputData: monthlyStats)
        guard let weeklyBarChart = weeklyBarChart else { return }
        view.addSubview(weeklyBarChart)
        weeklyBarChart.anchorView(top: barChart?.bottomAnchor ?? view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0), size: CGSize(width: view.bounds.width, height: view.bounds.height / 3.0))
        weeklyBarChart.layoutIfNeeded()
        weeklyBarChart.prepareChartWithData()
    }
    
//    func calculateStatsForWeek() {
//        guard let dayArray = persistentContainer?.fetchAllTasksByWeek(forWeek: Calendar.current.startOfWeek(), today: Calendar.current.today()) else {
//            //no data to do
//            return
//        }
//    }
    
    @objc
    func handleBack() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
