import 'package:flutter/material.dart';
import 'package:superheroes/blocs/main_bloc/models/superhero_info.dart';
import 'package:superheroes/ui/superhero/superhero_page.dart';
import 'package:superheroes/ui/widgets/superhero_card.dart';

class SuperheroesList extends StatelessWidget {
  final String title;
  final Stream<List<SuperheroInfo>> stream;

  const SuperheroesList({Key? key, required this.title, required this.stream})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<SuperheroInfo>>(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return SizedBox.shrink();
          }

          final List<SuperheroInfo> superheroes = snapshot.data!;

          return ListView.separated(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: superheroes.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 90, bottom: 12),
                  child: Text(
                    title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800),
                  ),
                );
              }

              final SuperheroInfo item = superheroes[index - 1];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SuperheroCard(
                    superheroInfo: item,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SuperheroPage(name: item.name),
                      ));
                    }),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 8,
              );
            },
          );
        });
  }
}
