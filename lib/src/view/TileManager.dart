part of game_lib;

/**
 * Class to keep track of the tiles used in the game. Can be called upon to provide
 * the bitmap for the different tile states.
 */
class TileManager {
  Map<String, BitmapData> states = new Map();
  static const String CURSOR = 'tile_cursor';
  static const String EMPTY = 'tile_empty';
  static const String HIGHLIGHT = 'tile_highlight';
  static const String INITIAL = 'tile_initial';
  static const String WRONG = 'tile_wrong';

  // We can use this to resize or alter the individual tiles.
  Bitmap _asBitmap(BitmapData data) {
    return new Bitmap(data);
  }

  final TextureAtlas atlas;

  /// Create a new tile manager, using the given texture atlas.
  TileManager(TextureAtlas this.atlas) {
    states = {
        TileManager.CURSOR : atlas.getBitmapData(TileManager.CURSOR),
        TileManager.EMPTY : atlas.getBitmapData(TileManager.EMPTY),
        TileManager.HIGHLIGHT : atlas.getBitmapData(TileManager.HIGHLIGHT),
        TileManager.INITIAL : atlas.getBitmapData(TileManager.INITIAL),
        TileManager.WRONG : atlas.getBitmapData(TileManager.WRONG),
    };

  }

  /// What is the bitmap for the given [state]?
  Bitmap forState(String state) {
    return _asBitmap(states[state]);
  }
}
