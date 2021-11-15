part of 'main_cubit.dart';

class MainState {
  final PageStatus status;
  final List<SuperheroInfo> superhero;

  MainState({
    this.status = PageStatus.loading,
    this.superhero = const [],
  });

  MainState copyWith({
    PageStatus? status,
    List<SuperheroInfo>? superhero,
  }) {
    return MainState(
      status: status ?? this.status,
      superhero: superhero ?? this.superhero,
    );
  }
}
