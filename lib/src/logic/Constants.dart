import "package:sushi_scouts/src/views/util/components/multiselect.dart";
import "package:sushi_scouts/src/views/util/components/select.dart";
import "package:sushi_scouts/src/views/util/components/ranking.dart";
import "package:sushi_scouts/src/views/util/components/text_input.dart";

import "../views/util/components/checkbox.dart";
import "../views/util/components/dropdown.dart";
import "../views/util/components/increment.dart";
import "../views/util/components/number_input.dart";

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
  "multiselect": Multiselect.create
};

const superviseDatabaseName = "supervise-data";
