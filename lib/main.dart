import 'package:dd_study_22_ui/ui/navigation/app_navigator.dart';
import 'package:dd_study_22_ui/ui/roots/loader.dart';
import 'package:flutter/material.dart';
import 'data/services/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DB.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      navigatorKey: AppNavigator.key,
      onGenerateRoute: (settings) =>
          AppNavigator.onGeneratedRoutes(settings, context),
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        bottomAppBarColor: Colors.deepPurple,
        canvasColor: Colors.deepPurple[100],
        iconTheme: const IconThemeData(color: Colors.deepPurple),
      ),
      home: LoaderWidget.create(),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
