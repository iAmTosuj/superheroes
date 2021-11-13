import 'package:dio/dio.dart';
import 'package:superheroes/blocs/main_bloc/models/superhero_info.dart';
import 'package:superheroes/repository/main_page/main_page_repository.dart';
import 'package:superheroes/repository/main_page/model/superhero.dart';

class MainPageRepositoryImpl implements MainPageRepository {
  final Dio client;

  MainPageRepositoryImpl({
    required this.client,
  });

  @override
  Future<List<SuperheroInfo>> getSuperheroes(String text) async {
    await Future.delayed(Duration(seconds: 1));

    final response = await client.get('/search/$text');

    final List<Superhero> results = response.data['results']
        .map<Superhero>((data) => Superhero.fromJson(data));

    final List<SuperheroInfo> found = results.map((rewSuperhero) {
      return SuperheroInfo(
          name: rewSuperhero.name,
          realName: rewSuperhero.biography.fullName,
          imageUrl: rewSuperhero.image.url);
    }).toList();

    return found;

    return SuperheroInfo.mocked
        .where((superhero) =>
            superhero.name.toLowerCase().contains(text.toLowerCase()))
        .toList();
  }
}
