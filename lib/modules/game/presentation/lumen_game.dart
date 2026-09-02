import 'dart:ui';
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' show Colors;

import '../../physics_engine/domain/entities/photon.dart';
import '../../physics_engine/domain/entities/ray.dart';
import '../../physics_engine/domain/calculations/reflection/reflection_calculator.dart';
import '../data/models/level_model.dart';
import '../data/models/level_repository.dart';

class Obstacle extends PositionComponent {
  Obstacle({required Vector2 position, required Vector2 size}) : super(position: position, size: size) {
    anchor = Anchor.center;
  }

  @override
  void render(Canvas canvas) {
    // Looks like a broken/burnt circuit chip
    final paint = Paint()..color = const Color(0xFF1A1A24);
    final borderPaint = Paint()..color = Colors.red.withOpacity(0.5)..style = PaintingStyle.stroke..strokeWidth = 2;
    final rect = Rect.fromLTWH(-size.x / 2, -size.y / 2, size.x, size.y);
    canvas.drawRect(rect, paint);
    canvas.drawRect(rect, borderPaint);
    
    // Draw chip pins
    final pinPaint = Paint()..color = Colors.grey;
    for(int i = 0; i < size.x / 10; i++) {
       canvas.drawLine(Offset(-size.x/2 + (i*10), -size.y/2), Offset(-size.x/2 + (i*10), -size.y/2 - 5), pinPaint);
       canvas.drawLine(Offset(-size.x/2 + (i*10), size.y/2), Offset(-size.x/2 + (i*10), size.y/2 + 5), pinPaint);
    }
  }
}

class DraggableMirror extends PositionComponent with DragCallbacks {
  DraggableMirror({required Vector2 position}) : super(position: position, size: Vector2(60, 60)) {
    anchor = Anchor.center;
    angle = 3.14159 / 4;
  }

  @override
  void render(Canvas canvas) {
    // Looks like a futuristic routing node
    final paint = Paint()
      ..color = Colors.cyanAccent.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = Colors.cyanAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
      
    canvas.drawCircle(Offset.zero, 30, paint);
    canvas.drawCircle(Offset.zero, 30, strokePaint);
    
    // The reflective core
    final corePaint = Paint()..color = Colors.white..strokeWidth = 4..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(-20, 0), const Offset(20, 0), corePaint);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position += event.localDelta;
  }
}

class LumenGame extends FlameGame with PanDetector {
  final int levelId;
  LumenGame({this.levelId = 1});

  LevelModel? level;
  List<DraggableMirror> mirrors = [];
  List<Obstacle> obstacles = [];
  List<RaySegment> activeRays = [];

  @override
  Color backgroundColor() => const Color(0xFF07070F);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    level = await LevelRepository().loadLevel(levelId);

    // Energy Source (Emitter) visual
    add(CircleComponent(
      radius: 12,
      position: level!.emitter.position.toVector2(),
      anchor: Anchor.center,
      paint: Paint()..color = Colors.amberAccent,
    ));

    // Core Receptor (Target) visual
    add(CircleComponent(
      radius: 18,
      position: level!.target.position.toVector2(),
      anchor: Anchor.center,
      paint: Paint()..color = Colors.purpleAccent..style = PaintingStyle.stroke..strokeWidth = 4,
    ));

    // Generate burnt chips (Obstacles)
    final random = math.Random(levelId);
    for (int i = 0; i < levelId; i++) {
      final obstacle = Obstacle(
        position: Vector2(200.0 + random.nextDouble() * 300, 150.0 + random.nextDouble() * 400),
        size: Vector2(40.0 + random.nextDouble() * 60, 40.0 + random.nextDouble() * 100),
      );
      obstacles.add(obstacle);
      add(obstacle);
    }

    // Spawn routing nodes (Mirrors)
    int mirrorCount = level!.availableMirrors;
    if (mirrorCount == 0 && levelId > 1) mirrorCount = levelId ~/ 2 + 1;
    for (int i = 0; i < mirrorCount; i++) {
      final mirror = DraggableMirror(position: Vector2(400 + (i * 20.0), 100 + (i * 50.0)));
      mirrors.add(mirror);
      add(mirror);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (level == null) return;
    activeRays.clear();

    Vector2 startPos = level!.emitter.position.toVector2();
    Vector2 dir = level!.emitter.direction.toVector2().normalized();
    
    _calculateRays(startPos, dir, 5);
  }

  void _calculateRays(Vector2 startPos, Vector2 dir, int bouncesLeft) {
    if (bouncesLeft <= 0) return;
    Vector2 endPos = startPos + dir * 2000.0;
    double minT = 2000.0;
    Vector2? hitNormal;
    Vector2? hitPoint;

    for (final mirror in mirrors) {
      Vector2 mPos = mirror.position;
      Vector2 mNormal = Vector2(0, -1)..rotate(mirror.angle);
      double denom = dir.dot(mNormal);
      if (denom.abs() > 0.0001) {
        double t = (mPos - startPos).dot(mNormal) / denom;
        if (t > 0 && t < minT) {
          Vector2 intersection = startPos + dir * t;
          double dist = (intersection - mPos).length;
          if (dist <= 25) { // Adjusted for node visual size
            minT = t;
            hitPoint = intersection;
            hitNormal = mNormal;
          }
        }
      }
    }

    for (final obs in obstacles) {
       Vector2 oPos = obs.position;
       Vector2 diff = oPos - startPos;
       double t = diff.dot(dir);
       if (t > 0 && t < minT) {
         Vector2 closest = startPos + dir * t;
         // Check against bounds of the chip
         if (closest.x > oPos.x - obs.size.x/2 && closest.x < oPos.x + obs.size.x/2 &&
             closest.y > oPos.y - obs.size.y/2 && closest.y < oPos.y + obs.size.y/2) {
            minT = t;
            hitPoint = closest;
            hitNormal = null; 
         }
       }
    }

    if (hitPoint != null) {
      activeRays.add(RaySegment(start: startPos, end: hitPoint, photonState: const Photon(wavelength: 632, frequency: 0, intensity: 100, phase: 0, polarization: 0)));
      if (hitNormal != null) {
        Vector2 reflectedDir = dir - hitNormal * 2 * dir.dot(hitNormal);
        _calculateRays(hitPoint + reflectedDir * 1.0, reflectedDir, bouncesLeft - 1);
      }
    } else {
      activeRays.add(RaySegment(start: startPos, end: endPos, photonState: const Photon(wavelength: 632, frequency: 0, intensity: 100, phase: 0, polarization: 0)));
    }
  }

  @override
  void render(Canvas canvas) {
    // Draw background circuit grid
    final gridPaint = Paint()..color = Colors.cyanAccent.withOpacity(0.05)..style = PaintingStyle.stroke..strokeWidth = 1;
    for(double i = 0; i < size.x; i+=50) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.y), gridPaint);
    }
    for(double i = 0; i < size.y; i+=50) {
      canvas.drawLine(Offset(0, i), Offset(size.x, i), gridPaint);
    }
    
    super.render(canvas);
    
    // Draw energy beam
    final paint = Paint()
      ..color = Colors.amberAccent.withOpacity(0.9)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 5); // Glow effect

    for (var ray in activeRays) {
      canvas.drawLine(Offset(ray.start.x, ray.start.y), Offset(ray.end.x, ray.end.y), paint);
    }
  }
}
