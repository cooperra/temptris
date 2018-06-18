extends TileMap

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const grid_height = 20
const grid_width = 10

var state = "spawn"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

# TODO input events caught here
func dothething(event):
	pass

# Called by FallTimer at a regular interval
func game_step():
	if state == "spawn":
		spawn()
	elif state == "fall":
		fall()

func spawn():
	$PlayerHandle.spawn_random_at_top()
	state = "fall"

func fall():
	if $PlayerHandle.can_fall():
		print("can fall")
		$PlayerHandle.fall()
	else:
		print("no can fall")
		land()
		
func land():
	var released_tiles = $PlayerHandle.release_tiles()
	for tile in released_tiles:
		tile.on_land()
		add_child_below_node($Stack, tile)
	state = "spawn"

func check_clear():
	# TODO should really be for new block landings, but might be easier to check it all
	pass

func check_lose():
	# TODO this can happen on spawn or landing
	pass