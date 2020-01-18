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
		
		static var TheJuggernaut: String = "The Juggernaut"
	}
	
	struct MediumPriority {
		static var TheTerminator: String = "The Terminator"
		static var TheWorkHorse: String = "The Workhorse"
		static var TheBusyBee: String = "The Busy Bee"
	}
	
	struct LowPriority {
		static var TheProcrastinator: String = "The Procrastinator"
		static var TheIgnored: String = "The Cherry Picker"
		static var TheCasualOperator: String = "The Casual Operator"
		static var TheBackSeat: String = "The Back Seat"
		static var TheCliffhanger: String = "The Cliffhanger"
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
//		static var TheWatcher: String = "The Watcher"
		// incomplete tasks with reminders
		static var TheForgotten: String = "The Forgotten"

		static var TheDayDreamer: String = "The Day Dreamer"
		static var ThePolitician: String = "The Politician"
		static var TheFunday: String = "The Funday"
		static var TheSpectator: String = "The Spectator"
		static var TheSloth: String = "The Sloth"
		static var TheLoaf: String = "The Loaf"
		//static var TheStockpiler: String = "The Stockpiler"
	}
	
	struct Complete {
		// a 25% of tasks complete
		static var TheDoer: String = "The Doer"
		static var TheAddresser: String = "The Addresser"
		static var TheGoGetter: String = "The Go Getter"
		static var TheSelfActivist: String = "The Self Activist"
		
		// half tasks complete
		static var TheExecutor: String = "The Executor"
		static var TheWork: String = "The Worker"
		
		// 75% of tasks complete
		static var TheProfessional: String = "The Professional"
		static var TheOrganizer: String = "The Organizer"
		static var TheAchiever: String = "The Achiever"
		
		// completed all tasks today
		static var TheCompletionist: String = "The Completionist"
		static var ThePowerhouse: String = "The Powerhouse"
		static var TheEyeOfTheTiger: String = "The Eye Of The Tiger"
		
		// compeleted tasks that were carried over
		static var TheAvenger: String = "The Avenger"
		static var TheReturnOfTheKing: String = "The Return Of The King"
	}
	
	struct Time {
		
		//
		static var TheDispatcher: String = "The Dispatcher"
		
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
		static var TheCastAway: String = "The Cast Away"
	}
	
	struct CarryOver {
		static var ThePlanner: String = "The Planner"
		
	}
}
