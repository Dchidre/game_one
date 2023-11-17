

import 'package:flame/components.dart';
import 'package:ugh2/games/UghGame.dart';

class Estrella extends SpriteComponent with HasGameRef<UghGame>{


  Estrella({required super.position,required super.size});

  @override
  Future<void> onLoad() async {
    // TODO: implement onLoad
    sprite=Sprite(game.images.fromCache('star.png'));
    anchor=Anchor.center;
    return super.onLoad();
  }
}