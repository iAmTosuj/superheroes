part of 'main_cubit.dart';

class MainState {
  final PageStatus status;
  final List<SuperheroInfo> superhero;
  final bool haveSearchText;

  MainState({
    required this.status,
    this.haveSearchText = false,
    this.superhero = const [],
  });

  MainState copyWith({
    PageStatus? status,
    List<SuperheroInfo>? superhero,
    bool? haveSearchText,
  }) {
    return MainState(
      status: status ?? this.status,
      superhero: superhero ?? this.superhero,
      haveSearchText: haveSearchText ?? this.haveSearchText,
    );
  }
}
