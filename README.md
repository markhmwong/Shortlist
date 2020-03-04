Shortlist
======

# Demo
![App Video](./Shortlist_Demo.gif)

# Contents

1.0 		Overview
2.0 		App Architecture and Structure
	2.1.0.0		Model, View, View-Model and the Coordinator
		2.1.1.0		Coordinator
		2.1.2.0		ViewController / View / View Model / Layout
			2.1.2.1		UIKit Components
			2.1.2.2		Cell Factory
		2.1.3.0 		Model Layer
			2.1.3.1 		Core Data
			2.1.3.2 		Key Chain
			2.1.3.3 		User Defaults
			2.1.3.4 		Firebase		
3.0 Services
	Firebase, Tips, IAP, Image Feedback, Connectivity, Temporary Storage, Local Notifications, KeyChain
4.0 Graphing
4.1 Stats
6.0 Techniques Summary

Unit Tests

# 1.0 Overview
This app was designed to keep users from overloading themselves during the day, and to stay focused on the most important task at hand. The base idea was to remove the abundance we all take for granted in our lives. Abundance of storage in our devices, abundance of time in our day, abundance of tasks we carry.

# 2.0 Architecture and Structure

## 2.1.0.0 Model, View, View-Model and the Coordinator
The general structure for the application uses the Model, View, View-Model approach while also keeping the navigation contained in it's own class and controls the appearance or disappearance of the viewcontroller - navigation files are affixed by coordinator, which follows the Coordinator Pattern developed by Soroush Khanlou (http://khanlou.com/).

	Coordinator
		ViewController
			Model (PersistentContainer)
			View
			ViewModel

As described above, the hierachy describes how the general structure of the Coordinator, ViewController and the 3 main components interact together. Each page whether it'd be the Settings, Priority Limit, Main View, BackLog etc is governed by a viewcontroller. The model or in this case since we are using Core Data. Through a single instance, we are passing the Persistent Container via Dependency Injection where it is needed through the coordinator and into the viewcontroller.

## 2.1.1.0 Coordinator

The Coordinator controlls all the navigation within it's functions and keeps tabs on what viewcontroller is in memory and not by queuing the Viewcontroller's Coordinator in an array of Child Coordinators. For instance, the Settings panel contains various navigation paths

	Settings
		Priority Limit
		Review
		Info
		Stats

When one of these "sub" viewcontrollers triggers, its' coordinator will be placed on the ChildCoordaintor array, housed inside the Settings Coordinator, since this is the parent Coordinator for all those views below it. Coordinators are pushed on to the queue and popped when viewcontrollers are dismissed or presented/pushed.

## 2.1.2.0 ViewController / View / View Model / Layout

As described in most MVC/MVVM theory pieces, the viewcontroller handles the communication between the view and the viewmodel/model. It can be seen as the main hub of communication between everything that relates to the page as it holds references to the persistent container, the coordinator, the view and any independent services such as Connectivity, please refer to the Services section.

The entirety of the view components can be found in the viewcontroller, using Autolayout to layout components.

While the view model contains most of the default values for the cells and is responsible for translating the data into something readble for the user.

## 2.1.2.1 UIKit Components
UIView, UILabel, UIImageView, UISwitch, UIDatePicker, UIButton, UITextView
UITableView, UITableViewCell
UIViewController
CALayer, CAShapeLayer, UIBezierPath, CAGradientLayer

## 2.1.2.1 Cell Factory

Most, if not all of the cell production. Unless it's a table view that holds various different cell types such as the Settings Page or Task Edit Page where some cells may contain a toggle, disclaimer text, or textfields. A Cell Factory is used here to easily select and extend new cells for future creation. It combines the use of the Enums and a Singleton.

## 2.1.3.0 Model Layer
The application uses four distinct storage vectors - Core Data, Key Chain and User Defaults. The fourth data storage is remote using Firebase's realtime database storage. Each is use for their own specific purpose to store and persist data that may be needed even if the app is uninstalled from the device and to avoid any tampering from external sources which is usually the case with UserDefaults.

In general the Persistent Container (Core Data) is passed via Dependency Injection for each ViewController and uses the FetchedResultsController to dynamically display the data required in the event data is altered, FetchedResultsController handles that.

## 2.1.3.1 Core Data
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

	BackLog 	1-N Task

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

On load, a new Day NSManagedObject is created every day if the user opens the app.

### BackLog, Task

	BackLog 	1-N Task

Terribly named BigListTask but the BackLog and the associated entity, holds a list of incomplete tasks.  Tasks are added here during the Review phase which is conducted once per day. Whether the list should be infinite or finite remains to be seen as of writing.

### Stats, StatsCategoryComplete/Incomplete

Looking at the relationship, one may wonder why a 1 to many relationship is used. In order to avoid further queries and then calculate the stats, the stats are determined after a user has casted an action in the app, calculated and stored here, so the entities StatsCategoryComplete/Incomplete were created. The relationship defines stats for each category, therefore we must have a 1 to many relationship to keep the statistics personalised for each category.


### CategoryList
An infinite list of categories. Also used when the user inputs a category, a search begins and checks whether the category exists to avoid duplicate categories.

## 2.1.3.2 Key Chain
Writing data such as In-App purchases, allows the application to remember purchase states. The implementation used to access the Key Chain found here on [Github](https://github.com/puretears/KeychainWrapper). An easy to use wrapper very similar to User Defaults.

## 2.1.3.3 User Defaults
User Defaults data is removed when the app uninstalls. Key Chain data isn't. Using UserDefaults to identify whether the app is on its' first load is a good idea. Although, User Defaults can be changed easily, the data isn't overly sensitive and only installs some tasks to help new users use the app and load the tutorial.

## 2.1.3.4 Firebase
Storage to grab statistical data from users. Mainly data about tasks such as whether a task is complete. In the future it may take other data.

# 6.0 Techniques Summary
### Extensions

### Autolayout

Storyboards were intentionally ignored

### MVVM

MVVM applied to each ViewController to keep the architecture consistent.

### Enumerations

Group keys and identify state. An example was to use this to identify the priority level of a task. Although the Priority level was stored as an integer in Core Data, it increases readability by applying an enum to the integer

### Protocols

Generally to bind a class/struct to particular variables and functions. Although in one instance empty protocols were used to group categories of enums together to minimise the amount of functions written. There are two groups of Observe keys, for the Main page and the Settings page found in CoordinatorProtocolsAndEnums.swift. Under the ObserverChildCoordinatorsProtocol, we can see that only two functions were written to maintain the observers for both groups of Enums rather than two groups of functions to maintain both groups.

### Memory management

Unowned, weak applied to variables that could potentially have a strong link with each other.

### Variable scope

Private applied to variables to hide and not expose them to other objects that don't require them.

### Key-Value Observer

In this case I used KVO to identify when a ViewController was dismissed. Although UINavigationDelegate should be used I found that the call to it's delegate function when the view controller came into view again was not called. And used KVO as a way around this problem.

### UITableView, Autolayout,  

custom cell, cell reuse

### Object Factory

One example can be found within the Settings to generate various types of userinterfaces for each cell type.

### Singletons

Found in Factory Classes and Services, generally objects that aren't needed to be passed and its' data maintained throughout the lifecycle of the application

### Line graph drawing

Graph uses a combination of CAShapeLayers, Bezier paths to draw the lines. First the graph data is generated by iterating over each day to grab the complete and incomplete tasks in the form of a structure. Data is then placed into the LineChart object for further processing to generate x,y coordinates based on the bounds (Rect) of the chart. Data is then iterated over again to draw the chart itself.

### URLSession and Firebase
