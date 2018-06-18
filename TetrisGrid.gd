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
func _unhandled_input(event):
	var angle
	if event.is_action_pressed("ui_up"):
		#angle = 0
		pass
	elif event.is_action_pressed("ui_right"):
		$PlayerHandle.translate(Vector2(30, 0))
	elif event.is_action_pressed("ui_down"):
		#angle = 180
		# Fall each press
		game_step()
		$'../FallTimer'.start()
	elif event.is_action_pressed("ui_left"):
		$PlayerHandle.translate(Vector2(-30, 0))

# Called by FallTimer at a regular interval
func game_step():
	if state == "spawn":
		spawn()
		check_lose()
	elif state == "post-spawn":
		state = "fall"
		check_lose()
	elif state == "fall":
		fall()

func spawn():
	$PlayerHandle.spawn_random_at_top()
	state = "post-spawn"

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
		$Stack.add_child(tile)
	state = "spawn"

func check_clear():
	# TODO should really be for new block landings, but might be easier to check it all
	pass

func check_lose():
	# TODO this can happen on spawn or landing
	#if $PlayerHandle.in_illegal_position():
	if not $PlayerHandle.can_fall():
		lose()

func lose():
	print("Game over!")
	reset()

func reset():
	# Remove all stack children and set state to "spawn"
	print("Reset!")
	state = "spawn"
	for tile in $Stack.get_children():
		$Stack.remove_child(tile)
		tile.free()
	# Also empty the PlayerHandle
	$PlayerHandle.reset()