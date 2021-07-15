import 'package:flutter/material.dart';

class SuperheroCard extends StatelessWidget {
  final String name;
  final String realName;
  final String imageUrl;

  const SuperheroCard(
      {Key? key,
      required this.name,
      required this.realName,
      required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF2C3243),
      height: 70,
      child: Row(
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: 70,
            height: 70,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    realName,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
