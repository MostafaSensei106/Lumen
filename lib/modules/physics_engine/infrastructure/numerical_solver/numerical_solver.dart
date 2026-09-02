import 'package:flame/components.dart';

import 'dart:math' as math;

/// Represents a Gradient-Index (GRIN) field generator
class MetamaterialField {
  final Vector2 center;
  final double baseIndex;
  final double deltaIndex;
  final double sigma;

  const MetamaterialField({
    required this.center,
    required this.baseIndex,
    required this.deltaIndex,
    required this.sigma,
  });

  /// Calculates n(r)
  double getRefractiveIndex(Vector2 r) {
    double distSq = (r - center).length2;
    return baseIndex + deltaIndex * math.exp(-distSq / (2 * sigma * sigma));
  }

  /// Calculates Gradient n(r)
  Vector2 getGradient(Vector2 r) {
    double distSq = (r - center).length2;
    double expPart = math.exp(-distSq / (2 * sigma * sigma));

    // grad_n = - (r - r_c) / sigma^2 * deltaIndex * exp(...)
    Vector2 diff = r - center;
    double scalar = -(deltaIndex * expPart) / (sigma * sigma);

    return diff * scalar;
  }
}

class SystemState {
  final Vector2 r;
  final Vector2 w;

  SystemState(this.r, this.w);
}

class NumericalSolver {
  /// Solves the differential equation for light in a GRIN medium using RK4.
  /// 1. dr/ds = w / n(r)
  /// 2. dw/ds = grad_n(r)
  static SystemState stepRK4(
    SystemState y,
    double ds,
    MetamaterialField field,
  ) {
    SystemState f(SystemState state) {
      double n = field.getRefractiveIndex(state.r);
      Vector2 dr = state.w / n;
      Vector2 dw = field.getGradient(state.r);
      return SystemState(dr, dw);
    }

    SystemState k1 = f(y);

    SystemState yK2 = SystemState(y.r + k1.r * (ds / 2), y.w + k1.w * (ds / 2));
    SystemState k2 = f(yK2);

    SystemState yK3 = SystemState(y.r + k2.r * (ds / 2), y.w + k2.w * (ds / 2));
    SystemState k3 = f(yK3);

    SystemState yK4 = SystemState(y.r + k3.r * ds, y.w + k3.w * ds);
    SystemState k4 = f(yK4);

    Vector2 nextR = y.r + (k1.r + k2.r * 2 + k3.r * 2 + k4.r) * (ds / 6);
    Vector2 nextW = y.w + (k1.w + k2.w * 2 + k3.w * 2 + k4.w) * (ds / 6);

    return SystemState(nextR, nextW);
  }
}
