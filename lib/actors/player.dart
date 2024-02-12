import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

//Enum - Plays important role in using/setting(automatically) variables
//rather typing separatly
enum PlayerState { idle, run }

enum PlayerDirection { left, right, none }

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

  PlayerDirection playerDirection = PlayerDirection.none;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  @override
  //dt stands for delta-times ???
  void update(double dt) {
    _updatePlayerMovement(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    kP(LogicalKeyboardKey value) => keysPressed.contains(value);
    final isLeftPressed =
        kP(LogicalKeyboardKey.keyA) || kP(LogicalKeyboardKey.arrowLeft);
    final isRightPressed =
        kP(LogicalKeyboardKey.keyD) || kP(LogicalKeyboardKey.arrowRight);

    if (isLeftPressed && isRightPressed) {
      playerDirection = PlayerDirection.none;
    } else if (isLeftPressed) {
      playerDirection = PlayerDirection.left;
    } else if (isRightPressed) {
      playerDirection = PlayerDirection.right;
    } else {
      playerDirection = PlayerDirection.none;
    }

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

  void _updatePlayerMovement(double dt) {
    double dirX = 0.0;
    switch (playerDirection) {
      case PlayerDirection.left:
        if (isFacingRight) {
          flipHorizontallyAroundCenter(); //Flip character facing to left
          isFacingRight = false;
        }
        current = PlayerState.run;
        dirX -= moveSpeed; // -ve to move towards left
        break;
      case PlayerDirection.right:
        if (!isFacingRight) {
          flipHorizontallyAroundCenter(); //Flip character facing to right
          isFacingRight = true;
        }
        current = PlayerState.run;
        dirX += moveSpeed; // +ve to move towards right
        break;
      case PlayerDirection.none:
        current = PlayerState.idle;
        break;
      default:
    }

    velocity = Vector2(dirX, 0.0);
    position +=
        velocity * dt; //Here, 'dt' helps to set same speed irrespective to fps.
  }
}
