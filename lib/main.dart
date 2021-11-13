import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:superheroes/injection.dart';
import 'package:superheroes/ui/main/main_page.dart';

void main() async {
  await dotenv.load();

  DependenciesInitializer.initializeDependencies();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.openSansTextTheme((Theme.of(context).textTheme)),
      ),
      home: MainPage(),
    );
  }
}
