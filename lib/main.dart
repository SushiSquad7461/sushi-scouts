// Flutter imports:
import 'dart:ui';

import "package:flutter/material.dart";

// Package imports:
import "package:firebase_core/firebase_core.dart";
import 'package:flutter/services.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import "package:get/get.dart";

// Project imports:
import '../firebase_options.dart';
import "provider.dart";
import "src/logic/blocs/theme_bloc/theme_cubit.dart";
import "src/logic/helpers/size/screen_size.dart";
import "src/views/ui/loading.dart";
import "src/views/util/themes.dart";
import "src/views/ui/error_popup.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // PlatformDispatcher.instance.onError = (exception, stackTrace) {
  //   ErrorPopup.onError(exception, stackTrace);
  //   return true;
  // };

  runApp(const Wrapper());
}

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Sushi Scouts",
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeMode.system,
      home: const Scaffold(
        resizeToAvoidBottomInset: false,
        body: SushiScouts(),
      ),
    );
  }
}

class SushiScouts extends StatefulWidget {
  const SushiScouts({Key? key}) : super(key: key);
  static GlobalKey<NavigatorState>? navigatorKey;

  @override
  State<SushiScouts> createState() => _SushiScoutsState();
}

class _SushiScoutsState extends State<SushiScouts> {
  @override
  void initState() {
    super.initState();
    SushiScouts.navigatorKey = GlobalKey<NavigatorState>();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.setHeight(MediaQuery.of(context).size.height);
    ScreenSize.setWidth(MediaQuery.of(context).size.width);

    return MultiBlocProvider(
      providers: providers,
      child: GestureDetector(onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      }, child: BlocBuilder<ThemeCubit, ThemeStates>(builder: (context, state) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: state is DarkMode
                ? Colors.white
                : Colors.black, // Color for Android
            statusBarBrightness: state is DarkMode
                ? Brightness.dark
                : Brightness.light // Dark == white status bar -- for IOS.
            ));

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: state is DarkMode ? Themes.dark : Themes.light,
          home: const Loading(),
          navigatorKey: SushiScouts.navigatorKey,
        );
      })),
    );
  }
}
