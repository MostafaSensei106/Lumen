/// Value object representing optical wavelength and spectrum classification.
class Wavelength {
  final double nanometers;

  const Wavelength(this.nanometers);

  bool get isVisible => nanometers >= 380 && nanometers <= 750;
  bool get isInfrared => nanometers > 750;
  bool get isUltraviolet => nanometers < 380;
}
