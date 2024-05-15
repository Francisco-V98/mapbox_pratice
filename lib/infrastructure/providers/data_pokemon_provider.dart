// import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_pratice/infrastructure/service/pokemon_service.dart';
import '../models/pokemons_list_model.dart';

// provider para obtener el pokemon
final dataPokemonProvider =
    StateNotifierProvider<DataPokemonNotifier, DataPokemonState>((ref) {
  return DataPokemonNotifier();
});

class DataPokemonNotifier extends StateNotifier<DataPokemonState> {
  DataPokemonNotifier() : super(DataPokemonState()) {
    getDataPokemon();
  }

  Future<void> getDataPokemon() async {
    state = state.copyWith(isLoading: true);

    try {
      final getpokemon = await PokemonService().getPokemonsList();
      state = state.copyWith(pokemon: getpokemon, isLoading: false);
    } catch (error) {
      ('Error al obtener imagen de perro aleatoria: $error');
      state = state.copyWith(isLoading: true);
    }
  }
}

class DataPokemonState {
  final PokemonsListModel? pokemon;
  final bool isLoading;
  final bool isDarkMode;

  DataPokemonState({
    this.pokemon,
    this.isLoading = false,
    this.isDarkMode = false,
  });

  DataPokemonState copyWith({
    PokemonsListModel? pokemon,
    bool? isLoading,
    bool? isDarkMode,
  }) =>
      DataPokemonState(
        pokemon: pokemon ?? this.pokemon,
        isLoading: isLoading ?? this.isLoading,
        isDarkMode: isDarkMode ?? this.isDarkMode,
      );
}
