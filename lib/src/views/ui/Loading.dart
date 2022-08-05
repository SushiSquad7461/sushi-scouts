import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc/src/bloc_provider.dart';
import 'package:localstore/localstore.dart';
import 'package:sushi_scouts/src/logic/blocs/file_reader_bloc/file_reader_cubit.dart';
import 'package:sushi_scouts/src/logic/blocs/theme_bloc/theme_cubit.dart';
import 'package:sushi_scouts/src/views/ui/login.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  LoadingState createState() => LoadingState();
}

class LoadingState extends State<Loading> {
  
  @override
  void initState() {
    super.initState();
    BlocProvider.of<FileReaderCubit>(context).readConfig();
    BlocProvider.of<ThemeCubit>(context).setMode(); 
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<FileReaderCubit, FileReaderStates>(
        builder: (context, state) {
          if (state is FileReaderLoaded) {
            return const Login();
          } else {
            return const Center(child: Text("im loading"),);
          }
        },
      )
    );
  }
}