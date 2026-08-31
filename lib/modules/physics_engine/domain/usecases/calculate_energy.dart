import '../entities/energy.dart';
import '../entities/wavelength.dart';

/// Use case to compute photon/wave energy from wavelength (E = hc / λ).
class CalculateEnergy {
  static const double planckConstant = 6.62607015e-34; // J*s
  static const double speedOfLight = 299792458; // m/s

  const CalculateEnergy();

  Energy call(Wavelength wavelength) {
    if (wavelength.nanometers <= 0) return const Energy(0);
    final double meters = wavelength.nanometers * 1e-9;
    final double joules = (planckConstant * speedOfLight) / meters;
    return Energy(joules);
  }
}
