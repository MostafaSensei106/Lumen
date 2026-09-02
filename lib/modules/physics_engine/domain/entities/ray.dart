import 'package:flame/components.dart';

import 'photon.dart';

class RaySegment {
  final Vector2 start;
  final Vector2 end;
  final Photon photonState;

  const RaySegment({
    required this.start,
    required this.end,
    required this.photonState,
  });
}
