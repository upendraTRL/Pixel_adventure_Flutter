import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/actors/player.dart';

class Level extends World {
  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    // Only runs once
    level = await TiledComponent.load('Level-01.tmx', Vector2.all(16));

    add(level);
    add(
      Player(
        character: 'Ninja Frog',
      ),
    );

    return super.onLoad();
  }
}
