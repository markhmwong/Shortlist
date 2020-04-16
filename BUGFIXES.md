#  Bug Fixes

### 1.2.4
- Review page task total tasks showing incorrect total, now fixed. I've added an additional check to ensure it will show the correct total task number.
- When switching apps, the task color would not match the state of the task. I.e. If the task was completed, the task button would not be drawn thicker and the task itself wouldn't be faded slightly.

### 1.2.3
- Added support for Reminders to to Shortlist. 
	- Alarms will have to be manually set (for the moment). 
	- Lists are added as Categories.
	- Marking task as complete in Shortlist will also mark the task complete in Reminders
	- Changes made to the title, notes, completion and priority will also be reflected in the Reminders app. To avoid duplicate alarms, alarms will need to be set manually through your preferred app.
- Increased the category character limit to support longer list names carried over from Apple's Reminder app (as some use emails)


### 1.2.2
When an error occurs, all input data is lost. Keep the data instead (read email from Carlos) @done

### 1.2.1

Apologies if you found it difficult to add a category but here's the changes I've made.
Category Input Fixes
	- Post button now coloured correctly
	- Keyboard Done button now submits
	- Placeholder text also removed once typing
	- Character limit correctly colored based on length
	- Character limit re-enforced

Event kit
Complication watch
chart not getting data

### 1.2
Fix "New Day" bug @done
Fix task tally @done
Light mode


### 1.1
Small update but I think still worthy of your efforts
- The Apple Watch app now includes a detailed screen of your task with the ability to mark off the task
- Minor UX fix where the initial task input would not clear the placeholder text
- Minor UI fix, increased the size of the post task button above the keyboard when entering text

https://material.io/collections/developer-tutorials/#ios-swift
