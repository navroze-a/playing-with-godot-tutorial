extends RigidBody2D

signal shot(obj)
# Declare member variables here. Examples:
# var a = 2

export var min_speed = 150 #min speed range
export var max_speed = 250 #max speed range

# Called when the node enters the scene tree for the first time.
func _ready():
	contact_monitor = true
	self.set_name("Mob")
	# Get list of names of diff mob types
	var mob_types = $AnimatedSprite.frames.get_animation_names() #Gives array ["walk", "swim", "fly"]
	$AnimatedSprite.animation = mob_types[randi()%mob_types.size()] # We want a random num from 1-2
	# randi() % n gives random int from 0-(n-1)
	#Note: need to use randomize() if want 'random' seq to be diff each run of a scene.
	#   We'll use randomize in our Main scene.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _on_VisibilityNotifier2D_screen_exited():
	queue_free() #When we've exited the screen, lets release this node.


func die():
	queue_free()
	
		
