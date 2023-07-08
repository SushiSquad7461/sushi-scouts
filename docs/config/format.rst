Config File Format
===================

The config file is a JSON file, and as such follows standard JSON formatting.

General Info
-------------
Each config file contains a *teamNumber*, *version*, and *password* field. The teamNumber and version fields
are used in the creation of a Config File Id. This Id is used to determine where to upload match data (you cant scan a qr code
of a user with a different id, and you will upload to a different database if you have a different id). This Id also contains
the year of the game, as such the file naming convention for config files is *[current year]config.json*. This Id also for different
config files to be used at the same time, notably thanks to the *teamNumber* attribute it allows two teams to have different config files
and different data storage locations.

Scouting
----------
The scouting section is one of the most important as it identifies how the app will be structured.
The scouting section contains subsections for cardinal, ordinal, and pit scouting.

Supervise
----------

Strat
--------

Example
------------

.. code-block:: json
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

                