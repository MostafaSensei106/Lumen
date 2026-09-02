import 'dart:math' as math;

class InterferenceCalculator {
  /// Calculates the total intensity of two intersecting rays of the same wavelength.
  static double calculateInterferenceIntensity({
    required double wavelength,
    required double pathLength1,
    required double pathLength2,
    required double phase1,
    required double phase2,
    required double intensity1,
    required double intensity2,
  }) {
    double deltaX = (pathLength1 - pathLength2).abs();
    
    // Delta phi = ((2 * pi / lambda) * deltaX + (phi1 - phi2)) mod 2*pi
    double deltaPhi = ((2 * math.pi / wavelength) * deltaX + (phase1 - phase2)) % (2 * math.pi);
    if (deltaPhi < 0) {
      deltaPhi += 2 * math.pi;
    }

    // I_total = I1 + I2 + 2 * sqrt(I1 * I2) * cos(deltaPhi)
    double totalIntensity = intensity1 + intensity2 + 
        2 * math.sqrt(intensity1 * intensity2) * math.cos(deltaPhi);

    return totalIntensity;
  }
}
