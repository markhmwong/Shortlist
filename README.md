Shortlist
======

# Contents

1.0 Overview
2.0 Architecture and Structure
	2.1.0 Model Layer
		2.1.1 Core Data
		2.1.2 Key Chain
		2.1.3 User Defaults
		2.1.4 Firebase

# 1.0 Overview



# 2.0 Architecture and Structure

## 2.1.0 Model Layer
The application uses four distinct storage vectors - Core Data, Key Chain and User Defaults. The fourth data storage is remote using Firebase's realtime database storage. Each is use for their own specific purpose to store and remember data that may  be needed even if the app is uninstalled from the device.

## 2.1.1 Core Data
The main persistent store used to hold information regarding the days, tasks, categories and incomplete tasks and their related statistics. Core Data allows data to be queried and sorted easily through the Core Data API which also works in conjunction with the UITableView with NSFetchedResultsController.

The main entities used are as follows

	Day
	Task
	DayStats
	Stats
	StatsCategoryComplete
	StatsCategoryIncomplete
	CategoryList
	BigListTask (Should really be renamed to BackLogTask)
	BackLog


Below is an outline of the relationships between Entities / NSManagedObjects

	Day		1-N Task
			1-1 DayStats

	BackLog 	1-N BigListTask

	Stats		1-N StatsCategoryComplete
			1-N StatsCategoryIncomplete
	
	CategoryList null

### Day, Tasks, and stats
This holds specific information where a lot of the data in it's related Task Entity is provided by the user. 

	Day	1-N Task
		1-1 DayStats
		
A one to many relationship with the Task entity is obvious while each Day also holds one set of statistical data in order to avoid further queries. Stats are calculated on the go when the user makes an action

	Day 1-N Task

Days can have may Tasks. Tasks carry user generated information such as the name of the task, additional notes (details), priority and reminders. Although the amount of Tasks per day is limited and bound by Settings set by the User.

A new Day NSManagedObject is created every day if the user opens the app. However skipped days are substituted by a simple function 

	searchNilDaysOverThirtyDays() // MainViewController.swift
	
which fills in nil days. This is practical and supports Stats, as every day is required in order to calculate the statistics of the User's behavior. 

### BackLog, BigListTask

	BackLog 	1-N BigListTask
	
Terribly named BigListTask but the BackLog and the associated entity, holds a list of incomplete tasks.  Tasks are added here during the Review phase which is conducted once per day. Whether the list should be infinite or finite remains to be seen as of writing.

### Stats, StatsCategoryComplete/Incomplete

Looking at the relationship, one may wonder why a 1 to many relationship is used. In order to avoid further queries and then calculate the stats, the stats are determined after a user has casted an action in the app, calculated and stored here, so the entities StatsCategoryComplete/Incomplete were created. The relationship defines stats for each category, therefore we must have a 1 to many relationship to keep the statistics personalised for each category.


### CategoryList
An infinite list of categories. Also used when the user inputs a category, a search begins and checks whether the category exists to avoid duplicate categories.

## 2.1.2 Key Chain
Writing data such as In-App purchases, allows the application to remember purchase states. The implementation used to access the Key Chain found here on [Github](https://github.com/puretears/KeychainWrapper). An easy to use wrapper very similar to User Defaults.

## 2.1.3 User Defaults
User Defaults data is removed when the app uninstalls. Key Chain data isn't. Using UserDefaults to identify whether the app is on its' first load is a good idea. Although, User Defaults can be changed easily, the data isn't overly sensitive and only installs some tasks to help new users use the app and load the tutorial.

## 2.1.4 Firebase
Storage to grab statistical data from users. Mainly data about tasks such as whether a task is complete. In the future it may take other data. 
