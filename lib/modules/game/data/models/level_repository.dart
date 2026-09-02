import 'dart:convert';

import 'package:flutter/services.dart';

import 'level_model.dart';

class LevelRepository {
  Future<LevelModel> loadLevel(int levelId) async {
    final String fileName = 'level_${levelId.toString().padLeft(2, '0')}.json';
    try {
      final String response = await rootBundle.loadString(
        'assets/levels/$fileName',
      );
      final data = await json.decode(response);
      return LevelModel.fromJson(data);
    } catch (e) {
      // Fallback to level_01 if the file is not found
      final String response = await rootBundle.loadString(
        'assets/levels/level_01.json',
      );
      final data = await json.decode(response);
      return LevelModel.fromJson(data);
    }
  }
}
