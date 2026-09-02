import 'dart:math' as math;

class Energy {
  final double joules;
  const Energy(this.joules);
}

class EnergyAttenuation {
  static const double referenceWavelength = 400.0; // nm
  static const double referenceAttenuation = 0.001; // Base attenuation factor mu_0

  /// Beer-Lambert Law: I(s) = I0 * e^(-mu * s)
  static double calculateAttenuatedIntensity({
    required double initialIntensity,
    required double pathLength,
    required double wavelength,
  }) {
    double mu = calculateAttenuationCoefficient(wavelength);
    return initialIntensity * math.exp(-mu * pathLength);
  }

  /// Rayleigh scattering approximation: mu(lambda) = mu_0 * (lambda_0 / lambda)^4
  static double calculateAttenuationCoefficient(double wavelength) {
    double ratio = referenceWavelength / wavelength;
    return referenceAttenuation * math.pow(ratio, 4);
  }
}
