import 'package:flutter/material.dart';
import 'package:superheroes/blocs/main_bloc.dart';

class SuperheroCard extends StatelessWidget {
  final SuperheroInfo superheroInfo;
  final VoidCallback onTap;

  const SuperheroCard({
    Key? key,
    required this.superheroInfo,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Color(0xFF2C3243),
        height: 70,
        child: Row(
          children: [
            Image.network(
              superheroInfo.imageUrl,
              fit: BoxFit.cover,
              width: 70,
              height: 70,
            ),
            SizedBox(
              width: 12,
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  superheroInfo.name.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  superheroInfo.realName,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
