import 'package:caverns/game_lib.dart';


void main() {
  cavern = nextCavern;
  print(cavern);
  cavern = new Cavern.subdivide(cavern);
  print("First floor tile is ${cavern.firstFloorTile}");
  print('Seed was ${cavern.seed}');
  // Display the completed cavern to the screen
  setupStage();
}
