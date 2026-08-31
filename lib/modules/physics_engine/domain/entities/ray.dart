/// Represents a light ray with origin, direction vector, intensity, and spectral properties.
class Ray {
  final double originX;
  final double originY;
  final double directionX;
  final double directionY;
  final double intensity;
  final double wavelength;

  const Ray({
    required this.originX,
    required this.originY,
    required this.directionX,
    required this.directionY,
    this.intensity = 1.0,
    required this.wavelength,
  });
}
