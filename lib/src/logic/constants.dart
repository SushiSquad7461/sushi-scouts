// Flutter imports:
import "package:flutter/widgets.dart";

// Project imports:
import "../views/ui/sushi_strategy/carindal_export.dart";
import "../views/ui/sushi_strategy/ordinal_ranking.dart";
import "../views/ui/sushi_strategy/robot_profiles.dart";
import "../views/ui/sushi_strategy/strat_settings.dart";
import "../views/util/components/checkbox.dart";
import "../views/util/components/dropdown.dart";
import "../views/util/components/increment.dart";
import "../views/util/components/multiselect.dart";
import "../views/util/components/number_input.dart";
import "../views/util/components/ranking.dart";
import "../views/util/components/select.dart";
import "../views/util/components/text_input.dart";
import '../views/util/components/stopwatch.dart';

const String configFilePath = "assets/config/";
const List<int> authorizedTeams = [7461];
const Map componentMap = {
  "number input": NumberInput.create,
  "dropdown": Dropdown.create,
  "checkbox": CheckboxInput.create,
  "increment": Increment.create,
  "select": Select.create,
  "ranking": Ranking.create,
  "text input": TextInput.create,
  "multiselect": Multiselect.create,
  "stopwatch": StopwatchC.create
};

const superviseDatabaseName = "supervise-data";
const stratDatabaseName = "strat-data";
const ordinalRankDatabaseName = "ordinal-ranking";
const preferenceDatabaseName = "preferences";
const frcApiDatabaseName = "frcapi";
const scoutingDataDatabaseName = "data";
const configFileData = "config";

const int minTimestampDifference = 1000; // In milliseconds

const List<String> databaseCollections = [
  superviseDatabaseName,
  stratDatabaseName,
  ordinalRankDatabaseName,
  preferenceDatabaseName,
  frcApiDatabaseName,
  scoutingDataDatabaseName
];

const Map<String, Widget> stratPages = {
  "ordinal": OrdinalRanking(),
  "pit": RobotProfiles(),
  "cardinal": CardinalExport(),
  "settings": StratSettings(),
};
