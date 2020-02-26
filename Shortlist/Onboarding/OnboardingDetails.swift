//
//  ChangeLog.swift
//  Shortlist
//
//  Created by Mark Wong on 7/1/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import Foundation

struct OnboardingPage {
	var title: String
	var details: String
	var image: String
}

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
				OnboardingPage(title: "Welcome to Shortlist", details: "The to do list that won't let you add an abundance of tasks.", image: "idea.png"),
				OnboardingPage(title: "Reduce Overflow", details: "The idea is to only list tasks that can only be completed today, helping you reduce any lingering tasks.", image: "clipboard.png"),
				OnboardingPage(title: "Review Daily", details: "Assess yesterday's progress through the review panel and carry over any tasks; easily allowing you to repeat tasks.", image: "search.png"),
				OnboardingPage(title: "Plan Tomorrow", details: "Add tasks to tomorrow's schedule to plan ahead. Allowing you to be ready to go for tomorrow.", image: "beach.png"),
				OnboardingPage(title: "Stats", details: "Track and analyse your history of tasks by their complete state, category and time.", image: "stats.png"),
			],
	]
}


