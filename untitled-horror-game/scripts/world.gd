extends Node2D

signal maze_loaded

@onready var ground: TileMapLayer = $floor
@onready var maze: TileMapLayer = $walls

const tile_margins: int =40
const maze_width:int =3
const maze_height:int =3
var walls: Dictionary = {}
var tile_direction: String
var flip_h:= TileSetAtlasSource.TRANSFORM_FLIP_H
var flip_v:= TileSetAtlasSource.TRANSFORM_FLIP_V
var transpose:= TileSetAtlasSource.TRANSFORM_TRANSPOSE
var cat_preload = preload("res://scenes/cat.tscn")
var big_scary_preload = preload("res://scenes/big_scary.tscn")
var dir: Array = ["UP","RIGHT","DOWN","LEFT"]
var one_direction: Dictionary = {
	"DOWN" = 0,
	"LEFT" = TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_H,
	"UP" = TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_FLIP_V,
	"RIGHT" = TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_V,
}

var norm_direction: Dictionary = {
	"UP" = 0,
	"RIGHT" = TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_H,
	"DOWN" = TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_FLIP_V,
	"LEFT" = TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_V,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	var t0 = Time.get_ticks_msec()
	make_floor()
	print("Floor: ", Time.get_ticks_msec() - t0, "ms")
	var t1 = Time.get_ticks_msec()
	make_border_walls()
	print("Border walls: ", Time.get_ticks_msec() - t1, "ms")
	var t2 = Time.get_ticks_msec()
	make_maze()
	print("Maze: ", Time.get_ticks_msec() - t2, "ms")
	add_entities(4)
	maze_loaded.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func make_floor():
	var margin = 9  # tiles of floor padding around the maze, not 40
	for i in range(-margin, maze_width + margin):
		for x in range(-margin, maze_height + margin):
			ground.set_cell(Vector2i(i,x), 0, Vector2i(0,4))

func make_border_walls():
	for i in range(maze_width):
		for x in range(maze_height):
			if (x > 0 and x < (maze_height-1)) and (i > 0 and i <(maze_width-1)):
				continue
			walls[(Vector2i(i,x))] = true

func make_maze():
	var checks_per_frame = 50
	var i = 0
	var checking_tile = Vector2i(1,1)
	var checked_tiles: Dictionary = {}
	var tiles_explored: Dictionary = {}
	var available_tiles: Array = []
	while true:
		i += 1 
		if i % checks_per_frame == 0:
			await get_tree().process_frame
		var index = 0
		available_tiles.append_array(await check_surrounding_tiles(checking_tile,"tiles")) 
		while index < len(available_tiles):
			if checked_tiles.has(available_tiles[index]):
				available_tiles.erase(available_tiles[index])
				continue
			if tiles_explored.has(available_tiles[index]):
				tiles_explored.erase(available_tiles[index])
				walls[(available_tiles[index])] = true
				available_tiles.erase(available_tiles[index])
				continue
			if available_tiles[index].x % 2 == 0 and available_tiles[index].y % 2 == 0 :
				walls[(available_tiles[index])] = true
				available_tiles.erase(available_tiles[index])
				continue
			index += 1
		checked_tiles[checking_tile] = true
		if len(available_tiles) > 1:
			checking_tile = available_tiles[randi() % len(available_tiles)]
		elif len(available_tiles) == 1:
			checking_tile = available_tiles[0]
		else:
			if tiles_explored:
				checking_tile = tiles_explored.keys()[0]
				tiles_explored.erase(checking_tile)
		available_tiles.erase(checking_tile)
		for tile in available_tiles:
			tiles_explored[tile] = true
		available_tiles.clear()
		available_tiles.erase(checking_tile)
		for tile in available_tiles:
			tiles_explored[tile] = true
		available_tiles.clear()
		i +=1
		if tiles_explored.is_empty():
			break
	await check_for_spaces()
	for z in walls.keys():
		set_tile(z)

func check_for_spaces():
	for i in range(0,maze_width-1,2):
		for x in range(0,maze_height-1,2):
			var tiles = check_surrounding_tiles(Vector2i(i,x),"tiles")
			if len(tiles) == 0:
				walls[(Vector2i(i,x))] = true


func check_surrounding_tiles(current_tile: Vector2i, mode:String):
	var tiles_available : Array = []
	var directions : Array = []
	if not walls.has(Vector2i(current_tile.x,current_tile.y - 1)):
		tiles_available.append(Vector2i(current_tile.x,current_tile.y - 1))
	else:
		directions.append("UP")
	if not walls.has(Vector2i(current_tile.x -1,current_tile.y)):
		tiles_available.append(Vector2i(current_tile.x -1,current_tile.y))
	else:
		directions.append("LEFT")
	if not walls.has(Vector2i(current_tile.x,current_tile.y + 1)):
		tiles_available.append(Vector2i(current_tile.x,current_tile.y + 1))
	else:
		directions.append("DOWN")
	if not walls.has(Vector2i(current_tile.x + 1,current_tile.y)):
		tiles_available.append(Vector2i(current_tile.x + 1,current_tile.y))
	else:
		directions.append("RIGHT")
	match mode:
		"tiles":
			return tiles_available
		"directions":
			return directions
		


func set_tile(current_tile:Vector2i):
	var directions = check_surrounding_tiles(current_tile,"directions")
	match len(directions):
		1:
			maze.set_cell(current_tile,0,Vector2(0,0),one_direction[directions[0]])
		2:
			if (directions.has("UP")and(directions.has("DOWN")))or(directions.has("LEFT")and(directions.has("RIGHT"))):
				maze.set_cell(current_tile,0,Vector2(2,4),one_direction[directions[0]])
			else:
				for i in range(len(dir)):
					if directions.has(dir[i]):
						if directions.has(dir[i+1]):
							maze.set_cell(current_tile,0,Vector2(0,2),norm_direction[dir[i]])
							break
						else:
							maze.set_cell(current_tile,0,Vector2(0,2),norm_direction[directions[i-1]])
							break
		3:
			for i in dir:
				if not directions.has(i):
					maze.set_cell(current_tile,0,Vector2(2,2),one_direction[i])
		4:
			maze.set_cell(current_tile,0,Vector2(2,0))

func add_entities(number_of_cats):
	for i in number_of_cats:
		var cat = cat_preload.instantiate()
		print(cat)
		$".".add_child(cat)
		cat.cat_frame = i
		var check_position = Vector2i((randi() % maze_width)*16,(randi() % maze_height)*16)
		while walls.has(check_position):
			check_position = Vector2i((randi() % maze_width)*16,(randi() % maze_height)*16)
		cat.global_position = check_position
	var big_scary = big_scary_preload.instantiate()
	$".".add_child(big_scary)
	var check_position = Vector2i((randi() % maze_width)*16,(randi() % maze_height)*16)
	while walls.has(check_position):
		check_position = Vector2i((randi() % maze_width)*16,(randi() % maze_height)*16)
	big_scary.global_position = check_position
