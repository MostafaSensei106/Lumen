/// Base abstract class for all optical interactive elements in the simulation.
abstract class OpticalElement {
  final String id;
  final double posX;
  final double posY;
  final double rotation;

  const OpticalElement({
    required this.id,
    required this.posX,
    required this.posY,
    this.rotation = 0.0,
  });
}
