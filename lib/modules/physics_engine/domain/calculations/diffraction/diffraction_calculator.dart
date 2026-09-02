import 'dart:math' as math;

class DiffractionCalculator {
  /// Calculates the angular intensity distribution for a single slit.
  /// I(theta) = I0 * (sin(beta) / beta)^2
  /// where beta = (pi * a / lambda) * sin(theta)
  static double getIntensityAtAngle({
    required double initialIntensity,
    required double slitWidth, // 'a' in nm
    required double wavelength, // 'lambda' in nm
    required double thetaRad, // angle from center
  }) {
    if (thetaRad == 0) return initialIntensity; // Center maximum

    double beta = (math.pi * slitWidth / wavelength) * math.sin(thetaRad);
    
    if (beta == 0) return initialIntensity;

    double sinBeta = math.sin(beta);
    double ratio = sinBeta / beta;
    
    return initialIntensity * ratio * ratio;
  }

  /// Calculates the angle (in radians) of the first diffraction minimum.
  static double getFirstMinimumAngle({
    required double slitWidth, // 'a' in nm
    required double wavelength, // 'lambda' in nm
  }) {
    // sin(theta) = lambda / a
    if (wavelength > slitWidth) {
      return math.pi / 2; // Maximum diffraction spreading
    }
    return math.asin(wavelength / slitWidth);
  }
}
