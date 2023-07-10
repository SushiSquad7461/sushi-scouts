Supervise And Schedule Data
===============================

Supervise
-----------
Supervise data just holds an ScoutingData object along with a couple of fields used in Sushi Supervise,
and fields that don't change year to year (ex: scouters name).

- flagged: true if data has been flagged by a lead scout as possibly inaccurate
- deleted: true if data is not supposed to be used in calculations for sushi strategy (note: no data is ever deleted it is simply marked as so)
- methodName, display1, display2: used for data identifiers
- name: scouters name
- teamNum: scouters team number

MatchSchedule
-------------------
Simply holds a competition schedule. Contains a list of Matches.
Matches contain a list of team's. Each team contains a team name and a station.
