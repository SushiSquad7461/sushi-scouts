Scouting Data Class 
=========================

The scouting data class is the class that stores an entry of scouting data.

Fields
------------
- name: Name of the scouting method (ex: cardinal)
- pages: A map of pages, with the key being the name of the page (not footer name)
- pageNames: A list equivalent to pages.keys 
- hasSchedule: True if a schedule has been submitted
- schedule: Schedule for competition (see MatchSchedule)
- currPage: The current page that the user is filling out

Methods
------------
- constructor: Fills in pages based on config file
- factory constructor: Creates a new scouting data class based on a stringified version of the scouting data. Used when getting stringified class's from QR code or Firebase. 
- notFilled: Returns components that are not filled in at the current page.
- canGoToNextPage: Checks if we are on the last page
- canGoToPrevPage: Checks if we are on the first page
- nextPage: Goes to the next page
- prevPage: Goes back a page
- stringfy: Stringfys the class
- getCurrentPage: Returns current page
- updateSchedule: Checks the LocalStore database for a schedule, if their is create set it to equal *schedule* field 
- nextMatch: Clears all data while incrementing match #, keeping station the same, and autofilling robot numbers
- getData: Gets all Data class's
- toJson: Converts to json
- getComponents: Get all components
- getCertainData: Get the value of a certain component based on page name and component name
- getCertainDataByName: Same above but only using component name
- decodeMultiSelectData: Decodes multiselect data into an actual map (see multiselect)