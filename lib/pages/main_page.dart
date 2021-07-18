import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/pages/superhero_page.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/widgets/action_button.dart';
import 'package:superheroes/widgets/info_with_button.dart';
import 'package:superheroes/widgets/superhero_card.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MainBloc bloc = MainBloc();

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: bloc,
      child: Scaffold(
        backgroundColor: SuperheroesColors.background,
        body: SafeArea(
          child: MainPageContent(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

class MainPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context);

    return Stack(
      children: [
        MainPageStateWidget(),
        Align(
          alignment: Alignment.bottomCenter,
          child: ActionButton(
            text: 'Next State'.toUpperCase(),
            onTap: () => bloc.nextState(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 16, right: 16),
          child: SearchWidget(),
        )
      ],
    );
  }
}

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    Key? key,
  }) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);

      controller.addListener(() => bloc.updateText(controller.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Colors.white,
      textCapitalization: TextCapitalization.words,
      style: TextStyle(
          fontWeight: FontWeight.w400, fontSize: 20, color: Colors.white),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
          suffix: GestureDetector(
            onTap: () {
              controller.clear();
            },
            child: Icon(
              Icons.clear,
              color: Colors.white,
            ),
          ),
          filled: true,
          fillColor: SuperheroesColors.indigo75,
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white54,
            size: 24,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.white24))),
    );
  }
}

class MainPageStateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context);

    return StreamBuilder<MainPageState>(
        stream: bloc.observeMainPageState(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return SizedBox();
          }

          final MainPageState state = snapshot.data!;

          switch (state) {
            case MainPageState.loading:
              return LoadingIndicator();
            case MainPageState.favorites:
              return SuperheroesList(
                  title: 'Favorite superhero',
                  stream: bloc.observeFavoriteSuperheroes());
            case MainPageState.noFavorites:
              return Center(
                child: InfoWithButton(
                    title: 'No favorites yet',
                    subtitle: 'Search and add',
                    buttonText: 'Search',
                    assetImage: "assets/images/ironman.png",
                    imageHeight: 119,
                    imageWidth: 108,
                    imageTopPadding: 9),
              );
            case MainPageState.minSymbols:
              return Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: EdgeInsets.only(top: 110),
                  child: Text(
                    'Enter at least 3 symbols',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            case MainPageState.searchResults:
              return SuperheroesList(
                  title: 'Search results',
                  stream: bloc.observeSearchedSuperheroes());
            case MainPageState.nothingFound:
              return Center(
                child: InfoWithButton(
                    title: 'Nothing found',
                    subtitle: 'Search for something else',
                    buttonText: 'Search',
                    assetImage: "assets/images/hulk.png",
                    imageHeight: 112,
                    imageWidth: 84,
                    imageTopPadding: 16),
              );
            case MainPageState.loadingError:
              return Center(
                child: InfoWithButton(
                    title: 'Error happened',
                    subtitle: 'Please, try again',
                    buttonText: 'Retry',
                    assetImage: 'assets/images/superman.png',
                    imageHeight: 106,
                    imageWidth: 126,
                    imageTopPadding: 22),
              );
            default:
              return Center(
                child: ActionButton(
                  text: 'Next State'.toUpperCase(),
                  onTap: () => bloc.nextState(),
                ),
              );
          }
        });
  }
}

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

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 110),
        child: CircularProgressIndicator(
          backgroundColor: SuperheroesColors.blue,
          strokeWidth: 4,
        ),
      ),
    );
  }
}
