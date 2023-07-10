Config File Reader
===================

*Location: /lib/src/logic/data/config_file_reader.dart*

Overview
------------
The config file reader class is in charge of reading the config file. Along with the it manages the array scouting data
that is in the progress of being filled out, and the common values database. Note: this class is a singleton and as such
should be accessed through the instance getter method.

Fields
-----------

- configFileFolder: Contains the path for the config file
- year: Contains the year the config file should be
- teamNum: Team number that is read from the config file
- parsedFile: Contains the file in a Map<String, dynamic> format 
- supervise:  Contains the supervise section in a Map<String, dynamic> format 
- strat: Contains the strat section in a Map<String, dynamic> format 
- data: Contains ScoutingData classes for each type of scouting method, holds the current scouting data being filled out
- commonValues: Contains the common values
- password: Contains password for sushi supervise
- _version: Config file version
- _name: No idea wtf this is (figure out later)
- defaultConfig: true if the config file was read in from the assets folder, false if a custom one was used from the database

Methods
------------

- readConfig: Reads config file stored in the assets folder, and updates fields and class *logCurrentConfigFile*
- checkConfigFile: Check if the current config file matches the last logged config file, if it doesn't wipe all user data so that data from different config files doesn't mix
- logCurrentConfigFile: Logs the current config files id
- getSuperviseDisplayString: Gets the identifier for a ScoutingData object, the parameter number defines which identifier to get
- updateAllData:
- readInitalConfig: Supposed to read the config file associated with a team, currently defaults to *readConfig*
- readConfigFromDatabase: Read config file reads a config file stored in the LocalStore database that was previously downloaded by a user. Allow for custom config files.
- getScoutingMethods: Gets the list of scouting methods (currently: cardinal, ordinal, pit)
- getScoutingData: Gets the ScoutingData stored in the *data* field associated with the same *scoutingMethod*. **Does NOT generate a new ScoutingData class just retriviews the current one that is being filled out**
- generateNewScoutingData: Generates a new ScoutingData class based on the *scoutingMethod*
- extraFeatureAccess: Checks if a team has access to restricted features
- setCommonValue: Sets a common value
- commonValuesExists: Checks if a common value exists
- getCommonValue: Gets a common value.
- checkPassword: Checks supervise password
- id: Gets the config file id. Id's are generated as such {teamNumber}+{year}+{version}, ex: 7461+2023+4
