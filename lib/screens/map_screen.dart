import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_pratice/infrastructure/providers/data_pokemon_provider.dart';
import 'package:mapbox_pratice/infrastructure/providers/datail_pokemon_provider.dart';
import 'package:mapbox_pratice/infrastructure/service/map_service.dart';

import '../infrastructure/providers/dark_mode_provider.dart';
import 'widgets/search_bar_widget.dart';

const LatLng location_one = LatLng(10.064180, -69.112870);
const LatLng location_two = LatLng(10.074226, -69.118257);
const LatLng location_three = LatLng(10.076927, -69.131499);
const LatLng location_four = LatLng(10.090980, -69.124409);

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
        backgroundColor:
            isDarkMode ? const Color.fromARGB(255, 22, 22, 22) : Colors.white,
        onPressed: () {
          ref.read(isDarkModeProvider.notifier).update((state) => !state);
        },
        child: Icon(
          isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemonData = ref.watch(dataPokemonProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);

    // final List<LatLng> routePoints = [
    //   location_one,
    //   location_two,
    //   location_three,
    //   location_four,
    // ];

    if (pokemonData.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final pokemonImage = pokemonData.pokemon!.results?.first.imageUrl;
    final pokemonName = pokemonData.pokemon!.results?.first.name;

    return Stack(
      children: [
        FlutterMap(
          options: const MapOptions(
            minZoom: 5,
            maxZoom: 25,
            initialZoom: 18,
            initialCenter: location_one,
          ),
          children: [
            MapService.getMap(isDarkMode),
            MarkerLayer(
              markers: [
                markerLocation(location_one, pokemonImage, pokemonName,
                    isDarkMode, context, ref),
                // markerLocation(location_two, pokemonImage, pokemonName,
                //     isDarkMode, context),
                // markerLocation(location_three, pokemonImage, pokemonName,
                //     isDarkMode, context),
                // markerLocation(location_four, pokemonImage, pokemonName,
                //     isDarkMode, context),
              ],
            ),
          ],
        ),
        const Positioned(
            top: 50, left: 20, right: 20, child: SearchBarWidget()),
      ],
    );
  }

  markerLocation(LatLng pointLocation, String? image, String? name,
      bool isDarkMode, BuildContext context, WidgetRef ref) {
        
    final pokemonData = ref.watch(dataPokemonProvider);
    final pokemonDetailData = ref.watch(detailPokemonProvider);
    final pokemonId = pokemonData.pokemon!.results?.first.pokemonId;


    return Marker(
      width: 100,
      height: 100,
      point: pointLocation,
      child: GestureDetector(
        onTap: () { 
          bottomSheet(context, isDarkMode, ref, pokemonId);
        },
        child: Column(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(image!), radius: 24),
            Container(
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.white24 : Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Text(
                  name!,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bottomSheet(
      BuildContext context, bool isDarkMode, WidgetRef ref, String? id) {
    final pokemonData = ref.watch(dataPokemonProvider);

    final pokemonImage = pokemonData.pokemon!.results?.first.imageUrl;
    final pokemonName = pokemonData.pokemon!.results?.first.name;
    final pokemonId = pokemonData.pokemon!.results?.first.pokemonId;

    return showBottomSheet(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            height: 400,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color.fromARGB(255, 23, 23, 23)
                  : const Color.fromARGB(255, 255, 255, 255),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(pokemonImage!),
                    radius: 48,
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: [
                      Text(
                        'ID: $pokemonId',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo),
                      ),
                      Text(
                        pokemonName!.toUpperCase(),
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
  }
}
