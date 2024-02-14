import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

//Enum - Plays important role in using/setting(automatically) variables
//rather typing separatly
enum PlayerState { idle, run }

// Creates a component with an empty animation which can be set later
class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler {
  Player({
    position,
    this.character = 'Ninja Frog',
  }) : super(position: position);

  String character;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runAnimation;
  final double stepTime = 0.05; // 50millisec == 20fps

  double horizontalMovement = 0;
  double moveSpeed = 130;
  Vector2 velocity = Vector2.zero();

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  @override
  //dt stands for delta-times ???
  void update(double dt) {
    _updatePlayerState();
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;

    kP(LogicalKeyboardKey value) => keysPressed.contains(value);
    final isLeftPressed =
        kP(LogicalKeyboardKey.keyA) || kP(LogicalKeyboardKey.arrowLeft);
    final isRightPressed =
        kP(LogicalKeyboardKey.keyD) || kP(LogicalKeyboardKey.arrowRight);

    horizontalMovement += isLeftPressed ? -1 : 0;
    horizontalMovement += isRightPressed ? 1 : 0;

    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', 11);
    runAnimation = _spriteAnimation('Run', 12);

    //List of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.run: runAnimation,
    };

    // Set current animation
    current = PlayerState.idle;
    // current = PlayerState.run;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Main Characters/$character/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    //Flipping character w.r.t running direction
    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    //Setting running animation if character is moving
    if (velocity.x > 0 || velocity.x < 0) playerState = PlayerState.run;

    current = playerState;
  }

  void _updatePlayerMovement(double dt) {
    velocity.x =
        horizontalMovement * moveSpeed; //Responsible for left & right movement.
    position.x += velocity.x *
        dt; //Here, 'dt' helps to set same speed irrespective to fps.
  }
}
