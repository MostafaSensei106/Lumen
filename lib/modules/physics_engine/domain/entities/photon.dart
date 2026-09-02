/// Represents a single photon or packet of light energy in the optical physics domain.
class Photon {
  final double wavelength; // in nanometers (nm)
  final double energy; // in electron-volts (eV) or Joules (J)
  final double phase; // wave phase in radians

  const Photon({
    required this.wavelength,
    required this.energy,
    this.phase = 0.0,
  });
}
