extends TileMap

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const respawn_pos = Vector2(1, 0)
var tile_scn = load("res://Tile.tscn")
var held_tiles = []

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func spawn_random_at_top():
	# TODO ensure clear children if needed
	var respawn_origin = map_to_world(respawn_pos)
	position = respawn_origin
	
	var tile_poses = [Vector2(0, 0), Vector2(1, 0), Vector2(-1, 0), Vector2(2, 0)]
	var temperature = ["neutral", "hot", "frozen"][randi() % 3]
	
	# Create em
	var new_tiles = []
	for pos in tile_poses:
		var new_tile = tile_scn.instance()
		# TODO refactor into init
		new_tile.position = map_to_world(pos)
		new_tile.set_state("falling")
		new_tile.set_temp(temperature)
		new_tiles.append(new_tile)
	
	# Add em
	for tile in new_tiles:
		add_child(tile)
	held_tiles = new_tiles

func fall():
	translate(Vector2(0, 30))
	
func can_fall():
	# All tiles are not supported
	for tile in held_tiles:
		if tile.is_supported():
			return false
	return true
	
func release_tiles():
	# Remove, transform, return
	
	for tile in held_tiles:
		remove_child(tile)
		# Apply our transformation to the tile (it will no longer be in local space)
		tile.translate(position)
	var formerly_held_tiles = held_tiles
	held_tiles = []
	return formerly_held_tiles

func reset():
	# Remove and delete all held tiles
	for tile in held_tiles:
		remove_child(tile)
		tile.free()
	held_tiles = []

func in_illegal_position():
	# Check overlapping existing
	for tile in held_tiles:
		if tile.is_overlapping_other():
			return true
	return false