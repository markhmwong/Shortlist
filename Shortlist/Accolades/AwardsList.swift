//
//  Awards.swift
//  Shortlist
//
//  Created by Mark Wong on 28/12/19.
//  Copyright © 2019 Mark Wong. All rights reserved.
//

import Foundation

// List of awards given to the user during the review stage

struct AwardsList {
	// @done priorties
	struct HighPriority {
		// completed all priority tasks - number of high priority
		static var ThePresident: String = "The President"
		
		// complete some high priority tasks
		static var TheTopBrass: String = "The Top Brass"
		
		static var TheBoss: String = "The Boss"
	}
	
	struct MediumPriority {
		static var TheToiler: String = "The Toiler"
		static var TheWorkHorse: String = "The Workhorse"
		static var TheSlogger: String = "The Slogger"
	}
	
	struct LowPriority {
		static var TheProcrastinator: String = "The Procrastinator"
		static var TheLoafer: String = "The Loafer"
		static var TheTimeKiller: String = "The Time Killer"
	}
	
	// @done award
	struct Category {
		// complete 3 or more of the same category
		static var TheSpecialist: String = "The Specialist"
		static var TheProfessional: String = "The Professional"
		
		// complete 5
		static var TheIceman: String = "The Iceman"
		static var TheMaster: String = "The Master"
		
		// complete all unique categories - categories must all be unique to each other
		static var TheGeneralist: String = "The Generalist"
		static var TheRenaissanceMan: String = "The Renaissance Man"
		static var TheFactotum: String = "The Factotum"
	}
	
	// award @done
	struct Incomplete {
		static var TheCouchPotato: String = "The Couch Potato"
		static var TheUndecided: String = "The Undecided"
		static var TheForgotten: String = "The Forgotten"

		static var TheDayDreamer: String = "The Day Dreamer"
		static var ThePolitician: String = "The Politician"
		static var TheFunday: String = "The Funday"
	}
	
	struct Complete {
		// min ~30% of tasks complete
		static var TheDoer: String = "The Doer"
		static var TheGoGetter: String = "The GoGetter"
		
		// min ~70% of tasks complete
		static var TheExecutor: String = "The Executor"
		static var TheHustler: String = "The Hustler"
		static var ThePowerHouse: String = "The Power House"
		
		// min 50% tasks complete
		static var TheBusyBee: String = "The Busy Bee"
		static var TheGrunt: String = "The Grunt"

		
		// completed all tasks today
		static var TheCompletionist: String = "The Completionist"
		static var TheHighAchiever: String = "The High Achiever"
		static var TheOneManBand: String = "The One Man Band"
	}
	
	// to do
	struct Time {
		// complete tasks early for a free cruisy afternoon
		static var TheBraveHeart: String = "The Braveheart"
		
		// complete tasks shortly after adding
		static var TheAvenger: String = "The Quickdraw"

		// complete all tasks, with reminders and notes attached
		static var ThePerfectionist: String = "The Perfectionist"
		
		// all tasks have reminders
		static var ThePlanner: String = "The Planner"
	}
	
	
	struct Delete {
		static var TheRejecter: String = "The Rejecter"
	}
}
		// compeleted tasks that were carried over
//		static var TheAvenger: String = "The Avenger"
//		static var TheReturnOfTheKing: String = "The Return Of The King"
//		The Temrinator
//		The Silver Medal
//		https://www.wordhippo.com/what-is/another-word-for/workhorse.html
