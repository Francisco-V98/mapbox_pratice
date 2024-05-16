import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_pratice/screens/widgets/widgets.dart';
import 'package:mapbox_pratice/infrastructure/service/services.dart';
import 'package:mapbox_pratice/infrastructure/providers/providers.dart';


const LatLng locationOne = LatLng(10.064180, -69.112870);

LatLngBounds mapBounds = LatLngBounds(
  const LatLng(10.076927, -69.131499),
  const LatLng(10.09098, -69.124409),
);

const int idselected = 10;

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

    if (pokemonData.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final pokemonImage = pokemonData.pokemon!.results?[idselected].imageUrl;
    final pokemonsList = pokemonData.pokemon?.results;
    final pokemonName = pokemonData.pokemon!.results?[idselected].name;

    return Stack(
      children: [
        FlutterMap(
          options: const MapOptions(
            minZoom: 5,
            maxZoom: 25,
            initialZoom: 18,
            initialCenter: locationOne,
          ),
          children: [
            MapService.getMap(isDarkMode),
            MarkerLayer(
              markers: [
                markerLocation(
                  locationOne,
                  pokemonImage,
                  pokemonName,
                  isDarkMode,
                  context,
                  ref,
                ),
              ],
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

  markerLocation(LatLng pointLocation, String? image, String? name,
      bool isDarkMode, BuildContext context, WidgetRef ref) {
    final pokemonData = ref.watch(dataPokemonProvider);
    final pokemonId = pokemonData.pokemon!.results?[idselected].pokemonId;
    

    return Marker(
      width: 100,
      height: 100,
      point: pointLocation,
      child: GestureDetector(
        onTap: () {
          ref.read(idProvider.notifier).update((state) => pokemonId!);
          bottomSheet(context, isDarkMode, ref);
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
                    //todo helper de esto para sacar el dark mode
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

  bottomSheet(BuildContext context, bool isDarkMode, WidgetRef ref) {
    final pokemonData = ref.watch(detailPokemonProvider);

    if (pokemonData.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
// todo que no sean !
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
