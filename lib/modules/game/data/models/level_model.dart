import 'package:flame/components.dart';

class Vector2Model {
  final double x;
  final double y;
  Vector2Model(this.x, this.y);

  factory Vector2Model.fromJson(Map<String, dynamic> json) {
    return Vector2Model(
      (json['x'] as num).toDouble(),
      (json['y'] as num).toDouble(),
    );
  }

  Vector2 toVector2() => Vector2(x, y);
}

class EmitterModel {
  final Vector2Model position;
  final Vector2Model direction;
  final double wavelength;
  final double intensity;

  EmitterModel({
    required this.position,
    required this.direction,
    required this.wavelength,
    required this.intensity,
  });

  factory EmitterModel.fromJson(Map<String, dynamic> json) {
    return EmitterModel(
      position: Vector2Model.fromJson(json['position']),
      direction: Vector2Model.fromJson(json['direction']),
      wavelength: (json['wavelength'] as num).toDouble(),
      intensity: (json['intensity'] as num).toDouble(),
    );
  }
}

class TargetModel {
  final Vector2Model position;
  final double minIntensity;

  TargetModel({
    required this.position,
    required this.minIntensity,
  });

  factory TargetModel.fromJson(Map<String, dynamic> json) {
    return TargetModel(
      position: Vector2Model.fromJson(json['position']),
      minIntensity: (json['min_intensity'] as num).toDouble(),
    );
  }
}

class LevelModel {
  final int levelId;
  final String circuitName;
  final EmitterModel emitter;
  final TargetModel target;
  final int availableMirrors;

  LevelModel({
    required this.levelId,
    required this.circuitName,
    required this.emitter,
    required this.target,
    required this.availableMirrors,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      levelId: json['level_id'] as int,
      circuitName: json['circuit_name'] as String,
      emitter: EmitterModel.fromJson(json['emitter']),
      target: TargetModel.fromJson(json['target']),
      availableMirrors: (json['available_inventory']['flat_mirrors'] as int?) ?? 0,
    );
  }
}
