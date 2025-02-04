Config File Format
===================

*Location: /assets/config/{year}config.json*

The config file is a JSON file, and as such follows standard JSON formatting.

General Info
-------------
Each config file contains a *teamNumber*, *version*, and *password* field. The teamNumber and version fields
are used in the creation of a Config File Id. This Id is used to determine where to upload match data (you cant scan a qr code
of a user with a different id, and you will upload to a different database if you have a different id). This Id also contains
the year of the game, as such the file naming convention for config files is *[current year]config.json*. This Id allows for different
config files to be used at the same time, notably thanks to the *teamNumber* attribute it allows two teams to have different config files
and different data storage locations. Note: If a config file is modified its id **MUST** be different from previously used config files, that is
why the version field exists. The *password* field contains the password that lead scouts need to enter
to access sushi supervise.

Scouting
----------
The scouting section is one of the most important as it identifies how the app will be structured.
The scouting section contains subsections for cardinal, ordinal, and pit scouting. Note that these sections
are not required, for example ordinal scouting can be removed and sushi scouts, and supervise will work, however
some parts of sushi strategy will need to be adjusted.

Each subsection is split into pages. A page is simply what it implies, its a single page that contains scouting fields,
each new page added, will add a new page that the user needs to fill out. Each page has a name, and a footer. The footer
is simply the name the user sees at the bottom of the page, while the name of the page is an important identifier.

Each page also contains a field called *sections*. The *sections* field is an array of sections. Each section is essentially one row,
sections are rendered sequentially, so if a section appears before another section in the array its row of components will be rendered
above the other section.

Each section has a list of the following properties:

- title: Just like pages can have titles viewable to user, sections can to. Each title is displayed at the top of the section.
- color: This is the color components will be in the section
- rows: This defines the number of **columns** this section will have (don't worry about it, someone needs to fix this).
- textColor: This is the color text will be in the section
- darkColor: This is the color the component will have in the section in dark mode.
- darkTextColor: This is the color text will be in dark mode.
- componentsInRow: This defines how many components will be in each column. For example given the array [3,1], this says that the the first three components will be in column 0, while the last component will be in column 1.

Finally each section is broken down into components. Note: due to the *componentsInRow* field the order of components matters.
Components have the following properties.

- name: The name of the component **NOTE: No two components may have the same name in the same page as the name is used as an identifier in the code**
- type: The type of data collected (String, number, boolean, etc..), supported types are described in the Data class section
- component: The type of component that will be rendered, support components are described in the component sections
- required: Whether the completion of this field is required to submit the scouting data
- timestamp: When true, this will record the timestamps of changes to the value of the component. Note: currently has no support for data export
- isCommonValue: When true the value of the component will be replaced with the value stored in the common values database (See common values page)
- setCommonValue: When true will create an entry in the common values database with the key being the name, and the value being the value of the component (used in ordinal scouting to translate robot numbers from one page to the next)
- values (Optional): Only needed when the component requires it. It is an array of values. For example a multiselect component will need an array of choices.

Supervise
----------
The supervise section contains fields that will be used to identify scouting data. Each piece of data has three unique identifiers
intended to differentiate it from other data. The first one is always the first letter of the scouting type, for example cardinal scouting
will have "C" be the first identifier. The other tow identifier's are identified in the config file, by giving their page name, and
component name. Currently the identifiers for cardinal are the match number and station. So an example of a full cardinal identifier
would be C - B1 - 15. Note: when storing data, names of scouters are added to the identifiers so that scouters can be "doubled" up on robots
however when displaying data names are removed from the identifiers and extra data with the same identifier is in some cases averaged out and in others
discarded. Also note that each type of scouting needs to have defined identifiers as for example in Pit scouting their is not match number.

Strategy
---------
The strategy section is split into two small parts, profile and ranking.

Ranking simply defines which scouting method contains ordinal scouting (this allows for the name to be changed), however still
requires the use ranking components.

Profile defines which scouting method to look at to create profiles. Currently team profiles are done with pit data, but
could also be done with cardinal data. It has the following field:

- method-name - which scouting method to look at for data (currently pit)
- identifier - which component name to look at to split data into profiles (currently team #), each different identifier will have a new profile
- version - component name that identifies the version of the data (currently day #), this allows a profile to have multiple different data points displayed for example if displaying cardinal, match number could be used to display multiple matches worth of data. 

Example
------------

.. code-block::
   :caption: A shortened config file example from the 2022 game (full one can be viewed on the Sushi Scouts github in assets)

    {
        "teamNumber": 7461,
        "version" : 5,
        "password" : "7461",
        "strat": {
            "profile": {
                "method-name": "pit",
                "identifier": "team #",
                "version": "day #"
            },
            "ranking": {
                "method-name": "ordinal"
            }
        },
        "supervise": {
            "cardinal": {
                "first" : {
                    "page": "pregame",
                    "name": "match #"
                },
                "second" : {
                    "page": "pregame",
                    "name": "station"
                }
            },
            .... (ordinal, and pit follow)
        },
        "scouting": {
            "cardinal":{
                "pregame" : {
                    "footer": "info",
                    "sections" : [
                        {
                            "properties":{
                                "title":"",
                                "color": "#ff76a2",
                                "rows": 2,
                                "textColor": "#000000",
                                "darkColor": "#81F4E1",
                                "darkTextColor": "#ffffff",
                                "componentsInRow": [3, 1]
                            },
                            "components":[
                                {
                                    "name" : "match #",
                                    "type" : "number",
                                    "component" : "number input",
                                    "required" : true,
                                    "timestamp": false,
                                    "isCommonValue" : false,
                                    "setCommonValue" : false
                                },
                                ..... (more components follow)
                            ]
                        }
                    ]
                    }
                }
            }
        }
    }

                