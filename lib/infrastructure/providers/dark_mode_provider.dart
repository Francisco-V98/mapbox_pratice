import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isDarkModeProvider = StateProvider<bool>((ref) {
  return false;
});

bool useDarkModeHelper(WidgetRef ref) {
  return ref.watch(isDarkModeProvider);
}

void toggleDarkMode(WidgetRef ref) {
  ref.read(isDarkModeProvider.notifier).update((state) => !state);
}

Color getFabBackgroundColor(bool isDarkMode) {
  return isDarkMode ? const Color.fromARGB(255, 22, 22, 22) : Colors.white;
}

IconData getIconDarkMode(bool isDarkMode) {
  return isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined;
}

Color getColorBlckAndWhite(bool isDarkMode) {
  return isDarkMode ? Colors.white : Colors.black;
}

Color getColorBlckAndWhiteOpasity(bool isDarkMode) {
  return isDarkMode ? Colors.white24 : Colors.black26;
}
