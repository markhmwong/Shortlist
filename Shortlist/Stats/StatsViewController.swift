//
//  StatsViewController.swift
//  Five
//
//  Created by Mark Wong on 19/8/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

//  This view controller will display the current month's progress.

import UIKit
import os.log

class StatsViewController: UIViewController {
    
    weak var coordinator: StatsCoordinator?

    weak var persistentContainer: PersistentContainer?
    
	var viewModel: StatsViewModel? = nil
	
    var barChart: BarChart?
    
    var weeklyBarChart: BarChart?
    
	var lineChart: LineChart?

	lazy var totalTasksStat: StatContainer = {
		let view = StatContainer(persistentContainer: persistentContainer, type: StatContainerType.TotalTasks)
		return view
	}()
	
	lazy var completeTasksStat: StatContainer = {
		let view = StatContainer(persistentContainer: persistentContainer, type: StatContainerType.CompleteTasks)
		return view
	}()
	
	lazy var incompleteTasksStat: StatContainer = {
		let view = StatContainer(persistentContainer: persistentContainer, type: StatContainerType.IncompleteTasks)
		return view
	}()
    
    lazy var tasksPerDay: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let str = "Tasks Per Day"
        var attributedStr: NSMutableAttributedString = NSMutableAttributedString(string: "\(str)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: Theme.Font.Bold, size: Theme.Font.FontSize.Standard(.b3).value)!])
        label.attributedText = attributedStr
        return label
    }()
	
	lazy var statStackView: UIStackView = {
		let view = UIStackView()
		view.backgroundColor = Theme.GeneralView.background
		view.alignment = .fill
		view.distribution = .fillEqually
		view.axis = .horizontal
		view.sizeToFit()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
    
	init(persistentContainer: PersistentContainer, coordinator: StatsCoordinator, viewModel: StatsViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
        self.persistentContainer = persistentContainer
		self.viewModel = viewModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		guard let vm = viewModel else { return }
		guard let persistentContainer = persistentContainer else { return }

		navigationController?.navigationBar.barTintColor = Theme.GeneralView.background
		navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Theme.Font.DefaultColor]
		
        view.backgroundColor = Theme.GeneralView.background
		navigationItem.title = "Stats"
        navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(handleDismiss), imageName: "Back", height: self.topBarHeight / 2)
		
		view.addSubview(statStackView)
		statStackView.addArrangedSubview(totalTasksStat)
		statStackView.addArrangedSubview(completeTasksStat)
		statStackView.addArrangedSubview(incompleteTasksStat)
		
		statStackView.anchorView(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, centerY: nil, centerX: nil, padding: .zero, size: CGSize(width: 0.0, height: 130.0))

		// add charts
		let bottomAnchor = calculateStatsForLineChart(from: Calendar.current.forSpecifiedDay(value: -7), bottomAnchor: statStackView.bottomAnchor, title:  "Last 7 Days", dayRange: 7)
		let _ = calculateStatsForLineChart(from: Calendar.current.forSpecifiedDay(value: -30), bottomAnchor: bottomAnchor, title: "Last 30 days", dayRange: 30)

		// add category leaderboard
		vm.completeCategoryList(persistentContainer: persistentContainer)
		vm.incompleteCategoryList(persistentContainer: persistentContainer)
		
    }
	
	func calculateStatsForLineChart(from: Date, bottomAnchor: NSLayoutYAxisAnchor?, title: String, dayRange: Int) -> NSLayoutYAxisAnchor? {
        guard let dayArray = persistentContainer?.fetchRangeOfDays(from: from, to: Calendar.current.today()) else {
            return nil
        }
		guard let _persistentContainer = persistentContainer else { return nil }
        var paddedDayArray = dayArray
		
		// fill missing days
		if (paddedDayArray.count < dayRange) {
			for day in 1...dayRange {
				let date = Calendar.current.forSpecifiedDay(value: -day)
				if (_persistentContainer.fetchDayEntity(forDate: date) == nil) {
					
					// create empty day
					let dayObj = Day(context: _persistentContainer.viewContext)
					dayObj.createNewDayAsPaddedDay(date: date)
					paddedDayArray.append(dayObj)
					_persistentContainer.saveContext()
				}
			}
        }
		
		let stats: StatisticsGenerator = StatisticsGenerator(withArray: paddedDayArray)
        let calculatedStats: MonthOverviewChartData = stats.calculateStats(chartTitle: title)
		
		lineChart = LineChart(inputData: calculatedStats)
		guard let lineChart = lineChart else { return nil }
        view.addSubview(lineChart)
        let paddingTopBottom: CGFloat = 20.0
		lineChart.anchorView(top: bottomAnchor ?? view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: nil, centerY: nil, centerX: nil, padding: UIEdgeInsets(top: paddingTopBottom, left: 0.0, bottom: paddingTopBottom, right: 0.0), size: CGSize(width: view.bounds.width, height: view.bounds.height / 4))
        lineChart.layoutIfNeeded()
		lineChart.prepareChartWithData()
		return lineChart.bottomAnchor
	}
    
    @objc
    func handleDismiss() {
		guard let _coordinator = coordinator else { return }
		_coordinator.dismiss()
    }
	
	deinit {
		coordinator?.cleanUpChildCoordinator()
	}
}
