import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sushi_scouts/src/logic/blocs/file_reader_bloc/file_reader_cubit.dart';
import 'package:sushi_scouts/src/logic/blocs/scouting_method_bloc/scouting_method_cubit.dart';
import 'package:sushi_scouts/src/logic/blocs/theme_bloc/theme_cubit.dart';

List<BlocProvider> providers = [
  BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()),
  BlocProvider<FileReaderCubit>(create: (context) => FileReaderCubit()),
  BlocProvider<ScoutingMethodCubit>(create: (context) => ScoutingMethodCubit())
];