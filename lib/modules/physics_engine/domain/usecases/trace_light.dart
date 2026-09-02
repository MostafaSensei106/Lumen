import '../entities/ray.dart';
import '../entities/optical_element.dart';

/// Use case to trace light rays through optical elements in the scene.
class TraceLight {
  const TraceLight();

  List<RaySegment> call({
    required RaySegment sourceRay,
    required List<OpticalElement> elements,
    int maxBounces = 10,
  }) {
    // Ray tracing calculation implementation will be injected here
    return [sourceRay];
  }
}
