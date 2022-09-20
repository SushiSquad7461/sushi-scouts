import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:get/get.dart";
import "package:sushi_scouts/provider.dart";
import "package:sushi_scouts/src/logic/blocs/theme_bloc/theme_cubit.dart";
import "package:sushi_scouts/src/logic/helpers/size/screen_size.dart";
import "package:sushi_scouts/src/views/ui/loading.dart";
import "package:sushi_scouts/src/views/util/themes.dart";
import "firebase_options.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const Wrapper());
}

class Themes {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    primaryColorDark: Colors.black,
    scaffoldBackgroundColor: Colors.white,
  );

  static ThemeData dark = ThemeData(
    primaryColor: Colors.black,
    primaryColorDark: Colors.white,
    scaffoldBackgroundColor: Colors.black,
  );
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
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: state is DarkMode ? darkTheme : lightTheme,
          home: const Loading(),
          navigatorKey: SushiScouts.navigatorKey,
        );
      })),
    );
  }
}
