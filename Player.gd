extends Area2D

signal hit
signal shoot(aimDirection)


export var speed = 400 # How fast player will move (pixels/second)
# export keyword allows us to set its value in the Inspector tab for this node
var screen_size #S ize of game window
var aimDirection = Vector2()
var alive = true
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size # Sets screensize to size of game window
	hide() # hides player when the game starts

	start(Vector2(100,100)) #Starts us at 100,100 for debugging


# Called every frame. 'delta' is the elapsed time since the previous frame.
# For player, each frame need to
# 1) Check for input
# 2) Move in inputted direction, if applicable
# 3) Play appropriate animation
func _process(delta):
	var velocity = Vector2() # Player's movement vector (2d vector with x and y component)
							 # default is 0,0, cuz player shouldnt be movin
	#Note for input mapping:
	   # Map inputs u want in Project Settings > Input Map.
	# You can detect whether a key is pressed using Input.is_action_pressed(), returns Bool

	# Getting input
	
	if Input.is_action_pressed("ui_stop"):
		velocity = Vector2.ZERO
		if Input.is_action_pressed("ui_left"):
			aimDirection = Vector2(-1,0)
		if Input.is_action_pressed("ui_right"):
			aimDirection=Vector2(1,0)
		if Input.is_action_pressed("ui_down"):   
			 #REMEMBER: 0,0 is top left corner. x increases as u go right, 
											  #                                  y increases as u go down
			aimDirection=Vector2(0,1)
		if Input.is_action_pressed("ui_up"):
			aimDirection= Vector2(0,-1)
		if Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_up"):
			aimDirection= Vector2(-1,-1)
		if Input.is_action_pressed("ui_left") and Input.is_action_pressed("ui_down"):
			aimDirection= Vector2(-1,1)
		if Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_up"):
			aimDirection= Vector2(1,-1)
		if Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_down"):
			aimDirection= Vector2(1,1)

	else:
		aimDirection = Vector2.ZERO
		if Input.is_action_pressed("ui_left"):
			velocity.x -= 1
		if Input.is_action_pressed("ui_right"):
			velocity.x += 1
		if Input.is_action_pressed("ui_down"):    #REMEMBER: 0,0 is top left corner. x increases as u go right, 
											  #                                  y increases as u go down
			velocity.y+=1 
		if Input.is_action_pressed("ui_up"):
			velocity.y-= 1

	# Checking if player is moving, and updating velocity and whether animation should play
	if velocity.length() > 0:
		# NOTE: for example, if left and down held, then resulting velocity is (1,1), with bigger length than 1.
		# This means that velocity will be faster when going diagonal oh no we dont want that.
		# So, we must normalize the vector to single unit length. 
		# Then, we multiply this normalized vector it by the speed we want Player to go at
		velocity=velocity.normalized() * speed
		$AnimatedSprite.play() #play animation if moving
	else:
		$AnimatedSprite.stop() # stop playing animation if not moving
		
	# Time to update the players actual position
	position += velocity * delta # their posiiton on map depends on velocity and how long theyve been holding the button (1 frame hopefully)
								 # delta is amount of time prev frame took to complete. Multiplying by delta means
								# even if ur framerate changes, ur movement will remain consistent	
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y) # Clamp means no matter what we keep this var within 0 till screen_size.y

	# Time to choose the correct animations to play
	if velocity.length() != 0:
		$AnimatedSprite.animation="up"
		$AnimatedSprite.rotation = 0
		if (velocity.x>0 and velocity.y>0):
			$AnimatedSprite.rotation = 3*PI/4
		elif (velocity.x>0 and velocity.y == 0):
			$AnimatedSprite.rotation=PI/2
		elif (velocity.x>0 and velocity.y < 0):
			$AnimatedSprite.rotation = PI/4
		elif (velocity.x == 0 and velocity.y < 0):
			$AnimatedSprite.rotation = 0
		elif (velocity.x<0 and velocity.y < 0):
			$AnimatedSprite.rotation = -PI/4
		elif (velocity.x<0 and velocity.y==0):
			$AnimatedSprite.rotation = -PI/2
		elif (velocity.x < 0 and velocity.y > 0):
			$AnimatedSprite.rotation = -3*PI/4
		else:
			$AnimatedSprite.rotation = PI
	
	if aimDirection.length() != 0:
		$AnimatedSprite.animation = "shoot"
		if (aimDirection.x>0 and aimDirection.y>0):
			$AnimatedSprite.rotation = -PI/4
		elif (aimDirection.x>0 and aimDirection.y == 0):
			$AnimatedSprite.rotation=-PI/2
		elif (aimDirection.x>0 and aimDirection.y < 0):
			$AnimatedSprite.rotation = -3*PI/4
		elif (aimDirection.x == 0 and aimDirection.y < 0):
			$AnimatedSprite.rotation = PI
		elif (aimDirection.x<0 and aimDirection.y < 0):
			$AnimatedSprite.rotation = 3*PI/4
		elif (aimDirection.x<0 and aimDirection.y==0):
			$AnimatedSprite.rotation = PI/2
		elif (aimDirection.x < 0 and aimDirection.y > 0):
			$AnimatedSprite.rotation = PI/4
		else:
			$AnimatedSprite.rotation = 0
		
		if (Input.is_action_pressed("ui_select") and alive):
			emit_signal("shoot", aimDirection)


