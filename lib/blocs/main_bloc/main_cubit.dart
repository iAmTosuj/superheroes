import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:superheroes/blocs/main_bloc/models/superhero_info.dart';
import 'package:superheroes/repository/main_page/main_page_repository.dart';
import 'package:superheroes/resources/main/page_status.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  final MainPageRepository mainRepository;
  StreamSubscription? searchSubscription;

  MainCubit({
    required this.mainRepository,
  }) : super(MainState(status: PageStatus.noFavorites));

  static const int minSymbols = 3;
  static const String searchDebounceTag = 'search_debounce_tag';

  void nextState() {
    final currentState = state.status;

    final nextState = PageStatus.values[
        (PageStatus.values.indexOf(currentState) + 1) %
            PageStatus.values.length];

    emit(state.copyWith(status: nextState));
  }

  void searchSuperheroes(String? text) {
    searchSubscription?.cancel();
    EasyDebounce.cancel(searchDebounceTag);

    if (text != null && text.isEmpty) {
      emit(state.copyWith(
          status: PageStatus.noFavorites, haveSearchText: false));
      return;
    }

    emit(state.copyWith(haveSearchText: true));

    if (text!.length < minSymbols) {
      emit(state.copyWith(status: PageStatus.minSymbols));
      return;
    }

    emit(state.copyWith(status: PageStatus.loading));

    EasyDebounce.debounce(
      searchDebounceTag,
      Duration(milliseconds: 500),
      () => debounceSearch(text),
    );
  }

  void debounceSearch(String text) {
    searchSubscription =
        fetchSuperheroes(text).asStream().listen((searchResults) {
      if (searchResults.isEmpty) {
        emit(state.copyWith(status: PageStatus.nothingFound));
      } else {
        emit(state.copyWith(
            status: PageStatus.searchResults, superhero: searchResults));
      }
    }, onError: (error) {
      emit(state.copyWith(status: PageStatus.loadingError));
    });
  }

  Future<List<SuperheroInfo>> fetchSuperheroes(String text) async {
    return await mainRepository.getSuperheroes(text)
      ..toList();
  }

  void dispose() {
    searchSubscription?.cancel();
  }
}
