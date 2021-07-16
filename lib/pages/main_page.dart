import 'package:flutter/material.dart';
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
        )
      ],
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
              return YourFavouritesWidget();
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
              return SearchResultsWidget();
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

class SearchResultsWidget extends StatelessWidget {
  const SearchResultsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 90,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Search results',
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SuperheroCard(
            realName: 'Bruce Wayne',
            name: 'Batman',
            imageUrl:
                'https://www.superherodb.com/pictures2/portraits/10/100/639.jpg',
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SuperheroPage(name: 'Batman'),
              ));
            },
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SuperheroCard(
              realName: 'Eddie Brock',
              name: 'Venom',
              imageUrl:
                  'https://www.superherodb.com/pictures2/portraits/10/100/22.jpg',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SuperheroPage(name: 'Venom'),
                ));
              }),
        ),
      ],
    );
  }
}

class YourFavouritesWidget extends StatelessWidget {
  const YourFavouritesWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 90,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Your favorites',
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SuperheroCard(
              realName: 'Bruce Wayne',
              name: 'Batman',
              imageUrl:
                  'https://www.superherodb.com/pictures2/portraits/10/100/639.jpg',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SuperheroPage(name: 'Batman'),
                ));
              }),
        ),
        SizedBox(
          height: 8,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SuperheroCard(
              realName: 'Tony Stark',
              name: 'Ironman',
              imageUrl:
                  'https://www.superherodb.com/pictures2/portraits/10/100/85.jpg',
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SuperheroPage(name: 'Ironman'),
                ));
              }),
        ),
      ],
    );
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
