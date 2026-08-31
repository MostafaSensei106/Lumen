/// Value object representing photon and ray energy levels.
class Energy {
  final double value;

  const Energy(this.value);

  Energy operator +(Energy other) => Energy(value + other.value);
  Energy operator -(Energy other) => Energy(value - other.value);
}
