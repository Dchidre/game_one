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
import '../players/EmberPlayer.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame_forge2d/forge2d_game.dart';


class UghGame extends Forge2DGame with
    HasKeyboardHandlerComponents,HasCollisionDetection, CollisionCallbacks{

  //final world = World();
  late final CameraComponent cameraComponent;
  late EmberPlayerBody _player;
  late EmberPlayerBody2 _player2;
  late TiledComponent mapComponent;

  double wScale=1.0,hScale=1.0;

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'ember.png',
      'heart_half.png',
      'heart.png',
      'star.png',
      'water_enemy.png',
      'reading.png',
      'tilemap1_32.png'
    ]);
    cameraComponent = CameraComponent(world: world);
    wScale=size.x/gameWidth;
    hScale=size.y/gameHeight;

    cameraComponent.viewfinder.anchor = Anchor.topLeft;
    addAll([cameraComponent, world]);

    mapComponent=await TiledComponent.load('mapa1.tmx', Vector2(32*wScale,32*hScale));
    world.add(mapComponent);

    ObjectGroup? estrellas=mapComponent.tileMap.getLayer<ObjectGroup>("estrellas");

    for(final estrella in estrellas!.objects){
      Estrella spriteStar = Estrella(position: Vector2(estrella.x,estrella.y),
      size: Vector2(64*wScale,64*hScale));
      add(spriteStar);
    }

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

    _player = EmberPlayerBody(initialPosition: Vector2(128, canvasSize.y - 350,),
      iTipo: EmberPlayerBody.I_PLAYER_TANYA,tamano: Vector2(50,100)
    );

    _player2 = EmberPlayerBody2(initialPosition: Vector2(200, canvasSize.y - 350,),
        iTipo: EmberPlayerBody2.I_PLAYER_TANYA,tamano: Vector2(50,50)
    );

    add(_player);
    add(_player2);
  }
  
  @override
  Color backgroundColor() {
    // TODO: implement backgroundColor
    return Color.fromRGBO(102, 178, 255, 1.0);
  }


}