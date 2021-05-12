extends KinematicBody

var hotkeys = {
	KEY_1: 0, #1 on keyboard
	KEY_2: 1, 
	KEY_3: 2, 
	KEY_4: 3, 
	KEY_5: 4, 
	KEY_6: 5, 
	KEY_7: 6, 
	KEY_8: 7, 
	KEY_9: 8, 
	KEY_0: 9, 
}


export var mouse_sens = 0.5

onready var camera = $Camera # get the camera scene and load it first
onready var character_mover = $CharacterMovement
onready var health_manager = $HealthManager
onready var weapon_manager = $Camera/WeaponManager

var dead = false


func _ready(): #load 
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) #lock the mouse to the screen
	character_mover.init(self) #intialize mover script
	health_manager.init()
	health_manager.connect("dead",self,"kill")


func _process(delta): #update
	if Input.is_action_just_pressed("exit"):
		get_tree().quit() #closes game
		
	if dead:
		return #your DED, you can't do anything
		
		
	var move_vec = Vector3() # 
	if Input.is_action_pressed("move_forward"):
		move_vec += Vector3.FORWARD
	if Input.is_action_pressed("move_back"):
		move_vec += Vector3.BACK
	if Input.is_action_pressed("move_right"):
		move_vec += Vector3.RIGHT
	if Input.is_action_pressed("move_left"):
		move_vec += Vector3.LEFT
		
	character_mover.set_move_vec(move_vec) #pass the move vector to the character movement script
	if Input.is_action_just_pressed("jump"):
		character_mover.jump() #jump frog jump


func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= mouse_sens * event.relative.x #move on y axis when mouse moves on Y axis
		camera.rotation_degrees.x -= mouse_sens * event.relative.y
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 110) #Don't snap your neck 
	if Input.is_action_just_pressed("action_heal"):
		heal(20)
	if event is InputEventKey and event.is_pressed():
		if event.scancode in hotkeys:
			weapon_manager.switch_to_weapon_slot(hotkeys[event.scancode])
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_WHEEL_UP:
			weapon_manager.switch_to_next_weapon()
		if event.button_index == BUTTON_WHEEL_DOWN:
			weapon_manager.switch_to_prev_weapon()

	if event is InputEventMouseButton and event.is_action_pressed("fire_weapon"):
		if event.button_index == BUTTON_LEFT:
			weapon_manager.attack(false)







func hurt(damage,dir):
	health_manager.hurt(damage,dir)
	
func heal(amount):
	health_manager.heal(amount)


func kill():
	dead = true
	character_mover.freeze()




func _on_Timer_timeout():
	pass # Replace with function body.
