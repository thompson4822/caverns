part of game_lib;

typedef bool DetermineWall(int row, int col);
typedef void MapIterator(int row, int col);

class Cavern {
  int seed = new DateTime.now().millisecondsSinceEpoch;
  Math.Random _rand;

  Math.Random get rand {
    if(_rand == null)
      _rand = new Math.Random(seed);
    return _rand;
  }
  
  List<List<bool>> map;

  static const bool FLOOR = false;
  static const bool WALL = true;

  int width;
  int height;
  int iterations;
  int birthLimit;
  int deathLimit;

  /// Construct a cavern of the given width and height, with cellular automata information to guide the cavern formation.
  Cavern({int this.width: 48, int this.height: 48, int this.iterations: 6, int this.birthLimit: 4, int this.deathLimit: 3}) {
    map = initial();
    //print(cavernString(map));
    for (int iteration = 0; iteration < iterations; iteration++) map = nextGeneration(map);
  }

  /// Construct a cavern that is the subdivided form of an existing cavern.
  Cavern.subdivide(Cavern cave) {
    // Subdivide the current map. Could be done several times to get finer resolution
    var result = new List<List<bool>>();
    for (var row = 0; row < cave.height; row++) {
      var row1 = new List<bool>();
      var row2 = new List<bool>();
      for (var col = 0; col < cave.width; col++) {
        row1.add(cave.map[row][col]);
        row1.add(cave.map[row][col]);
      }
      row2.addAll(row1);
      result.add(row1);
      result.add(row2);
    }
    width = cave.width * 2;
    height = cave.height * 2;
    iterations = cave.iterations;
    birthLimit = cave.birthLimit;
    deathLimit = cave.deathLimit;
    seed = cave.seed;
    map = result;
    smooth();
  }

  /// Smooth out the current map so the walls flow more naturally
  /// (NOTE - only useful in larger maps. In small maps, cavern structure can be lost using this)
  void smooth() {
    var result = new List<List<bool>>();
    result.addAll(map);
    for (int row = 0; row < height; row++) {
      for (int col = 0; col < width; col++) {
        if (map[row][col] == Cavern.WALL && wallCountMoore(row, col, 1) == 3) 
          result[row][col] = Cavern.FLOOR;
      }
    }
    map = result;
  }

  Point get firstFloorTile {
    for (int row = 0; row < height; row++) {
      for (int col = 0; col < width; col++) {
        if (map[row][col] == Cavern.FLOOR)
          return new Point(row, col);
      }
    }
    return null;
  }
  
  /// Uses Moore's Neighborhood to figure out count. We don't really use it in this code.
  int wallCountMoore(int row, int col, int distance) {
    int walls = 0;
    for (int rIndex = -distance; rIndex <= distance; rIndex++) {
      for (int cIndex = -distance; cIndex <= distance; cIndex++) {
        var currentRow = row + rIndex;
        var currentCol = col + cIndex;
        if (currentRow < 0 || currentRow >= height || currentCol < 0 || currentCol >= width || map[currentRow][currentCol] == WALL) 
          if (!(rIndex == 0 && cIndex == 0)) 
            walls++;
      }
    }
    return walls;
  }

  /// Just how much of the map is navigable (is flooring)?
  double get percentNavigable {
    int totalFloorSpace = map
        .map((row) => row.where((cell) => cell == Cavern.FLOOR).length)
        .reduce((total, current) => total + current);
    return totalFloorSpace / (width * height);
  }

  /// Is the tile at the given row and column a floor?
  bool isFloor(int row, int col) => map[row][col] == Cavern.FLOOR;

  /// Should the given row and column in the provided map be a wall?
  bool shouldBeWall(List<List<bool>> map, int row, int col) {
    int walls = 0;
    for (int rIndex = row - 1; rIndex <= row + 1; rIndex++) {
      for (int cIndex = col - 1; cIndex <= col + 1; cIndex++) {
        if (!(rIndex == row && cIndex == col) && (rIndex < 0 || rIndex >= height || cIndex < 0 || cIndex >= width || map[rIndex][cIndex] == WALL)) walls++;
      }
    }
    return (map[row][col]) ? walls >= deathLimit : walls > birthLimit;
  }

  /// Use simple cellular automata rules to generate a cavern map
  List<List<bool>> nextGeneration(List<List<bool>> oldMap) {
    var result = new List<List<bool>>();
    for (int row = 0; row < height; row++) {
      result.add(new List<bool>());
      for (int col = 0; col < width; col++) {
        result[row].add(shouldBeWall(oldMap, row, col) ? Cavern.WALL : Cavern.FLOOR);
      }
    }
    return result;
  }

  /// What is a map where ~40% of its tiles are walls and the rest floor?
  List<List<bool>> initial() {
    var result = new List<List<bool>>();
    for (var row = 0; row < height; row++) {
      result.add(new List<bool>());
      for (var col = 0; col < width; col++) {
        result[row].add((rand.nextDouble() < .40) ? WALL : FLOOR);
      }
    }
    return result;
  }

  /// Given a list of locations, fill those areas with walls
  void fillIn(List<int> locations) =>
    locations.forEach((l) => map[l ~/ width][l % width] = WALL);

  /// What is the printable string representation of this cavern?
  String toString() {
    String rowString(row) => row.map((tile) => (tile == WALL) ? "#" : '.').join('');
    return map.map((row) => rowString(row)).join('\n');
  }


}
