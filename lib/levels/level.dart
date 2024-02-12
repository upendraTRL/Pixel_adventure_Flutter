import 'dart:async';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/actors/player.dart';

class Level extends World {
  Level({required this.levelName, required this.player});
  final String levelName;
  final Player player;
  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    // Only runs once
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));

    add(level);

    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    for (final spawnPoints in spawnPointsLayer!.objects) {
      switch (spawnPoints.class_) {
        case 'Player':
          player.position = Vector2(spawnPoints.x, spawnPoints.y);
          add(player);
          break;
        default:
      }
    }

    return super.onLoad();
  }
}
