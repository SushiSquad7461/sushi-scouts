Data
======================

*Path: /lib/src/logic/data/data.dart*

The data class holds the data for a component. The purpose of this class is to have a common
interface for scouting data of different types.

The data class supports booleans, numbers, and strings. This class is fairly self explanatory so the documentation will only mention
a couple of noteworthy features.

The *setByUser* field is used to figure out if the user has typed in the value
or if it was set by the program (ex: when wiping scouting data), this is used to determine
if the required component has been met.

The *timestamps* array is used to track the time between value changes.
However the time will only be recorded if the difference is more then the *minTimestampDifference* which is currently 1000 ms.