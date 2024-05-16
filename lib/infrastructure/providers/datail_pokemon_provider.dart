import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_pratice/infrastructure/models/models.dart';
import 'package:mapbox_pratice/infrastructure/service/services.dart';


final idProvider = StateProvider<int>((ref) {
  return 4;
});

final detailPokemonProvider =
    StateNotifierProvider<DetailPokemonNotifier, DetailPokemonState>((ref) {
      final pokemonId = ref.watch(idProvider);
  return DetailPokemonNotifier(pokemonId: pokemonId);
});

class DetailPokemonNotifier extends StateNotifier<DetailPokemonState> {
  final int pokemonId;

  DetailPokemonNotifier({required this.pokemonId}) : super(DetailPokemonState()) {
    getDetailPokemon();
  }

  Future<void> getDetailPokemon() async {
    state = state.copyWith(isLoading: true);

    try {
      final detailPokemon = await PokemonService().getPokemonInformation(pokemonId.toString());
      state = state.copyWith(pokemon: detailPokemon, isLoading: false);
    } catch (error) {
      ('Error al obtener imagen de perro aleatoria: $error');
      state = state.copyWith(isLoading: true);
    }
  }
}

class DetailPokemonState {
  final PokemonModel? pokemon;
  final bool isLoading;

  DetailPokemonState({
    this.pokemon,
    this.isLoading = false,
  });

  DetailPokemonState copyWith({
    PokemonModel? pokemon,
    bool? isLoading,
  }) =>
      DetailPokemonState(
        pokemon: pokemon ?? this.pokemon,
        isLoading: isLoading ?? this.isLoading,
      );
}
