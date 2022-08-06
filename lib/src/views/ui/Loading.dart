import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sushi_scouts/SushiScoutingLib/logic/helpers/routing_helper.dart';
import 'package:sushi_scouts/src/logic/blocs/file_reader_bloc/file_reader_cubit.dart';
import 'package:sushi_scouts/src/logic/blocs/theme_bloc/theme_cubit.dart';
import 'package:sushi_scouts/src/views/ui/login.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  LoadingState createState() => LoadingState();
}

class LoadingState extends State<Loading> {

  Future<void> loadConfig() async{
    await BlocProvider.of<ThemeCubit>(context).setMode();
    await BlocProvider.of<FileReaderCubit>(context).readConfig();
    RouteHelper.pushAndRemoveUntilToScreen(ctx: context, screen: const Login());
  }

  @override
  Widget build(BuildContext context) {
    loadConfig();
    return const Scaffold(body: Center(child: Text("im loading")));
  }
}