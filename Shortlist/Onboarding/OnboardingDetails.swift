//
//  ChangeLog.swift
//  Shortlist
//
//  Created by Mark Wong on 7/1/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation

struct OnboardingDetails {
	// welcome
	// limit tasks
	// review tasks
	// carry over tasks
	// categorise tasks
	// stats
	typealias Version = Double
	private typealias Title = String
	typealias Details = OnboardingPage
	typealias Log = [ Details ]
	
	static var deltaLogs: [ Version : Log ] = [
		1.00 :
			[
				OnboardingPage(title: "Welcome to Shortlist", details: "Maintain a list of accomplishable tasks every day, complete with reminders, notes, stat tracking.", image: "idea.png"),
				OnboardingPage(title: "Reduce Overflow", details: "Keep your day to a accomplishable limit of tasks. This helps ourselves reach a high note every day without the burnout.", image: "clipboard.png"),
				OnboardingPage(title: "Review Daily", details: "Assess yesterday's progress through the review panel and carry over any tasks; easily allowing you to repeat tasks.", image: "search.png"),
				OnboardingPage(title: "Plan Tomorrow", details: "At any time, you may add additional tasks for tomorrow's schedule.", image: "beach.png"),
				OnboardingPage(title: "Stats", details: "Track and analyse your history of tasks by their complete state, category and time. Stats are stored locally.", image: "stats.png"),
			],
	]
}

struct OnboardingPage {
	
	var title: String
	var details: String
	var image: String
	
}