import "package:sushi_scouts/src/views/util/components/multiselect.dart";
import "package:sushi_scouts/src/views/util/components/select.dart";
import "package:sushi_scouts/src/views/util/components/ranking.dart";
import "package:sushi_scouts/src/views/util/components/text_input.dart";

import "../views/util/components/checkbox.dart";
import "../views/util/components/dropdown.dart";
import "../views/util/components/increment.dart";
import "../views/util/components/number_input.dart";

const String CONFIG_FILE_PATH = "assets/config/";
const List<int> AUTHORIZED_TEAMS = [7461];
const Map COMPONENT_MAP = {
  "number input": NumberInput.create,
  "dropdown": Dropdown.create,
  "checkbox": CheckboxInput.create,
  "increment": Increment.create,
  "select": Select.create,
  "ranking": Ranking.create,
  "text input": TextInput.create,
  "multiselect": Multiselect.create
};

const SUPERVISE_DATABASE_NAME = "supervise-data";
