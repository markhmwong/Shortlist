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
    
    lazy var statTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let str = "Stats"
        var attributedStr: NSMutableAttributedString = NSMutableAttributedString(string: "\(str)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.h0).value)!])
        label.attributedText = attributedStr
        return label
    }()
    
    lazy var tasksPerDay: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let str = "Tasks Per Day"
        var attributedStr: NSMutableAttributedString = NSMutableAttributedString(string: "\(str)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b3).value)!])
        label.attributedText = attributedStr
        return label
    }()
    
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
        
        view.addSubview(statTitle)
        statTitle.anchorView(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: .zero)
        
        calculateStatsForLastSevenDays()
//        calculateStatsForLastThirtyDays()
//        calculateStatsForYear()
//        calculateStatsForWeek()
    }
    
    // Last 7 day overview
    func calculateStatsForLastSevenDays() {
        let from = Calendar.current.sevenDaysFromToday()
        guard let dayArray = persistentContainer?.fetchRangeOfDays(from: from, to: Calendar.current.today()) else {
            return
        }        
        
        let stats = StatisticsGenerator(withArray: dayArray)
        let monthlyStats: MonthOverviewChartData = stats.calculateStats(chartTitle: "Last 7 Days")
        
        weeklyBarChart = BarChart(inputData: monthlyStats)
        guard let weeklyBarChart = weeklyBarChart else { return }
        view.addSubview(weeklyBarChart)
        let paddingTopBottom: CGFloat = 10.0
        weeklyBarChart.anchorView(top: statTitle.bottomAnchor, bottom: nil, leading: view.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: paddingTopBottom, left: 0.0, bottom: paddingTopBottom, right: 0.0), size: CGSize(width: view.bounds.width, height: view.bounds.height / 3.0))
        weeklyBarChart.layoutIfNeeded()
        weeklyBarChart.prepareChartWithData()
    }
    
    // Previous 30 day overview
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
        barChart.anchorView(top: weeklyBarChart?.bottomAnchor ?? view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0), size: CGSize(width: view.bounds.width, height: view.bounds.height / 3.0))
        barChart.layoutIfNeeded()
        barChart.prepareChartWithData()
    }
    
    @objc
    func handleBack() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
