import 'package:flutter/material.dart';
import 'package:superheroes/resources/superheroes_colors.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      backgroundColor: SuperheroesColors.blue,
      strokeWidth: 4,
    );
  }
}
