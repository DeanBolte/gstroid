extends Camera2D

export (NodePath) var POSITION_PATH
export (NodePath) var PLAYER_PATH
export var VELOCITY_MODIFIER = 0.1
export var LOOK_DISTANCE = 250

onready var TargetNode = get_node(POSITION_PATH)
onready var PlayerNode = get_node(PLAYER_PATH)

var target_position = Vector2.ZERO

func _physics_process(delta):
	# track current position
	target_position = TargetNode.global_position
	
	# take input
	var hmove = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	var vmove = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
	
	# player controlled camera viewing around the ship
	# i want this to be controlled by an analogue thumbstick, would look a lot better with an analogue system
	# would be possible to do this with acceleration and the digital directional pad
	target_position.x += hmove * LOOK_DISTANCE
	target_position.y += vmove * LOOK_DISTANCE
	
	# player variables
	target_position += PlayerNode.velocity * VELOCITY_MODIFIER
	# camera vibration needs reworking, kinda headache inducing
	#target_position += (randi() % 30) * PlayerNode.velocity / 1000
	
	# update position
	position = target_position
	
