import 'package:bloc/bloc.dart';
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
}
