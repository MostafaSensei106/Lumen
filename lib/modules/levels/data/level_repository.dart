import '../domain/level_model.dart';

abstract class LevelRepository {
  Future<List<LevelModel>> getLevels();
  Future<LevelModel?> getLevelById(String id);
}
