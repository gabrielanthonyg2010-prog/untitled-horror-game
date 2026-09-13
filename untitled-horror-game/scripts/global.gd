extends Node
const maze_width:int =31
const maze_height:int =31
enum Difficulties{
	Normal,
	Hard
}
var difficulty: Difficulties = Difficulties.Normal
var cats_acquired: int = 0
