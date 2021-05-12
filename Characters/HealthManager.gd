extends Spatial

signal dead
signal hurt
signal healed
signal health_changed
signal gibbed #Jucy

export var max_health = 100
var cur_health = max_health

export var gib_art = -10 

func _ready():
	init()
	
func init():
	cur_health = max_health
	emit_signal("health_changed", cur_health)

func hurt(damage: int, dir: Vector3):
	if cur_health <= 0:
		return #YA DED
	cur_health -= damage
	if cur_health <=gib_art:
		pass #todo Need some gibbies here
		emit_signal("gibbed")
	if cur_health <= 0:
		emit_signal("dead")
		print("YA DEAD")
	else:
		emit_signal("hurt") 
	emit_signal("health_changed", cur_health)
	print("Hurt, at ", damage, ' damage. Current health is: ', cur_health)
	
	
func heal(amount):
	if cur_health <= 0:
		return #YA DED
	cur_health += amount
	if cur_health > max_health:
		cur_health = max_health
	emit_signal("healed")
	emit_signal("health_changed", cur_health)
	print("Healed at ", amount, " points. Current health is: ",cur_health)
