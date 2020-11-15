extends Node

export (PackedScene) var Mob#Allows us to choose a Mob scene we wish to instance
export (PackedScene) var Bullet

var score


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$BkgMusic.stop()
	$DeathSound.play()
	#Update HUD
	$HUD.show_game_over()
	
	
	

func new_game():
	get_tree().call_group("mobs", "queue_free")  #get rid of all the baddies
	#call_group calls the function 'queue_free' on every node in group 'mobs'
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start() #Start the start timer that'll begin other timers
	
	#Set up hud elements
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")
	
	#Start Music
	$BkgMusic.play()
	



func _on_StartTimer_timeout(): #starts other 2 timers
	$MobTimer.start()
	$ScoreTimer.start()


func _on_ScoreTimer_timeout():
	score+= 1 #increment score each second
	$HUD.update_score(score)


#Will create a Mob instance, pick a random start location for mob, and set it to motion
# Note: PathFollow2D will automatically make the new instance face inward when it spawns on path
func _on_MobTimer_timeout():
	# Choose a random starting location for Mob
	$MobPath/MobSpawnLocation.offset=randi()
	
	# Create and add mob instance to the scene
	var mob = Mob.instance() #Create instance
	add_child(mob)  # Add to scene
	
	#Set mob direction perpendicular to the path's direction
	var direction = $MobPath/MobSpawnLocation.rotation + PI/2 #Adds 90 to make perp
	
	#Set mob position to random place
	mob.position = $MobPath/MobSpawnLocation.position
	
	# Add some randomness to direction it'll travel by rotating it a bit
	direction += rand_range(-PI/4 , PI/4)
	mob.rotation = direction
	
	# Set velocity
	mob.linear_velocity  = Vector2(rand_range (mob.min_speed, mob.max_speed), 0) #sets x speed to range, y to 0
																				 # dont need a y speed cuz we're rotating it so straight x
	mob.linear_velocity = mob.linear_velocity.rotated(direction) # rotate to match mob's rotation
	

func _on_Player_shoot(aimDirection):
	var bullet = Bullet.instance()
	add_child(bullet)
	bullet.connect("shot_at" ,self, "on_mob_shot")
	bullet.spawn($Player.position, aimDirection)
	

func on_mob_shot(mob):
	print(mob.get_name() , "has been hit by bullet!")
	mob.queue_free()
	score+= 10
	$MobDeathSound.play()
