part of 'main_cubit.dart';

class MainState {
  final PageStatus status;

  MainState({this.status = PageStatus.loading});

  MainState copyWith({
    PageStatus? status,
  }) {
    return MainState(
      status: status ?? this.status,
    );
  }
}
