import 'dart:convert';
import 'package:flutter/services.dart';
import 'level_model.dart';

class LevelRepository {
  Future<LevelModel> loadLevel(int levelId) async {
    // For now, hardcode to level_01.json
    final String response = await rootBundle.loadString('assets/levels/level_01.json');
    final data = await json.decode(response);
    return LevelModel.fromJson(data);
  }
}
