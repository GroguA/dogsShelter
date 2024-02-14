## Description

The purpose of the app is to keep track of the dogs currently in the real shelter.

Shelter app is implemented using the Model–View–ViewModel(MVVM) architecture pattern.
This app use:

1. CoreData
2. Local Notifications
3. Imported JSON file as dog breeds source
4. AutoLayout 

## Map

This main screen you can see when use app for first time.

<img src="https://github.com/GroguA/dogsShelter/blob/main/Screenshots/mainView.png?raw=true" height="400" />

This is how the screen will look after adding a dog.

<img src="https://github.com/GroguA/dogsShelter/blob/main/Screenshots/mainView2.png?raw=true" height="400" />

To get started you have to click on the plus icon at the bottom right of the main screen.

When adding a dog to the app you must fill following fields:
1. Name
2. Breed
3. Date of birth
4. Photo*

*if no photo is added, the default image will be used

<img src="https://github.com/GroguA/dogsShelter/blob/main/Screenshots/fillDogView.png?raw=true" height="400" />

Also you can click on the dog on main screen and open screen with detailed information about clicked dog.

<img src="https://github.com/GroguA/dogsShelter/blob/main/Screenshots/details.png?raw=true" height="400" />
<img src="https://github.com/GroguA/dogsShelter/blob/main/Screenshots/changeDog.png?raw=true" height="400" />

On this screen you can do some changes like:
1. Delete dog
2. Schedule a reminder

If you choose to schedule a reminder, such screen would be opened.

<img src="https://github.com/GroguA/dogsShelter/blob/main/Screenshots/reminder.png?raw=true" height="400" />

Where you can fill few text fields and choose whould be this reminder daily repeated.

On the next screen, where you can move from main screen by click on button "Filter" at the top right of the screen, you can filter what dog yoy want to see.

filter screen includes such filters: 
1. Breed filter
2. Age filter

<img src="https://github.com/GroguA/dogsShelter/blob/main/Screenshots/filter.png?raw=true" height="400" />

If click on the "Filter by breed" you will see such screen with the list of breeds:

<img src="https://github.com/GroguA/dogsShelter/blob/main/Screenshots/breeds.png?raw=true" height="400" />

Then if click on the "Filter by age" appear text field in which you can fill age:

<img src="https://github.com/GroguA/dogsShelter/blob/main/Screenshots/age.png?raw=true" height="400" />

The last one screen which can be opened from main screen is screen with list of all scheduled reminders. For open this one screen you should click on button "Notifications" at the top right of the screen. 

All notifications can be selected and deleted.

<img src="https://github.com/GroguA/dogsShelter/blob/main/Screenshots/notifications.png?raw=true" height="400" />
<img src="https://github.com/GroguA/dogsShelter/blob/main/Screenshots/selectedNotif.png?raw=true" height="400" />
