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
	struct HighPriority {
		// completed all priority tasks - number of high priority
		static var ThePresident: String = "The President"
		
		// complete some high priority tasks
		static var TheTopBrass: String = "The Top Brass"
	}
	
	struct MediumPriority {
		static var TheDoer: String = "The Doer"
		static var TheTerminator: String = "The Terminator"
		static var TheWorkHorse: String = "The Workhorse"
	}
	
	struct LowPriority {
		static var TheProcrastinator: String = "The Procrastinator"
	}
	
	struct Category {
		// complete 3 or more of the same category
		static var TheSpecialist: String = "The Specialist"
		
		// complete all unique categories - categories must all be unique to each other
		static var TheGeneralist: String = "The Generalist"
	}
	
	// award @done
	struct Incomplete {
		static var TheCouchPotato: String = "The Couch Potato"
		
		// incomplete tasks with reminders
		static var TheForgotten: String = "The Forgotten"

		static var TheDayDreamer: String = "The Day Dreamer"
		static var ThePolitician: String = "The Politician"
		static var TheFunday: String = "The Funday"
	}
	
	struct Complete {
		// a couple of tasks complete
		static var TheDoer: String = "The Doer"
		
		// 80% of tasks complete
		static var TheExecutor: String = "TheExecutor"
		
		// half tasks complete
		static var The: String = "TheExecutor"

		
		
		// completed all tasks today
		static var TheCompletionist: String = "The Completionist"
		
		// compeleted tasks that were carried over
		static var TheAvenger: String = "The Avenger"
		static var TheReturnOfTheKing: String = "The Return Of The King"
	}
	
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
