import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:superheroes/blocs/main_bloc/models/superhero_info.dart';

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
            Container(
              width: 70,
              height: 70,
              color: Colors.white24,
              child: CachedNetworkImage(
                imageUrl: superheroInfo.imageUrl,
                fit: BoxFit.cover,
                width: 70,
                height: 70,
                errorWidget: (context, _, __) => Center(
                  child: Image.asset(
                    "assets/images/unknown.png",
                    height: 62,
                    width: 20,
                  ),
                ),
                progressIndicatorBuilder: (context, _, downloadProgress) =>
                    Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    value: downloadProgress.progress,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF00BCD4)),
                  ),
                ),
              ),
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
