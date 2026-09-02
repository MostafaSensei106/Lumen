import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' show Colors;
import '../../physics_engine/domain/entities/photon.dart';
import '../../physics_engine/domain/entities/ray.dart';
import '../../physics_engine/domain/calculations/reflection/reflection_calculator.dart';
import '../data/models/level_model.dart';
import '../data/models/level_repository.dart';

class DraggableMirror extends PositionComponent with DragCallbacks {
  DraggableMirror({required Vector2 position}) : super(position: position, size: Vector2(80, 10)) {
    anchor = Anchor.center;
    // Set a 45 degree angle for testing reflection to the target
    angle = 3.14159 / 4; 
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = Colors.cyanAccent..strokeWidth = 4..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, size.y / 2), Offset(size.x, size.y / 2), paint);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position += event.localDelta;
  }
}

class LumenGame extends FlameGame with PanDetector {
  LevelModel? level;
  DraggableMirror? mirror;
  List<RaySegment> activeRays = [];

  @override
  Color backgroundColor() => const Color(0xFF0D0D12);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    level = await LevelRepository().loadLevel(1);
    
    // Add Emitter visual
    add(CircleComponent(
      radius: 10,
      position: level!.emitter.position.toVector2(),
      anchor: Anchor.center,
      paint: Paint()..color = Colors.redAccent,
    ));

    // Add Target visual
    add(CircleComponent(
      radius: 15,
      position: level!.target.position.toVector2(),
      anchor: Anchor.center,
      paint: Paint()..color = Colors.greenAccent..style = PaintingStyle.stroke..strokeWidth = 3,
    ));

    // Add exactly one mirror from inventory (spawned in the center for the user to drag)
    if (level!.availableMirrors > 0) {
      mirror = DraggableMirror(position: Vector2(400, 300));
      add(mirror!);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (level == null) return;

    activeRays.clear();
    
    // 1. Initial Ray from Emitter
    Vector2 startPos = level!.emitter.position.toVector2();
    Vector2 dir = level!.emitter.direction.toVector2().normalized();
    
    // We shoot a long ray
    Vector2 endPos = startPos + dir * 2000.0;
    
    RaySegment currentRay = RaySegment(
      start: startPos,
      end: endPos,
      photonState: const Photon(
        wavelength: 632.0,
        frequency: 0,
        intensity: 100,
        phase: 0,
        polarization: 0,
      )
    );

    // 2. Check collision with mirror
    if (mirror != null) {
      // Very basic line-to-line bounding box intersection for the mirror
      // Mirror is at `mirror.position` with width 80 and angle 45 deg
      // Let's check if the ray crosses the mirror's infinite line for a quick test
      
      Vector2 mPos = mirror!.position;
      Vector2 mNormal = Vector2(0, -1)..rotate(mirror!.angle); // normal of the mirror
      
      // Ray line: p = startPos + t * dir
      // Plane line: (p - mPos) . mNormal = 0
      // (startPos + t*dir - mPos) . mNormal = 0
      // t * (dir . mNormal) = (mPos - startPos) . mNormal
      double denom = dir.dot(mNormal);
      if (denom.abs() > 0.0001) {
        double t = (mPos - startPos).dot(mNormal) / denom;
        if (t > 0 && t < 2000) {
          Vector2 intersection = startPos + dir * t;
          
          // Check if intersection is within the 80px width of the mirror
          double distFromCenter = (intersection - mPos).length;
          if (distFromCenter <= 40) {
            // Hit!
            currentRay = RaySegment(
              start: currentRay.start,
              end: intersection,
              photonState: currentRay.photonState,
            );
            activeRays.add(currentRay);
            
            // Calculate Reflection using our engine
            RaySegment reflectedRay = ReflectionCalculator.calculateReflection(
              incidentRay: currentRay,
              intersectionPoint: intersection,
              surfaceNormal: mNormal,
              reflectance: 0.9,
            );
            activeRays.add(reflectedRay);
            return;
          }
        }
      }
    }
    
    activeRays.add(currentRay);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    final paint = Paint()
      ..color = Colors.redAccent.withValues(alpha: 0.8)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
      
    for (var ray in activeRays) {
      canvas.drawLine(
        Offset(ray.start.x, ray.start.y),
        Offset(ray.end.x, ray.end.y),
        paint,
      );
    }
  }
}
