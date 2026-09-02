abstract class AudioService {
  Future<void> initialize();
  Future<void> playBgm(String assetPath, {double volume = 1.0});
  Future<void> stopBgm();
  Future<void> playSfx(String assetPath, {double volume = 1.0});

  // Laser hum changes dynamically based on frequency (f) and intensity (I)
  Future<void> updateLaserHum({
    required double frequencyHz,
    required double intensity,
  });
  Future<void> stopLaserHum();
}
