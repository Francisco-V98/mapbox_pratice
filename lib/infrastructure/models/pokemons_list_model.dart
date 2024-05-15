class PokemonsListModel {
  final List<Result>? results;

  PokemonsListModel({
    this.results,
  });

  factory PokemonsListModel.fromJson(Map<String, dynamic> json) =>
      PokemonsListModel(
        results: json["results"] == null
            ? []
            : List<Result>.from(
                json["results"]!.map((x) => Result.fromJson(x))),
      );
}

class Result {
  final String? name;
  final String? url;
  final int? pokemonId;
  final String? imageUrl;

  Result({
    this.name,
    this.url,
    this.pokemonId,
    this.imageUrl,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    final String link = json["url"];
    final String pokemonId = link.split('/').reversed.skip(1).first;
    final int pokemonNumId = int.parse(pokemonId);
    final String imageUrl =
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$pokemonId.png';

    return Result(
      name: json["name"],
      url: json["url"],
      pokemonId: pokemonNumId,
      imageUrl: imageUrl,
    );
  }
}
