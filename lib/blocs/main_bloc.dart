import 'dart:async';

import 'package:rxdart/rxdart.dart';

class MainBloc {
  final BehaviorSubject<MainPageState> stateSubject = BehaviorSubject();
  final favoriteSuperheroesSubject =
      BehaviorSubject<List<SuperheroInfo>>.seeded(SuperheroInfo.mocked);
  final searchedSuperheroesSubject = BehaviorSubject<List<SuperheroInfo>>();
  final currentTextSubject = BehaviorSubject<String>.seeded('');
  static const minSymbols = 3;

  Stream<MainPageState> observeMainPageState() => stateSubject;
  StreamSubscription? textSubscription;
  StreamSubscription? searchSubscription;

  MainBloc() {
    stateSubject.add(MainPageState.noFavorites);
    searchSubscription?.cancel();

    textSubscription =
        Rx.combineLatest2<String, List<SuperheroInfo>, MainPageStateInfo>(
            currentTextSubject
                .distinct()
                .debounceTime(Duration(milliseconds: 500)),
            favoriteSuperheroesSubject,
            (searchedText, favorites) => MainPageStateInfo(
                searchedText: searchedText,
                haveFavorites: favorites.isNotEmpty)).listen((value) {
      if (value.searchedText.isEmpty) {
        if (value.haveFavorites) {
          stateSubject.add(MainPageState.favorites);
        } else {
          stateSubject.add(MainPageState.noFavorites);
        }
      } else if (value.searchedText.length < minSymbols) {
        stateSubject.add(MainPageState.minSymbols);
      } else {
        searchForSuperheroes(value.searchedText);
      }
    });
  }
  Stream<List<SuperheroInfo>> observeFavoriteSuperheroes() =>
      favoriteSuperheroesSubject;
  Stream<List<SuperheroInfo>> observeSearchedSuperheroes() =>
      searchedSuperheroesSubject;

  void searchForSuperheroes(final String text) {
    stateSubject.add(MainPageState.loading);

    searchSubscription = search(text).asStream().listen((searchResults) {
      if (searchResults.isEmpty) {
        stateSubject.add(MainPageState.nothingFound);
      } else {
        searchedSuperheroesSubject.add(searchResults);
        stateSubject.add(MainPageState.searchResults);
      }
    }, onError: (error) {
      stateSubject.add(MainPageState.loadingError);
    });
  }

  Future<List<SuperheroInfo>> search(final String text) async {
    await Future.delayed(Duration(seconds: 1));

    return SuperheroInfo.mocked
        .where((superhero) =>
            superhero.name.toLowerCase().contains(text.toLowerCase()))
        .toList();
  }

  void updateText(final String? text) {
    currentTextSubject.add(text ?? '');
  }

  void nextState() {
    final currentState = stateSubject.value;
    final nextState = MainPageState.values[
        (MainPageState.values.indexOf(currentState) + 1) %
            MainPageState.values.length];
    stateSubject.add(nextState);
  }

  void dispose() {
    stateSubject.close();
    favoriteSuperheroesSubject.close();
    searchedSuperheroesSubject.close();
    currentTextSubject.close();

    textSubscription?.cancel();
    searchSubscription?.cancel();
  }
}

enum MainPageState {
  noFavorites,
  minSymbols,
  loading,
  favorites,
  searchResults,
  nothingFound,
  loadingError,
}

class SuperheroInfo {
  final String name;
  final String realName;
  final String imageUrl;

  const SuperheroInfo(
      {required this.name, required this.realName, required this.imageUrl});

  @override
  String toString() {
    return 'SuperheroInfo{name: $name, realName: $realName, imageUrl: $imageUrl}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuperheroInfo &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          realName == other.realName &&
          imageUrl == other.imageUrl;

  @override
  int get hashCode => name.hashCode ^ realName.hashCode ^ imageUrl.hashCode;

  static const mocked = [
    SuperheroInfo(
        name: 'Batman',
        realName: 'Bruce Wayne',
        imageUrl:
            'https://www.superherodb.com/pictures2/portraits/10/100/639.jpg'),
    SuperheroInfo(
        name: 'Ironman',
        realName: 'Tony Stark',
        imageUrl:
            'https://www.superherodb.com/pictures2/portraits/10/100/85.jpg'),
    SuperheroInfo(
        name: 'Venom',
        realName: 'Eddie Brock',
        imageUrl:
            'https://www.superherodb.com/pictures2/portraits/10/100/22.jpg'),
  ];
}

class MainPageStateInfo {
  final String searchedText;
  final bool haveFavorites;

  MainPageStateInfo({required this.searchedText, required this.haveFavorites});

  @override
  String toString() {
    return 'MainPageStateInfo{searchedText: $searchedText, haveFavorites: $haveFavorites}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MainPageStateInfo &&
          runtimeType == other.runtimeType &&
          searchedText == other.searchedText &&
          haveFavorites == other.haveFavorites;

  @override
  int get hashCode => searchedText.hashCode ^ haveFavorites.hashCode;
}
