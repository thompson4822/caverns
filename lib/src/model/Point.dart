part of game_lib;

class Point extends Comparable {
  final int row; final int col;
  Point(this.row, this.col);

  @override
  int compareTo(Point other) {
    if(row < other.row || (row == other.row && col < other.col))
        return -1;
    else 
      return (this == other) ? 0 : 1;
  }
  
  @override
  bool operator ==(Point other) => other.row == row && other.col == col;
  
  @override
  String toString() => "($row, $col)"; 
}