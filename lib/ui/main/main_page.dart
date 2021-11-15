import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:superheroes/blocs/main_bloc/main_cubit.dart';
import 'package:superheroes/resources/main/page_status.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/ui/main/widgets/search.dart';
import 'package:superheroes/ui/main/widgets/superhero_list.dart';
import 'package:superheroes/ui/widgets/action_button.dart';
import 'package:superheroes/ui/widgets/info_with_button.dart';
import 'package:superheroes/ui/widgets/loading_indicator.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SuperheroesColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            MainPageStateWidget(),
            Padding(
              padding: const EdgeInsets.only(top: 12.0, left: 16, right: 16),
              child: SearchWidget(),
            )
          ],
        ),
      ),
    );
  }
}

class MainPageStateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MainCubit bloc = Get.find<MainCubit>();

    return BlocBuilder<MainCubit, MainState>(builder: (context, state) {
      switch (state.status) {
        case PageStatus.loading:
          return Align(
            alignment: Alignment.topCenter,
            child: Padding(
                padding: EdgeInsets.only(top: 110), child: LoadingIndicator()),
          );
        case PageStatus.favorites:
          return Stack(
            children: [
              // SuperheroesList(
              //   title: 'Your favorites',
              //   stream: bloc.observeFavoriteSuperheroes(),
              // ),
              // Align(
              //     alignment: Alignment.bottomCenter,
              //     child:
              //         ActionButton(text: 'Remove', onTap: bloc.removeFavorite))
            ],
          );
        case PageStatus.noFavorites:
          return Stack(
            children: [
              Center(
                child: InfoWithButton(
                    title: 'No favorites yet',
                    subtitle: 'Search and add',
                    buttonText: 'Search',
                    assetImage: "assets/images/ironman.png",
                    imageHeight: 119,
                    imageWidth: 108,
                    imageTopPadding: 9),
              ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: ActionButton(
              //     text: 'Remove',
              //     onTap: bloc.removeFavorite,
              //   ),
              // )
            ],
          );
        case PageStatus.minSymbols:
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
        case PageStatus.searchResults:
          return SuperheroesList(
            title: 'Search results',
            superheroes: state.superhero,
          );
        case PageStatus.nothingFound:
          return Stack(children: [
            Center(
              child: InfoWithButton(
                  title: 'Nothing found',
                  subtitle: 'Search for something else',
                  buttonText: 'Search',
                  assetImage: "assets/images/hulk.png",
                  imageHeight: 112,
                  imageWidth: 84,
                  imageTopPadding: 16),
            )
          ]);
        case PageStatus.loadingError:
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
