import 'package:equatable/equatable.dart';

class SuperheroInfo extends Equatable {
  final String name;
  final String realName;
  final String imageUrl;

  const SuperheroInfo({
    required this.name,
    required this.realName,
    required this.imageUrl,
  });

  @override
  String toString() {
    return 'SuperheroInfo{name: $name, realName: $realName, imageUrl: $imageUrl}';
  }

  static const mocked = [
    SuperheroInfo(
        name: 'Batman',
        realName: 'Bruce Wayne',
        imageUrl:
            'https://www.superherodb.com/pictures2/portraits/10/100/639.jpg'),
    SuperheroInfo(
        name: 'Ironman',
        realName: 'Tony Stark',
        imageUrl:
            'https://www.superherodb.com/pictures2/portraits/10/100/85.jpg'),
    SuperheroInfo(
        name: 'Venom',
        realName: 'Eddie Brock',
        imageUrl:
            'https://www.superherodb.com/pictures2/portraits/10/100/22.jpg'),
  ];

  @override
  List<Object?> get props => [
        name,
        realName,
        imageUrl,
      ];
}
