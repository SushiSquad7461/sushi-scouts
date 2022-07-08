import 'package:sushi_scouts/src/views/util/components/Multiselect.dart';
import 'package:sushi_scouts/src/views/util/components/Ranking.dart';

import '../views/util/components/Checkbox.dart';
import '../views/util/components/Dropdown.dart';
import '../views/util/components/Increment.dart';
import '../views/util/components/NumberInput.dart';

const String CONFIG_FILE_PATH = "assets/config/";
const List<int> AUTHORIZED_TEAMS = [7461];
const Map COMPONENT_MAP = {"number input": NumberInput.create, "dropdown": Dropdown.create, "checkbox": CheckboxInput.create, "increment": Increment.create, "multiselect": Multiselect.create, "ranking": Ranking.create,};