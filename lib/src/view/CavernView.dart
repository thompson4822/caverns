part of game_lib;

class CavernView extends DisplayObjectContainer {
  ResourceManager resources;
  Cavern cavern;
  
  List<Tile> tiles = new List();
  
  /// Where is the focus in the cavern?
  Point cavernFocus;
  
  /// Where is the avatar in the cavern (might not be the same as the focus)?
  Point avatarFocus;
  
  /// For the map display, what are the tile dimensions (not the same as size of map)
  int width;
  int height;
  
  BitmapData get wall => atlas.getBitmapData('wall_large');
  BitmapData get floor => atlas.getBitmapData('floor_large');
  
  TextureAtlas atlas;
  
  CavernView(ResourceManager this.resources, Cavern this.cavern, int viewportWidth, int viewportHeight) {
    atlas = resources.getTextureAtlas('atlas');
    width = viewportWidth ~/ wall.width;
    height = viewportHeight ~/ wall.height;
    cavernFocus = cavern.firstFloorTile;
    this.onEnterFrame.listen(enterFrameListener);
    renderCave();
  }
  
  void enterFrameListener(EnterFrameEvent e) {
    print("Entered another frame!");  
  }
  
  void addWall(int row, int col) {
    new Bitmap(wall)
      ..x = col * wall.width
      ..y = row * wall.height
      ..addTo(this);
  }
  
  void addFloor(int row, int col) {
    new Bitmap(floor)
      ..x = col * floor.width
      ..y = row * floor.height
      ..addTo(this);
  }

  void renderCave() {
    /*
      1) Find the first floor location in the cavern. This will be where we place the
         character
      2) What we draw will always center on the character. Because of this we will be
         drawing locations that are outside the cavern we've defined. 
    */
    for(int row = 0; row < cavern.height; row++) {
      for(int col = 0; col < cavern.width; col++) {
        if(cavern.isFloor(row, col))
          addFloor(row, col);    
        else {
          addWall(row, col);
        }
          
      }
    }
  }
  
  
  /// Refresh the display when the character position changes
  /// (Another way to handle this might be to have the keyboard event trigger a refresh)
//  void refresh() {
//    if(avatarCol != cavernCol || avatarRow != cavernRow) {
//      // redraw happens here
//    }
//    cavernCol = avatarCol; cavernRow = avatarRow;
//  }
}