import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:ugh2/games/UghGame.dart';

class EmberPlayer extends SpriteAnimationComponent
    with HasGameRef<UghGame>,KeyboardHandler {

  int horizontalDirection = 0;
  //LEYES DE NEWTON v=a*t
  //LEYES DE NEWTON d=v*t
  final Vector2 velocidad = Vector2.zero();
  final double aceleracion = 200;

  EmberPlayer({
    required super.position,
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

    if(keysPressed.contains(LogicalKeyboardKey.arrowRight)){
      horizontalDirection=1;
    }
    else if(keysPressed.contains(LogicalKeyboardKey.arrowLeft)){
      horizontalDirection=-1;
    }
    else if(keysPressed.contains(LogicalKeyboardKey.arrowUp)){
      position.y-=20;
    }
    else if(keysPressed.contains(LogicalKeyboardKey.arrowDown)){
      position.y+=20;
    }
    else{
      horizontalDirection=0;
    }

    return true;
  }


  @override
  void update(double dt) {
    // TODO: implement update
    velocidad.x = horizontalDirection * aceleracion; //v=a*t
    position += velocidad * dt; //d=v*t
    super.update(dt);
  }


}