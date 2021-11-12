import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:superheroes/blocs/main_bloc/models/superhero_info.dart';
import 'package:superheroes/model/superhero.dart';
import 'package:superheroes/resources/main/page_status.dart';

class MainBloc {
  final BehaviorSubject<MainPageStatus> stateSubject = BehaviorSubject();
  final favoriteSuperheroesSubject =
      BehaviorSubject<List<SuperheroInfo>>.seeded(SuperheroInfo.mocked);
  final searchedSuperheroesSubject = BehaviorSubject<List<SuperheroInfo>>();
  final currentTextSubject = BehaviorSubject<String>.seeded('');
  static const minSymbols = 3;

  http.Client? client;

  Stream<MainPageStatus> observeMainPageState() => stateSubject;
  StreamSubscription? textSubscription;
  StreamSubscription? searchSubscription;

  MainBloc({this.client}) {
    stateSubject.add(MainPageStatus.noFavorites);
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
          stateSubject.add(MainPageStatus.favorites);
        } else {
          stateSubject.add(MainPageStatus.noFavorites);
        }
      } else if (value.searchedText.length < minSymbols) {
        stateSubject.add(MainPageStatus.minSymbols);
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
    stateSubject.add(MainPageStatus.loading);

    searchSubscription = search(text).asStream().listen((searchResults) {
      if (searchResults.isEmpty) {
        stateSubject.add(MainPageStatus.nothingFound);
      } else {
        searchedSuperheroesSubject.add(searchResults);
        stateSubject.add(MainPageStatus.searchResults);
      }
    }, onError: (error) {
      stateSubject.add(MainPageStatus.loadingError);
    });
  }

  Future<List<SuperheroInfo>> search(final String text) async {
    await Future.delayed(Duration(seconds: 1));
    final token = dotenv.env['SUPERHERO_TOKEN'];
    final response = await (client ??= http.Client())
        .get(Uri.parse('https://superheroapi.com/api/$token/search/$text'));
    final decoded = json.decode(response.body);
    print(decoded['response']);
    if (decoded['response'] == 'success') {
      final List<Superhero> results =
          decoded['results'].map<Superhero>((data) => Superhero.fromJson(data));

      final List<SuperheroInfo> found = results.map((rewSuperhero) {
        return SuperheroInfo(
            name: rewSuperhero.name,
            realName: rewSuperhero.biography.fullName,
            imageUrl: rewSuperhero.image.url);
      }).toList();
      print(123);
      return found;
    }
    return SuperheroInfo.mocked
        .where((superhero) =>
            superhero.name.toLowerCase().contains(text.toLowerCase()))
        .toList();
  }

  void updateText(final String? text) {
    currentTextSubject.add(text ?? '');
  }

  void removeFavorite() {
    final List<SuperheroInfo> currentFavorites =
        favoriteSuperheroesSubject.value;
    if (currentFavorites.isEmpty) {
      favoriteSuperheroesSubject.add(SuperheroInfo.mocked);
      return;
    }

    favoriteSuperheroesSubject
        .add(currentFavorites.sublist(0, currentFavorites.length - 1));
  }

  void nextState() {
    final currentState = stateSubject.value;
    final nextState = MainPageStatus.values[
        (MainPageStatus.values.indexOf(currentState) + 1) %
            MainPageStatus.values.length];
    stateSubject.add(nextState);
  }

  void dispose() {
    stateSubject.close();
    favoriteSuperheroesSubject.close();
    searchedSuperheroesSubject.close();
    currentTextSubject.close();

    textSubscription?.cancel();
    searchSubscription?.cancel();
    client?.close();
  }
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
