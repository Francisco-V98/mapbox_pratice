import 'package:dio/dio.dart';
import '../models/pokemon_model.dart';
import '../models/pokemons_list_model.dart';

class PokemonService {

  var dio = Dio();
  final String baseUrl = 'https://pokeapi.co/api/v2/';

  Future<PokemonsListModel> getPokemonsList() async {
    try {
      final String url = '$baseUrl/pokemon';
      Response response = await dio.get(url);
      if (response.statusCode == 200) {

        return PokemonsListModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load list pokemon: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load list pokemon: $e');
    }
  }

    Future<PokemonModel> getPokemonInformation(String id) async {
    final String pokemonId = id;
    try {
      final String url = '$baseUrl/pokemon-species/$pokemonId';
      Response response = await dio.get(url);
      if (response.statusCode == 200) {

        return PokemonModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load pokemon details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load pokemon details: $e');
    }
  }

}
