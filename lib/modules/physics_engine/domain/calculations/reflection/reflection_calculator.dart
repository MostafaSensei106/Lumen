import 'package:flame/components.dart';

import '../../entities/photon.dart';
import '../../entities/ray.dart';

class ReflectionCalculator {
  /// Calculates the reflected ray given an incident ray, the intersection point,
  /// the normal of the surface, and the reflectance of the mirror [0.0, 1.0].
  static RaySegment calculateReflection({
    required RaySegment incidentRay,
    required Vector2 intersectionPoint,
    required Vector2 surfaceNormal,
    required double reflectance,
  }) {
    Vector2 d = (incidentRay.end - incidentRay.start).normalized();
    Vector2 n = surfaceNormal.normalized();

    // Ensure normal is facing the incident ray
    if (d.dot(n) > 0) {
      n = -n;
    }

    // r = d - 2(d . n)n
    Vector2 r = d - n * (2 * d.dot(n));

    // Calculate new intensity
    double newIntensity = incidentRay.photonState.intensity * reflectance;

    // The new ray starts at the intersection point and goes infinitely in the reflected direction.
    // For practical purposes in a game, we scale it by a large number or the screen bounds.
    // We will set the end point to an arbitrary long distance.
    Vector2 newEnd = intersectionPoint + r * 10000.0;

    return RaySegment(
      start: intersectionPoint,
      end: newEnd,
      photonState: Photon(
        wavelength: incidentRay.photonState.wavelength,
        frequency: incidentRay.photonState.frequency,
        intensity: newIntensity,
        phase: incidentRay.photonState.phase,
        polarization: incidentRay.photonState.polarization,
      ),
    );
  }
}
