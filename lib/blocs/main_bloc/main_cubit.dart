import 'package:bloc/bloc.dart';
import 'package:superheroes/blocs/main_bloc/models/superhero_info.dart';
import 'package:superheroes/repository/main_page/main_page_repository.dart';
import 'package:superheroes/resources/main/page_status.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  final MainPageRepository mainRepository;

  MainCubit({
    required this.mainRepository,
  }) : super(MainState());

  static const minSymbols = 3;

  void nextState() {
    final currentState = state.status;

    final nextState = PageStatus.values[
        (PageStatus.values.indexOf(currentState) + 1) %
            PageStatus.values.length];

    emit(state.copyWith(status: nextState));
  }

  void searchSuperheroes(String text) {
    if (text.length < minSymbols) {
      emit(state.copyWith(status: PageStatus.minSymbols));
      return;
    }

    emit(state.copyWith(status: PageStatus.loading));

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
}
