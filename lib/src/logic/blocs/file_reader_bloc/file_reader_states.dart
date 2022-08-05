part of 'file_reader_cubit.dart';

abstract class FileReaderStates {}

class FileReaderLoaded extends FileReaderStates {}

class FileReaderLoading extends FileReaderStates {}