func _on_Player_body_entered(body):
	if (body.is_in_group("mobs")):  
		emit_signal("hit") #emit our custom signal
		$CollisionShape2D.set_deferred("disabled", true) #Disable model so we dont trigger hit signal more than once
		hide() # Body disappears on hit
		alive = false
	#Object.set_deferred() lets u change the model.
	# set() changes model immediately, deferred makes Godot wait till its safe to do so

# Last piece is a function for placing Player when starting a new game
func start(position):
	alive = true
	self.position=position #set position to what we send the func
	show()
	$CollisionShape2D.disabled = false #Enable the hurtbox





######## TOUCH COMPATIBLE VERSION: #####
#
#
#extends Area2D
#
#signal hit
#
#export var speed = 400
#var screen_size
## Add this variable to hold the clicked position.
#var target = Vector2()
#
#func _ready():
#	hide()
#	screen_size = get_viewport_rect().size
#
#func start(pos):
#	position = pos
#	# Initial target is the start position.
#	target = pos
#	show()
#	$CollisionShape2D.disabled = false
#
## Change the target whenever a touch event happens.
#func _input(event):
#	if event is InputEventScreenTouch and event.pressed:
#		target = event.position
#
#func _process(delta):
#	var velocity = Vector2()
#	# Move towards the target and stop when close.
#	if position.distance_to(target) > 10:
#		velocity = target - position
#
## Remove keyboard controls.
##    if Input.is_action_pressed("ui_right"):
##       velocity.x += 1
##    if Input.is_action_pressed("ui_left"):
##        velocity.x -= 1
##    if Input.is_action_pressed("ui_down"):
##        velocity.y += 1
##    if Input.is_action_pressed("ui_up"):
##        velocity.y -= 1
#
#	if velocity.length() > 0:
#		velocity = velocity.normalized() * speed
#		$AnimatedSprite.play()
#	else:
#		$AnimatedSprite.stop()
#
#	position += velocity * delta
#	# We still need to clamp the player's position here because on devices that don't
#	# match your game's aspect ratio, Godot will try to maintain it as much as possible
#	# by creating black borders, if necessary.
#	# Without clamp(), the player would be able to move under those borders.
#	position.x = clamp(position.x, 0, screen_size.x)
#	position.y = clamp(position.y, 0, screen_size.y)
#
#	if velocity.x != 0:
#		$AnimatedSprite.animation = "walk"
#		$AnimatedSprite.flip_v = false
#		$AnimatedSprite.flip_h = velocity.x < 0
#	elif velocity.y != 0:
#		$AnimatedSprite.animation = "up"
#		$AnimatedSprite.flip_v = velocity.y > 0
#
#func _on_Player_body_entered( body ):
#	hide()
#	emit_signal("hit")
#	$CollisionShape2D.set_deferred("disabled", true)
