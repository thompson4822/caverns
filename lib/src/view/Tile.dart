part of game_lib;

/**
 * Class that represents a specific tile that will be displayed as part of the puzzle
 */
class Tile extends Sprite {
  int _currentValue;
  String _currentState;

  /// Is the current tile valid?
  bool isValid = true;

  /// What is the tile manager for this tile?
  TileManager tileManager;

  /// Create a new tile with the given tile manager
  Tile(TileManager this.tileManager);

  /// Set the state of this tile
  void set state(String s) {
    // Since the bitmaps are overlaid, get rid of the bitmap for this sprite before adding another.
    _currentState = s;
    if(numChildren > 0)
      removeChildAt(0);
    if(isValid) {
      addChildAt(tileManager.forState(s), 0);
    } else {
      addChildAt(tileManager.forState(TileManager.WRONG), 0);
    }
  }

  /// What is the current state of the tile?
  String get state => _currentState;

  /// Set the value of this tile
  void set value(int v) {
    _currentValue = v;
    if(numChildren > 1)
      removeChildAt(1);
    if(v != 0)
    {
      var format = new TextFormat('Verdana', 100, Color.Black);
      // TODO - The following offsets should be calculated and not hard coded
      var text = new TextField("$v", format)
        ..x = 60
        ..y = 20;

      addChildAt(text, 1);
    }
  }

  /// What is the value of this tile?
  int get value => _currentValue;

}
