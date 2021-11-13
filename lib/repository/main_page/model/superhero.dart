import 'package:json_annotation/json_annotation.dart';
import 'package:superheroes/repository/main_page/model/biography.dart';
import 'package:superheroes/repository/main_page/model/powerstats.dart';
import 'package:superheroes/repository/main_page/model/server_image.dart';

part 'superhero.g.dart';

@JsonSerializable()
class Superhero {
  final String name;
  final String id;
  final Powerstats powerstats;
  final Biography biography;
  final ServerImage image;

  Superhero(this.name, this.biography, this.image, this.id, this.powerstats);

  factory Superhero.fromJson(final Map<String, dynamic> json) =>
      _$SuperheroFromJson(json);
  Map<String, dynamic> toJson() => _$SuperheroToJson(this);
}
