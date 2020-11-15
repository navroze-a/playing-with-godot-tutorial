extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 800
var direction
signal shot_at


# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_name("Bullet")


func spawn(position, rotation):
	self.position = position
	self.direction = rotation.normalized()
	
	if (direction.x != 0 and direction.y == 0):
		$Sprite.rotation = 0
	elif (direction.x == 0 and direction.y != 0):
		$Sprite.rotation = PI/2
	elif(direction.x > 0 and direction.y < 0) or (direction.x < 0 and direction.y > 0):
		$Sprite.rotation = -PI/4
	elif (direction.x < 0 and direction.y < 0) or (direction.x > 0 and direction.y > 0):
		$Sprite.rotation = PI/4

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity= direction * speed
	position+= velocity*delta
	


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


	
	
	
#	if (direction.x == 0 and direction.y <0):
#		position
#	elif direction.x > 0 and direction.y < 0):
#	elif direction.x > 0 and direction.y == 0):
#	elif direction.x > 0 and direction.y > 0):
#	elif direction.x == 0 and direction.y > 0):
#	elif direction.x < 0 and direction.y <0):
#	elif direction.x < 0 and direction.y == 0):
#	elif direction.x < 0 and direction.y <0):
	
	
	


func _on_Bullet_body_entered(body):

	if (body.is_in_group("mobs")):
		emit_signal("shot_at", body)
		$CollisionShape2D.set_deferred("disabled", true) #Disable model so we dont trigger hit signal more than once
		hide() # Body disappears on hit
		queue_free()
