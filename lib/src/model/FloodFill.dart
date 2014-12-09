part of game_lib;

class FloodFill {
  Cavern cavern;
  
  FloodFill(Cavern this.cavern);
  
  List<List<int>> caverns() {
    List<List<int>> results;
    
    results = new List();
    for(int row = 0; row < cavern.height; row++) {
      for(int col = 0; col < cavern.width; col++) {
        if(isWall(row, col) == false && results.any((room) => room.contains(position(row, col))) == false) {
          results.add(getRoom(row, col));
        }
      }
    }
    results.sort((cave1, cave2) => cave2.length.compareTo(cave1.length));
    return results;
  }
  
  int position(row, col) => row * cavern.width + col;

  bool isWall(row, col) => row < 0 || row == cavern.height || col < 0 || col == cavern.width || cavern.isFloor(row, col) == false; 

  /// This function has decent performance for what we need.
  List<int> getRoom(int row, int col) {
    Set<int> recGetRoom(int row, int col, Set<int> accum) {
      if(isWall(row, col) || accum.contains(position(row, col)))
        return accum;
      else
        accum.add(position(row, col));
      accum = recGetRoom(row, col + 1, accum); // right
      accum = recGetRoom(row, col - 1, accum); // left    
      accum = recGetRoom(row + 1, col, accum); // down
      return recGetRoom(row - 1, col, accum); // up
    }
    return recGetRoom(row, col, new Set()).toList();
  }
  
}
