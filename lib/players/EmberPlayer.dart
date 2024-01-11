import 'package:flame/components.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ugh2/games/UghGame.dart';

import '../elementos/Gota.dart';

class EmberPlayer extends SpriteAnimationComponent with HasGameRef<UghGame> {
  late int iTipo = -1;
  late EmberPlayerBody parentBody; // Reference to EmberPlayerBody

  EmberPlayer({
    required super.position,
    required this.iTipo,
    required super.size,
    required this.parentBody,
  }) : super(anchor: Anchor.center);

  @override
  void onLoad() {
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('reading.png'),
      SpriteAnimationData.sequenced(
        amount: 15,
        amountPerRow: 5,
        textureSize: Vector2(60,88),
        stepTime: 0.12,
      ),
    );

  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Gota) {
      // Check for collision with Gota
      parentBody.removeEmberPlayer(); // Call method to remove EmberPlayer
    }
  }
}

class EmberPlayerBody extends BodyComponent with KeyboardHandler{
  final Vector2 velocidad = Vector2.zero();
  final double aceleracion = 200;
  final Set<LogicalKeyboardKey> magiaSubZero={LogicalKeyboardKey.arrowDown, LogicalKeyboardKey.keyA};
  final Set<LogicalKeyboardKey> magiaScorpio={LogicalKeyboardKey.arrowUp, LogicalKeyboardKey.keyK};
  late int iTipo=-1;
  late Vector2 tamano;
  int horizontalDirection = 0;
  int verticalDirection = 0;
  static const  int I_PLAYER_SUBZERO=0;
  static const  int I_PLAYER_SCORPIO=1;
  static const  int I_PLAYER_TANYA=2;
  final _defaultColor = Colors.red;
  late double jumpSpeed=0.0;
  late EmberPlayer emberPlayer;
  final UghGame gameRef;

  EmberPlayerBody({
    Vector2? initialPosition,
    required this.iTipo,
    required this.tamano,
    required this.gameRef,
  })
      : super(
    fixtureDefs: [
      FixtureDef(
        CircleShape()..radius = tamano.x/2,
        restitution: 0.8,
        friction: 0.4,
      ),
    ],
    bodyDef: BodyDef(
      angularDamping: 0.8,
      position: initialPosition ?? Vector2.zero(),
      type: BodyType.dynamic,
      //fixed rotation hace que no gire el personaje
    ),
  );

  // Method to remove EmberPlayer from its parent (EmberPlayerBody)
  void removeEmberPlayer() {
    emberPlayer.removeFromParent();
  }


  @override
  Future<void> onLoad() {
    emberPlayer = EmberPlayer(
      position: Vector2(0, 0),
      iTipo: iTipo,
      size: tamano,
      parentBody: this, // Pass reference to this EmberPlayerBody
    );
    add(emberPlayer);
    return super.onLoad();
  }



  @override
  void onTapDown(_) {
    body.applyLinearImpulse(Vector2.random() * 5000);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // TODO: implement onKeyEvent
    horizontalDirection = 0;
    verticalDirection = 0;

    //movimiento
    if((keysPressed.contains(LogicalKeyboardKey.keyA))){horizontalDirection=-1;}
    else if((keysPressed.contains(LogicalKeyboardKey.keyD))){horizontalDirection=1;}
    if((keysPressed.contains(LogicalKeyboardKey.keyW))){verticalDirection=-1;}
    else if((keysPressed.contains(LogicalKeyboardKey.keyS))){verticalDirection=1;}
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.digit5) {
        gameRef.toggleWorldGravity();
      }
    }

    return true;
  }

  @override
  void update(double dt) {
    //updatear movimiento
    velocidad.x = horizontalDirection * aceleracion;
    velocidad.y = verticalDirection * aceleracion;
    velocidad.y += -1 * jumpSpeed;

    body.applyLinearImpulse(velocidad*dt*1000);

    if (horizontalDirection < 0 && emberPlayer.scale.x > 0) {
      emberPlayer.flipHorizontallyAroundCenter();
    }
    else if (horizontalDirection > 0 && emberPlayer.scale.x < 0) {
      emberPlayer.flipHorizontallyAroundCenter();
    }

    super.update(dt);
  }

}