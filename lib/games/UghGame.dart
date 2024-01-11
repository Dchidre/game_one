import 'dart:async';
import 'dart:ui';

import 'package:flame/camera.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:ugh2/bodies/TierraBody.dart';
import 'package:ugh2/elementos/Gota.dart';
import 'package:ugh2/players/EmberPlayer2.dart';

import '../configs/config.dart';
import '../elementos/Estrella.dart';
import '../elementos/VidasComponent.dart';
import '../players/EmberPlayer.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/forge2d_game.dart';


class UghGame extends Forge2DGame with
    HasKeyboardHandlerComponents,HasCollisionDetection, CollisionCallbacks{

  //final world = World();
  late final CameraComponent cameraComponent;
  late EmberPlayerBody _player;
  late EmberPlayerBody2 _player2;
  late Gota gota;
  late TiledComponent mapComponent;
  late VidasComponent vidasComponent;

  double wScale=1.0,hScale=1.0;

  void toggleWorldGravity() {
    if (world.gravity.y == 1.0) {
      world.gravity = Vector2(0, -100000.0);
    }
    else if (world.gravity.y == -100000.0) {
      world.gravity = Vector2(0, 100000.0);
    }
    else {
      world.gravity = Vector2(0, 1.0);
    }
  }

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'ember.png',
      'heart_half.png',
      'heart.png',
      'star.png',
      'water_enemy.png',
      'reading.png',
      'tilemap1_32.png',
      'maponcio.jpg'
    ]);
    cameraComponent = CameraComponent(world: world);
    wScale=size.x/gameWidth;
    hScale=size.y/gameHeight;

    cameraComponent.viewfinder.anchor = Anchor.topLeft;
    addAll([cameraComponent, world]);

    mapComponent=await TiledComponent.load('maponcio.tmx', Vector2(32*wScale,32*hScale));
    world.add(mapComponent);

    ObjectGroup? gotas=mapComponent.tileMap.getLayer<ObjectGroup>("gotas");

    for(final gota in gotas!.objects){
      Gota spriteGota = Gota(position: Vector2(gota.x,gota.y),
          size: Vector2(64*wScale,64*hScale));
      add(spriteGota);
    }

    ObjectGroup? tierras=mapComponent.tileMap.getLayer<ObjectGroup>("tierra");

    for(final tiledObjectTierra in tierras!.objects){
      TierraBody tierraBody = TierraBody(tiledBody: tiledObjectTierra,
          scales: Vector2(wScale,hScale));
      add(tierraBody);
    }

    vidasComponent = VidasComponent(
      totalVidas: 3,
      vidaCompleta: Sprite(await images.load('heart.png')),
      mediaVida: Sprite(await images.load('heart_half.png')),
      tamanoCorazon: Vector2(32, 32),
    );
    add(vidasComponent);

    _player = EmberPlayerBody(initialPosition: Vector2(128, canvasSize.y - 350,),
      iTipo: EmberPlayerBody.I_PLAYER_TANYA,tamano: Vector2(50,100), gameRef: this
    );

    _player2 = EmberPlayerBody2(initialPosition: Vector2(200, canvasSize.y - 350,),
        iTipo: EmberPlayerBody2.I_PLAYER_TANYA,tamano: Vector2(50,50), gameRef: this
    );

    Gota gota = Gota(position: Vector2(200, canvasSize.y - 350,), size: Vector2(50,50));

    add(_player);
    add(_player2);
    add(gota);
  }
  
  @override
  Color backgroundColor() {
    // TODO: implement backgroundColor
    return Color.fromRGBO(102, 178, 255, 1.0);
  }


}