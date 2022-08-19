import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstore/localstore.dart';
import 'package:sushi_scouts/src/logic/blocs/login_bloc/login_cubit.dart';
import 'package:sushi_scouts/src/logic/data/config_file_reader.dart';
import 'package:sushi_scouts/src/logic/helpers/routing_helper.dart';
import 'package:sushi_scouts/src/views/ui/app_choser.dart';
import 'package:sushi_scouts/src/views/ui/sushi_scouts/qr_screen.dart';

class Logout extends StatelessWidget {

  const Logout({Key? key}) : super(key: key);

  void deleteData() {
    var db = Localstore.instance;
    var reader = ConfigFileReader.instance;
    for (var screen in reader.getScoutingMethods()) {
      db.collection("data").doc("backup$screen").delete();
      db.collection("data").doc("current$screen").delete();
    }
  }

  void logOut(context) {
    deleteData();
    BlocProvider.of<LoginCubit>(context).logOut();
    RouteHelper.pushAndRemoveUntilToScreen(-1,0,ctx: context, screen: const AppChooser());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Warning: data will be deleted"),
      content: const Text("Please go to the qrcode screen to send your data to the scouting admin."),
      actions: [
        TextButton(
          onPressed: () => RouteHelper.pushAndRemoveUntilToScreen(0, 0, ctx: context, screen: QRScreen()),
          child: const Text("Send Data")
        ),
        TextButton(
          onPressed: () => logOut(context),
          child: const Text("OK")
        )
      ]
    );
  }
}