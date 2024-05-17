import 'dart:math';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_pratice/screens/widgets/widgets.dart';
import 'package:mapbox_pratice/infrastructure/service/services.dart';
import 'package:mapbox_pratice/infrastructure/providers/providers.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);

    return Scaffold(
      body: const _Body(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: getFabBackgroundColor(isDarkMode),
        onPressed: () {
          toggleDarkMode(ref);
        },
        child: Icon(
          getIconDarkMode(isDarkMode),
          color: getColorBlckAndWhite(isDarkMode),
        ),
      ),
    );
  }
}

const LatLng locationOne = LatLng(10.064180, -69.112870);

// coordenadas del perimetro
LatLngBounds mapBounds = LatLngBounds(
  const LatLng(10.098259, -69.125802),
  const LatLng(10.058619, -69.095283),
);

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemonData = ref.watch(dataPokemonProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);

    if (pokemonData.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        FlutterMap(
          options: const MapOptions(
            minZoom: 5,
            maxZoom: 25,
            initialZoom: 13,
            initialCenter: locationOne,
          ),
          children: [
            MapService.getMap(isDarkMode),
            MarkerLayer(
              markers: pokemonMarkers(
                context,
                ref,
                locationOne,
                isDarkMode,
              ),
            ),
          ],
        ),
        const Positioned(
          top: 50,
          left: 20,
          right: 20,
          child: SearchBarWidget(),
        ),
      ],
    );
  }

  List<Marker> pokemonMarkers(BuildContext context, WidgetRef ref,
      LatLng pointLocation, bool isDarkMode) {
    final pokemonData = ref.watch(dataPokemonProvider);
    final listPokemons = pokemonData.pokemon!.results;
    final markerPositions = ref.watch(markerPositionsProvider);

    return listPokemons!.asMap().entries.map((entry) {
      int index = entry.key;
      var pokemon = entry.value;

      return Marker(
        width: 100,
        height: 100,
        point: markerPositions[index],
        child: GestureDetector(
          onTap: () {
            passId(ref, pokemon.pokemonId!);
            bottomSheet(context, isDarkMode, ref);
          },
          child: Column(
            children: [
              CircleAvatar(
                  backgroundImage: NetworkImage(pokemon.imageUrl!), radius: 24),
              Container(
                decoration: BoxDecoration(
                  color: getColorBlckAndWhiteOpasity(isDarkMode),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(
                    pokemon.name!,
                    style: TextStyle(
                      fontSize: 12,
                      color: getColorBlckAndWhite(isDarkMode),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  bottomSheet(BuildContext context, bool isDarkMode, WidgetRef ref) {
    final pokemonData = ref.watch(detailPokemonProvider);

    if (pokemonData.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (pokemonData.pokemon != null) {
      final pokemonImage = pokemonData.pokemon!.imageUrl;
      final pokemonName = pokemonData.pokemon!.name;
      final pokemonId = pokemonData.pokemon!.id;

      return showBottomSheet(
        context: context,
        builder: (context) {
          return GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                color: getFabBackgroundColor(isDarkMode),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (pokemonImage != null)
                      CircleAvatar(
                        backgroundImage: NetworkImage(pokemonImage),
                        radius: 48,
                      ),
                    const SizedBox(height: 8),
                    Column(
                      children: [
                        if (pokemonId != null)
                          Text(
                            'ID: $pokemonId',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.indigo),
                          ),
                        if (pokemonName != null)
                          Text(
                            pokemonName.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else {
      return const Center(
          child: Text('No se pudo cargar la información del Pokémon'));
    }
  }
}

//   bottomSheet(BuildContext context, bool isDarkMode, WidgetRef ref) {
//     final pokemonData = ref.watch(detailPokemonProvider);

//     if (pokemonData.isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (pokemonData.pokemon != null) {
      
//     }

//     final pokemonImage = pokemonData.pokemon!.imageUrl;
//     final pokemonName = pokemonData.pokemon!.name;
//     final pokemonId = pokemonData.pokemon!.id;

//     return showBottomSheet(
//       context: context,
//       builder: (context) {
//         return GestureDetector(
//           onTap: () => Navigator.of(context).pop(),
//           child: Container(
//             height: 400,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: getFabBackgroundColor(isDarkMode),
//               borderRadius:
//                   const BorderRadius.vertical(top: Radius.circular(24)),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   CircleAvatar(
//                     backgroundImage: NetworkImage(pokemonImage!),
//                     radius: 48,
//                   ),
//                   const SizedBox(height: 8),
//                   Column(
//                     children: [
//                       Text(
//                         'ID: $pokemonId',
//                         style: const TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.indigo),
//                       ),
//                       Text(
//                         pokemonName!.toUpperCase(),
//                         style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black54),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
