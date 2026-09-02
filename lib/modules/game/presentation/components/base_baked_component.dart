import 'dart:ui' as ui;

import 'package:flame/components.dart';

abstract class BaseBakedComponent extends PositionComponent {
  ui.Picture? _cachedPicture;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    bake();
  }

  void bake() {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    paintBakedPath(canvas, size.toSize());
    _cachedPicture?.dispose();
    _cachedPicture = recorder.endRecording();
  }

  void paintBakedPath(ui.Canvas canvas, ui.Size size);

  @override
  void render(ui.Canvas canvas) {
    if (_cachedPicture != null) {
      canvas.drawPicture(_cachedPicture!);
    }
  }

  @override
  void onRemove() {
    _cachedPicture?.dispose();
    super.onRemove();
  }
}
