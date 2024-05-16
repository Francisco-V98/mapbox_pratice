import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapbox_pratice/infrastructure/providers/providers.dart';

class SearchBarWidget extends ConsumerWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    return isDarkMode
        ? Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 22, 22, 22),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.white),
                  hintText: 'Buscar',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.white38,),
                  suffixIcon: Icon(Icons.mic),
                  suffixIconColor: Colors.white54),
                  
            ),
          )
        : Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const TextField(
              decoration: InputDecoration(
                  hintText: 'Buscar',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Icon(Icons.mic),
                  suffixIconColor: Colors.black45),
            ),
          );
  }
}