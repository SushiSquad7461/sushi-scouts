import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sushi_scouts/src/logic/blocs/theme_bloc/theme_cubit.dart';

import '../../data/config_file_reader.dart';

part 'file_reader_states.dart';

class FileReaderCubit extends Cubit<FileReaderStates>{
  FileReaderCubit() : super(FileReaderLoading());
  Future<void> readConfig() async{
    emit(FileReaderLoading());
    var reader = ConfigFileReader.instance;
    await reader.readInitalConfig();
    emit(FileReaderLoaded());
  }
}