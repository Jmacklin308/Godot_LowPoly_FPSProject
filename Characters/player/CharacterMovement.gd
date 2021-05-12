###This script is used for all characters movement. Use at your own risk.
extends Spatial


var body_to_move : KinematicBody = null #whomever is using this script is now stored in an variable

export var move_acceleration = 4
export var max_speed = 25
var drag = 0.0 #calculated from accel and speed
export var jump_force = 30
export var gravity = 60

#keep track of current variables
var pressed_jump = false
var move_vec = Vector3()
var velocity = Vector3()
var snap_vec = Vector3()
export var ignore_rotation = false # if enabled, treats move_vec as a global vector (for ai, they follow a grid)

signal movement_info #broadcast useful info


var frozen = false #used when your bitch ass dies

func _ready():
	drag = float(move_acceleration) / max_speed

func init(_body_to_move: KinematicBody):
	body_to_move = _body_to_move
	
func jump():
	pressed_jump = true

func set_move_vec(_move_vec: Vector3):
	move_vec = _move_vec.normalized() #always set it to 1


func _physics_process(delta): #put physics in this
	if frozen:
		return #don't do anything
	var current_move_vec = move_vec
	if !ignore_rotation:
		current_move_vec = current_move_vec.rotated(Vector3.UP, body_to_move.rotation.y)
	
	velocity += move_acceleration * current_move_vec - velocity * Vector3(drag, 0, drag) + (gravity * Vector3.DOWN) * delta 
	velocity = body_to_move.move_and_slide_with_snap(velocity, snap_vec , Vector3.UP)
	
	var grounded = body_to_move.is_on_floor()
	if grounded:
		velocity.y = -0.01 #move down the next frame
		
	if grounded and pressed_jump:
		velocity.y = jump_force
		snap_vec = Vector3.ZERO #don't stick to ground
	else:
		snap_vec = Vector3.DOWN #stay on the ground
		
	pressed_jump = false # reset jump 
	emit_signal("movement_info", velocity, grounded)
	
func freeze():
	frozen = true
	
func unfreeze():
	frozen = false
