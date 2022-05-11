extends KinematicBody2D

export var MAX_VELOCITY = 800;
export var MIN_VELOCITY = 25;
export var ACCELERATION = 2000;
export var RETRO_ACCELERATION = 1000;
export var MAX_SPIN = PI/20;
export var MIN_SPIN = PI/64;
export var ROTATION_MODIFIER = 2;
export var SPIN_FRICTION = 0.8;


var velocity = Vector2.ZERO;
var thrust = 0; # advanced
var heading = Vector2.UP;
var spin = 0;

onready var PlayerSprite = $PlayerSprite;

func _physics_process(delta):
	move_state(delta); # player input
	
	# update position and velocity
	velocity = move_and_slide(velocity);

func move_state(delta):
	# handle inputs
	var spin_dir = Input.get_action_strength("turn_right") - Input.get_action_strength("turn_left");
	var accel_dir = Input.get_action_strength("accelerate") - Input.get_action_strength("decelerate");
	var boost = Input.is_action_pressed("boost");
	
	# handle turn
	spin += PI/ROTATION_MODIFIER * spin_dir * delta;
	spin = clamp(spin, -MAX_SPIN, MAX_SPIN); # ensure spin does not exceed max value
	
	# auto slow spin
	if(!spin_dir):
		if(abs(spin) < MIN_SPIN):
			spin = 0;
		else:
			spin *= SPIN_FRICTION;
	
	# update heading with respect to spin
	heading = heading.rotated(spin);
	PlayerSprite.rotation = heading.angle(); # render ship turned
	
	# match velocity
	if(Input.is_action_pressed("match_velocity")):
		velocity -= velocity.normalized() * RETRO_ACCELERATION * delta;
	
	# handle acceleration
	velocity += heading * accel_dir * ACCELERATION * delta;
	if(velocity.length() > MAX_VELOCITY): # slow down if above maximum velocity
		velocity -= velocity.normalized() * ACCELERATION * delta;
	
	# if at very low velocity just set velocity to 0
	if(velocity.length() < MIN_VELOCITY):
		velocity = Vector2.ZERO;
	
