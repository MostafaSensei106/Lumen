class Photon {
  final double wavelength;    // e.g. 650.0 nm
  final double frequency;     // in Hz: f = c / lambda
  final double intensity;     // Current intensity I
  final double phase;         // Current phase in radians [0, 2*pi]
  final double polarization;  // Polarization angle in radians [0, pi]

  const Photon({
    required this.wavelength,
    required this.frequency,
    required this.intensity,
    required this.phase,
    required this.polarization,
  });
}
