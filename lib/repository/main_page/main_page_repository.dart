import 'package:superheroes/blocs/main_bloc/models/superhero_info.dart';

abstract class MainPageRepository {
  Future<List<SuperheroInfo>> getSuperheroes(String text);
}
