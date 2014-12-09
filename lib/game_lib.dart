library game_lib;

import 'dart:html' as html;
import 'dart:math' as Math;
import 'package:stagexl/stagexl.dart';

part 'src/model/Cavern.dart';
part 'src/model/FloodFill.dart';
part 'src/model/Point.dart';
part 'src/view/CavernView.dart';
part 'src/view/Tile.dart';
part 'src/view/TileManager.dart';

Stage stage = null;
RenderLoop renderLoop;
Cavern cavern = null;
ResourceManager resourcemanager = new ResourceManager();

/// General purpose method of getting the canvas, stage and render loop ready.
void setupStage() {
  // setup the Stage and RenderLoop
  var canvas = html.querySelector('#stage');
  //canvas.focus();
  stage = new Stage(canvas, webGL: true);
  //stage.align = StageAlign.TOP_LEFT;
  renderLoop = new RenderLoop();
  renderLoop.addStage(stage);
  loadResources();
}

void loadResources() {
  resourcemanager
    ..addTextureAtlas("atlas", "images/atlas.json", TextureAtlasFormat.JSONARRAY);
  resourcemanager.load()
    ..then((_) => stage.addChild(new CavernView(resourcemanager, cavern, stage.sourceWidth, stage.sourceHeight)));
}

Cavern get createCavern {
  var candidate = new Cavern();
  FloodFill ff = new FloodFill(candidate);
  ff.caverns().skip(1).forEach((cave) => candidate.fillIn(cave));
  return candidate;
}

Cavern get nextCavern {
  Cavern candidate = createCavern;
  while(candidate.percentNavigable < .50)
    candidate = createCavern;
  return candidate;
}