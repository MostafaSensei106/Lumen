import 'package:flame/components.dart';

enum OpticalType {
  flatMirror,
  prism,
  beamSplitter,
  polarizer,
  grinBender,
  targetSensor,
}

abstract class OpticalElement {
  String get id;
  Vector2 get position;
  OpticalType get type;

  IntersectionResult? checkIntersection(
    Vector2 rayOrigin,
    Vector2 rayDirection,
  );
}

class IntersectionResult {
  final Vector2 point;
  final Vector2 normal;
  final double distance;

  IntersectionResult({
    required this.point,
    required this.normal,
    required this.distance,
  });
}
