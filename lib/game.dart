import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:game_island/player/game_hero.dart';
import 'package:game_island/main.dart';
import 'package:game_island/util/my_game_controller.dart';

import 'decorations/chest.dart';
import 'decorations/lamp.dart';
import 'decorations/mushroom.dart';
import 'enemies/orcBoss.dart';
import 'interface/player_interface.dart';
import 'enemies/orc.dart';

class Game extends StatefulWidget {
  final int stage;
  const Game({Key? key, this.stage = 1}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  List<GameComponent> enemies = [];
  @override
  void initState() {
    switch (widget.stage) {
      case 1:
        enemies.add(Orc(_getWorldPosition(14, 19)));
        break;
      case 2:
        enemies.add(Orc(_getWorldPosition(18, 19)));
        enemies.add(Orc(_getWorldPosition(24, 19)));
        break;
      case 3:
        enemies.add(Orc(_getWorldPosition(16, 19)));
        enemies.add(Orc(_getWorldPosition(24, 19)));
        enemies.add(OrcBoss(_getWorldPosition(22, 16)));
        break;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BonfireWidget(
      joystick: Joystick(
        keyboardConfig: KeyboardConfig(),
        directional: JoystickDirectional(
          color: Colors.green,
        ),
        actions: [
          JoystickAction(
            actionId: 1,
            color: Colors.green,
            margin: const EdgeInsets.all(40),
          ),
        ],
      ),
      map: WorldMapByTiled(
        'map/island.json',
        objectsBuilder: {
          'lamp': (properties) => Lamp(properties.position),
          'chess': (properties) => Chess(properties.position),
          'mushroom': (properties) => Mushroom(properties.position),
        },
      ),
      player: GameHero(
        Vector2(18 * tileSize, 14 * tileSize),
      ),
      overlayBuilderMap: {
        PlayerInterface.overlayKey: (context, game) => PlayerInterface(
              game: game,
            )
      },
      initialActiveOverlays: const [
        PlayerInterface.overlayKey,
      ],
      components: [
        MyGameController(widget.stage),
        ...enemies,
      ],
      cameraConfig: CameraConfig(
        moveOnlyMapArea: true,
        zoom: defaultZoom,
        // smoothCameraEnable: true,
        sizeMovementWindow: Vector2(
          tileSize * 3,
          tileSize * 3,
        ),
      ),
      lightingColorGame: Colors.black.withOpacity(0.5),
    );
  }

  Vector2 _getWorldPosition(int x, int y) {
    return Vector2(x * tileSize, y * tileSize);
  }
}
