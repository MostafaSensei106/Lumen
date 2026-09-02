import 'dart:math' as math;
import 'package:flame/components.dart';
import '../../entities/ray.dart';

class RefractionResult {
  final RaySegment? refractedRay;
  final RaySegment? totallyInternallyReflectedRay;
  
  RefractionResult({
    this.refractedRay,
    this.totallyInternallyReflectedRay,
  });
}

class RefractionCalculator {
  /// Cauchy's Dispersion Equation
  /// n(lambda) = A + B / lambda^2
  /// lambda is in nm
  static double calculateRefractiveIndex(double lambda, double a, double b) {
    return a + b / (lambda * lambda);
  }

  static RefractionResult calculateRefraction({
    required RaySegment incidentRay,
    required Vector2 intersectionPoint,
    required Vector2 surfaceNormal,
    required double n1,
    required double n2,
  }) {
    Vector2 d = (incidentRay.end - incidentRay.start).normalized();
    Vector2 n = surfaceNormal.normalized();
    
    if (d.dot(n) > 0) {
      n = -n;
    }

    double eta = n1 / n2;
    double cosThetaI = -n.dot(d);
    double k = 1 - eta * eta * (1 - cosThetaI * cosThetaI);

    if (k < 0) {
      // Total Internal Reflection (TIR)
      Vector2 vOut = d - n * (2 * d.dot(n));
      Vector2 newEnd = intersectionPoint + vOut * 10000.0;
      
      return RefractionResult(
        totallyInternallyReflectedRay: RaySegment(
          start: intersectionPoint,
          end: newEnd,
          photonState: incidentRay.photonState, // Intensity might change slightly in reality, but typically TIR is 100%
        ),
      );
    } else {
      // Refraction
      Vector2 t = d * eta + n * (eta * cosThetaI - math.sqrt(k));
      Vector2 newEnd = intersectionPoint + t * 10000.0;
      
      return RefractionResult(
        refractedRay: RaySegment(
          start: intersectionPoint,
          end: newEnd,
          photonState: incidentRay.photonState,
        ),
      );
    }
  }
}
