extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const NEUTRAL = "neutral"
const HOT = "hot"
const FROZEN = "frozen"
export var temp = NEUTRAL

const STATIC = "static"
const FALLING = "falling"
export var state = STATIC

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_temp(temp)
	set_state(state)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func set_temp(new_temp):
	temp = new_temp
	$Sprite.texture = load("res://"+new_temp+"_tile.png")

func set_state(new_state):
	state = new_state
	if state == FALLING:
		# Exist in falling
		$BBoxArea.set_collision_layer_bit(2, true) # falling
		$BBoxArea.set_collision_layer_bit(1, false) # static
		# Detect static
		$BBoxArea.set_collision_mask_bit(2, false) # falling
		$BBoxArea.set_collision_mask_bit(1, true) # static
		# Monitoring
		$BBoxArea.monitoring = true
	elif state == STATIC:
		# Exist in falling
		$BBoxArea.set_collision_layer_bit(2, false) # falling
		$BBoxArea.set_collision_layer_bit(1, true) # static
		# Detect falling
		$BBoxArea.set_collision_mask_bit(2, true) # falling
		$BBoxArea.set_collision_mask_bit(1, false) # static
		# Monitoring
		$BBoxArea.monitoring = false

func is_supported():
	var block_below = $DownSensor.get_overlapping_areas()
	if block_below:
		print("block below!")
		return true
	else:
		return false

func on_land():
	set_state("static")

func is_overlapping_other():
	var overlapping_areas = $BBoxArea.get_overlapping_areas()
	if overlapping_areas:
		return true
	else:
		return false