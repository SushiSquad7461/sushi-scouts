Components, Sections and Pages
==================================

| *Component Path: lib/src/logic/models/scouting_data_models/component.dart*
| *Section Path: lib/src/logic/models/scouting_data_models/section.dart*
| *Page Path: lib/src/logic/models/scouting_data_models/page.dart*


Component Class
-------------------
This class essentially just holds the Components values.
It uses the json serializable library to assist in this, more
can be found at: https://pub.dev/packages/json_serializable.

Section Class
------------------
Just like the component class this class also primarily just stores 
the section configuration that is read in from the config file.
It contains a list of components and data class's. Note: component and data class's
that are the tied together are assumed to be at the same index in their respective list's.

Along with that the section class has a method called *notFilled* that returns a list
of names of components that are not filled in when they are required in the config file.

Page Class 
---------------
Once again this class serves as primarily one that store the configuration of a page.
It contains a list of sections, and the footer string. Just like the component class
it uses the json serializable library. And just like the section class contains the *notFilled* function along 
with getter functions for components, and values.