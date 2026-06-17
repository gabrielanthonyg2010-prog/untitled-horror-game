extends Node2D

@onready var tile_map_layer: TileMapLayer = $TileMapLayer

const maze_width:=101
const maze_height:=101
var walls :Array = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	make_floor()
	make_border_walls()
	make_maze()
	check_for_spaces()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func make_floor():
	for i in range(maze_width):
		for x in range(maze_height):
			tile_map_layer.set_cell(Vector2i(i,x),0,Vector2(1,0))

func make_border_walls():
	for i in range(maze_width):
		for x in range(maze_height):
			if (x > 0 and x < (maze_height-1)) and (i > 0 and i <(maze_width-1)):
				continue
			tile_map_layer.set_cell(Vector2i(i,x),0,Vector2(0,0))
			walls.append(Vector2i(i,x))

func make_maze():
	var checking_tile = Vector2i(1,1)
	var checked_tiles: Array = []
	var tiles_explored: Array = []
	var available_tiles: Array = []
	while true:
		var index = 0
		available_tiles.append_array(await check_surrounding_tiles(checking_tile)) 
		while index < len(available_tiles):
			if checked_tiles.has(available_tiles[index]):
				available_tiles.erase(available_tiles[index])
				continue
			if tiles_explored.has(available_tiles[index]):
				tiles_explored.erase(available_tiles[index])
				tile_map_layer.set_cell(available_tiles[index],0,Vector2(0,0))
				walls.append(available_tiles[index])
				available_tiles.erase(available_tiles[index])
				continue
			if available_tiles[index].x % 2 == 0 and available_tiles[index].y % 2 == 0 :
				tile_map_layer.set_cell(available_tiles[index],0,Vector2(0,0))
				walls.append(available_tiles[index])
				available_tiles.erase(available_tiles[index])
				continue
			index += 1
		checked_tiles.append(checking_tile)
		if len(available_tiles) > 1:
			checking_tile = available_tiles[randi()%len(available_tiles)]
		elif len(available_tiles) == 1:
			checking_tile = available_tiles[0]
		else:
			if tiles_explored:
				checking_tile = tiles_explored[0]
				tiles_explored.remove_at(0)
		available_tiles.erase(checking_tile)
		tiles_explored.append_array(available_tiles)
		available_tiles.clear()
		if len(tiles_explored) == 0:
			break

func check_for_spaces():
	for i in range(0,maze_width-1,2):
		for x in range(0,maze_height-1,2):
			var tiles = check_surrounding_tiles(Vector2i(i,x))
			if len(tiles) == 0:
				tile_map_layer.set_cell(Vector2i(i,x),0,Vector2(0,0))
				walls.append(Vector2i(i,x))

func check_surrounding_tiles(current_tile: Vector2i):
	var tiles_available := []
	if not walls.has(Vector2i(current_tile.x,current_tile.y - 1)):
		tiles_available.append(Vector2i(current_tile.x,current_tile.y - 1))
	if not walls.has(Vector2i(current_tile.x,current_tile.y + 1)):
		tiles_available.append(Vector2i(current_tile.x,current_tile.y + 1))
	if not walls.has(Vector2i(current_tile.x -1,current_tile.y)):
		tiles_available.append(Vector2i(current_tile.x -1,current_tile.y))
	if not walls.has(Vector2i(current_tile.x + 1,current_tile.y)):
		tiles_available.append(Vector2i(current_tile.x + 1,current_tile.y))
	return tiles_available
