import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ugh2/elementos/Estrella.dart';
import 'package:ugh2/games/UghGame.dart';

import '../elementos/Gota.dart';

class EmberPlayer extends SpriteAnimationComponent
    with HasGameRef<UghGame>,KeyboardHandler,CollisionCallbacks {

  static const  int I_PLAYER_SUBZERO=0;
  static const  int I_PLAYER_SCORPIO=1;
  static const  int I_PLAYER_TANYA=2;

  late int iTipo=-1;

  final _collisionStartColor = Colors.black87;
  final _defaultColor = Colors.red;
  late ShapeHitbox hitbox;

  int horizontalDirection = 0;
  int verticalDirection = 0;
  //LEYES DE NEWTON v=a*t
  //LEYES DE NEWTON d=v*t
  final Vector2 velocidad = Vector2.zero();
  final double aceleracion = 200;
  final Set<LogicalKeyboardKey> magiaSubZero={LogicalKeyboardKey.arrowDown, LogicalKeyboardKey.keyA};
  final Set<LogicalKeyboardKey> magiaScorpio={LogicalKeyboardKey.arrowUp, LogicalKeyboardKey.keyK};

  EmberPlayer({
    required super.position,required this.iTipo,
  }) : super(size: Vector2(100,160), anchor: Anchor.center);

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

    final defaultPaint = Paint()
      ..color = _defaultColor
      ..style = PaintingStyle.stroke;

    hitbox = RectangleHitbox();
    hitbox.paint=defaultPaint;
    hitbox.isSolid=true;
    add(hitbox);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // TODO: implement onKeyEvent
    //print("TECLADO PRESIONADO: "+event.data.logicalKey.keyId.toString());
    /*if(keysPressed.contains(LogicalKeyboardKey.arrowRight)){
      position.x+=20;
    }
    else if(keysPressed.contains(LogicalKeyboardKey.arrowLeft)){
      position.x-=20;
    }
    else if(keysPressed.contains(LogicalKeyboardKey.arrowUp)){
      position.y-=20;
    }
    else if(keysPressed.contains(LogicalKeyboardKey.arrowDown)){
      position.y+=20;
    }*/
    horizontalDirection=0;
    verticalDirection=0;

    if(keysPressed.containsAll(magiaScorpio) && iTipo==I_PLAYER_SCORPIO){//UP + K
      //print("MAGIA SCORPIO");
    }
    else if(keysPressed.contains(LogicalKeyboardKey.arrowRight)){
      horizontalDirection=1;
    }
    else if(keysPressed.contains(LogicalKeyboardKey.arrowLeft)){
      horizontalDirection=-1;
    }
    else if(keysPressed.contains(LogicalKeyboardKey.arrowUp)){
      verticalDirection=-1;
    }
    else if(keysPressed.contains(LogicalKeyboardKey.arrowDown)){
      verticalDirection=1;
    }
    else{
      verticalDirection=0;
      horizontalDirection=0;
    }

    return true;
  }


  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    // TODO: implement onCollision
    if(other is Gota){
      this.removeFromParent();
    }
    else if(other is Estrella){
      other.removeFromParent();
    }
    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints,
      PositionComponent other,
      ) {
    super.onCollisionStart(intersectionPoints, other);
    hitbox.paint.color = _collisionStartColor;
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    if (!isColliding) {
      hitbox.paint.color = _defaultColor;
    }
  }

  @override
  void update(double dt) {
    // TODO: implement update
    velocidad.x = horizontalDirection * aceleracion; //v=a*t
    velocidad.y = verticalDirection * aceleracion; //v=a*t
    //position += velocidad * dt; //d=v*t

    position.x += velocidad.x * dt; //d=v*t
    position.y += velocidad.y * dt; //d=v*t

    super.update(dt);
  }


}