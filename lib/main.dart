import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:superheroes/blocs/main_bloc/main_cubit.dart';
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
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        textTheme: GoogleFonts.openSansTextTheme((Theme.of(context).textTheme)),
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => Get.find<MainCubit>()),
        ],
        child: MainPage(),
      ),
    );
  }
}
