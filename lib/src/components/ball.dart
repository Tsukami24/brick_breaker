import 'dart:math';

import 'package:flame/collisions.dart'; 
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flame/effects.dart';

import '../brick_breaker.dart';
import 'brick.dart';
import 'bat.dart'; 
import 'play_area.dart'; 

int rng() {
  Random rand = Random();
  return rand.nextInt(5);
}

class Ball extends CircleComponent
    with CollisionCallbacks, HasGameReference<BrickBreaker> {

  Ball({
    required this.velocity,
    required super.position,
    required double radius,
    required this.difficultyModifier,
  }) : super(
            radius: radius,
            anchor: Anchor.center,
            paint: Paint()
              ..color = const Color(0xff1e6091)
              ..style = PaintingStyle.fill,
            children: [CircleHitbox()]); 

  final Vector2 velocity;
  final double difficultyModifier;

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is PlayArea) {
      if (intersectionPoints.first.y <= 0) {
        velocity.y = -velocity.y;
      } else if (intersectionPoints.first.x <= 0) {
        velocity.x = -velocity.x;
      } else if (intersectionPoints.first.x >= game.width) {
        velocity.x = -velocity.x;
      } else if (intersectionPoints.first.y >= game.height) {
        //death
        add(RemoveEffect(
          delay: 0.35,
          onComplete: () {
            game.playState = PlayState.gameOver;
            FlameAudio.play('lose.mp3');
          },
        ));
      }
    } else if (other is Bat) {
      FlameAudio.play('ball.mp3');
      velocity.y = -velocity.y;
      velocity.x = velocity.x +
          (position.x - other.position.x) / other.size.x * game.width * 0.3;
    } else if (other is Brick) {
      if (position.y < other.position.x - other.size.y / 2) {
        velocity.y = -velocity.y;
      } else if (position.y > other.position.x + other.size.y / 2) {
        velocity.y = -velocity.y;
      } else if (position.x < other.position.x) {
        velocity.x = -velocity.x;
      } else if (position.x > other.position.x) {
        velocity.x = -velocity.x;
      }
      switch (rng()) {
        case 1:
          FlameAudio.play('bata_pecah.mp3');
          break;
        case 2:
          FlameAudio.play('bata_pecah.mp3');
          break;
        case 3:
          FlameAudio.play('bata_pecah.mp3');
          break;
        case 4:
          FlameAudio.play('bata_pecah.mp3');
          break;
        default:
          FlameAudio.play('bata_pecah.mp3');
      }

      velocity.setFrom(velocity * difficultyModifier);
    }
  } 
}
