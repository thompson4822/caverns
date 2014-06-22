
import 'dart:math';

//var rand = new Random(343434); //new DateTime.now().millisecondsSinceEpoch);
var seed = new DateTime.now().millisecondsSinceEpoch;
var rand = new Random(seed);

List<List<bool>> map;

/*
Winit(p) = rand(0,100) < 40
Repeat 4: W?(p) = R1(p) ? 5 || R2(p) ? 2
Repeat 3: W?(p) = R1(p) ? 5
 */

const bool FLOOR = false;
const bool WALL = true;

const int WIDTH = 128;
const int HEIGHT = 128;

Map<int, List<int>> caverns;

/// From the map at the given row and column, looking out distance tiles in all directions, is the number of walls >= count?
bool isWallOld(row, col, distance, count) {
  int walls = 0;
  for(int rIndex = row - distance; rIndex <= row + distance; rIndex++) {
    for(int cIndex = col - distance; cIndex <= col + distance; cIndex++) {
      if(!(rIndex == row && cIndex == col) && (rIndex < 0 || rIndex >= HEIGHT || cIndex < 0 || cIndex >= WIDTH || map[rIndex][cIndex] == WALL))
        walls++;
    }
  }
  return walls >= count;
}

bool isWall(int row, int col, int distance, int count) {
  int walls = 0;
  for(int rIndex = row - distance; rIndex <= row + distance; rIndex++) {
    for(int cIndex = col - distance; cIndex <= col + distance; cIndex++) {
      if((row - rIndex).abs() == distance || (col - cIndex).abs() == distance) {
        if (rIndex < 0 || rIndex >= HEIGHT || cIndex < 0 || cIndex >= WIDTH || map[rIndex][cIndex] == WALL)
          walls++;
      }
    }
  }
  return walls >= count;
}

bool isWallNew(int row, int col, int birthLimit, int deathLimit) {
  int walls = 0;
  for(int rIndex = row - 1; rIndex <= row + 1; rIndex++) {
    for(int cIndex = col - 1; cIndex <= col + 1; cIndex++) {
      if(!(rIndex == row && cIndex == col) && (rIndex < 0 || rIndex >= HEIGHT || cIndex < 0 || cIndex >= WIDTH || map[rIndex][cIndex] == WALL))
        walls++;
    }
  }
  return (map[row][col]) ? walls >= deathLimit : walls > birthLimit;
}

typedef bool DetermineWall(int row, int col);

/// Use simple cellular automata rules to generate a cavern map
List<List<bool>> applyAutomata(DetermineWall func) {
  var result = new List<List<bool>>();
  for(int row = 0; row < HEIGHT; row++ ) {
    result.add(new List<bool>());
    for(int col = 0; col < WIDTH; col++) {
      result[row].add(func(row, col) ? WALL : FLOOR);
    }
  }
  return result;
}

List<List<bool>> generate() {
  var result = new List<List<bool>>();
  for(var row = 0; row < HEIGHT; row++) {
    result.add(new List<bool>());
    for (var col = 0; col < WIDTH; col++) {
      /*if(row == 0 || row == HEIGHT - 1 || col == 0 || col == WIDTH - 1)
        result[row].add(WALL);
      else*/
        result[row].add((rand.nextDouble() < .40) ? WALL : FLOOR);
    }
  }
  return result;
}

String cavernString(List<List<bool>> cavern) {
  String rowString(row) => row.map((tile) => (tile == WALL) ? "#" : '.').join('');
  return cavern.map((row) => rowString(row)).join('\n');
}

void main() {
  map = generate();
  print(cavernString(map));
  for(int iteration = 0; iteration < 7; iteration++)
    map = applyAutomata((row, col) => isWallNew(row, col, 4, 3));
/*
  for(int iteration = 0; iteration < 3; iteration++)
    map = applyAutomata((row, col) => isWall(row, col, 1, 4) || isWall(row, col, 2, 12));
  for(int iteration = 0; iteration < 3; iteration++)
    map = applyAutomata((row, col) => isWall(row, col, 1, 5));
*/
  print('\n');
  print(cavernString(map));
  print('Seed was $seed');
}