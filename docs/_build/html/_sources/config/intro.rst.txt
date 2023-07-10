Intro
=========

The config file is an essential part of the Sushi Scouts application. The entire application is based on the config file.
The config file system as built with with a couple of principles in mind.

1. The config file can be changed at any time without needing to change the code. This allows for the app to be modified to a new season in a matter of minutes, and allows for quick changes to the config file throughout the season as the strategy teams needs change
2. Multiple teams can create their own config files and use them

However with these principles comes one problem, config file mixing. The codebase is designed so that data from config file cant, and wont work.
As such whenever a config file is modified its id (discussed later) must change. Their are multiple safety features implemented throughout the app
to ensure that config files don't mix, however this has still been one of our biggest issues at competitions and should always be thought about
when developing the app, and creating config files.