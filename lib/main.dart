import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'games/UghGame.dart';

/*
void main() {
  final game = UghGame();
  runApp(GameWidget(game: game));

}
*/

void main() {
  runApp(
    const GameWidget<UghGame>.controlled(
      gameFactory: UghGame.new,
    ),
  );
}