import 'dart:math' as math;
import 'package:flame/components.dart';
import '../../entities/photon.dart';
import '../../entities/ray.dart';

class PolarizationCalculator {
  static const double noiseFloor = 0.01;

  /// Applies Malus's Law to an incident ray passing through a polarizer.
  /// Returns null if the transmitted intensity is below the noise floor.
  static RaySegment? applyPolarizer({
    required RaySegment incidentRay,
    required Vector2 intersectionPoint,
    required double filterAngle,
  }) {
    double rayAngle = incidentRay.photonState.polarization;
    double deltaTheta = (rayAngle - filterAngle).abs();
    
    double cosDelta = math.cos(deltaTheta);
    double transmittedIntensity = incidentRay.photonState.intensity * cosDelta * cosDelta;

    if (transmittedIntensity < noiseFloor) {
      return null;
    }

    Vector2 d = (incidentRay.end - incidentRay.start).normalized();
    Vector2 newEnd = intersectionPoint + d * 10000.0;

    return RaySegment(
      start: intersectionPoint,
      end: newEnd,
      photonState: Photon(
        wavelength: incidentRay.photonState.wavelength,
        frequency: incidentRay.photonState.frequency,
        intensity: transmittedIntensity,
        phase: incidentRay.photonState.phase,
        polarization: filterAngle, // Polarization matches the filter after passing through
      ),
    );
  }
}
