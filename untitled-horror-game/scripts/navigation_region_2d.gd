extends NavigationRegion2D

var maze_height = Global.maze_height*32
var maze_width = Global.maze_width*32

func nav():
	var polygon: PackedVector2Array = [
		Vector2(0,0),
		Vector2(0,maze_height),
		Vector2(maze_width,maze_height),
		Vector2(maze_width,0)
	]
	var nav_polygon = NavigationPolygon.new()
	nav_polygon.clear_outlines()
	nav_polygon.add_outline(polygon)
	navigation_polygon = nav_polygon
	print(navigation_polygon)
	await bake_navigation_polygon()



func _on_world_maze_loaded() -> void:
	nav()
