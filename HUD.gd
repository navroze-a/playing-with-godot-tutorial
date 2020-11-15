extends CanvasLayer

signal start_game #will tell Main when the button is pressed

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Will show when we wanna show text. Will start our 2 sec timer as well
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over!")
	
	yield($MessageTimer, "timeout") #pauses execution till recieves "timeout" signal from MessageTimer (so 2 sec pause here)
	
	#Reset the start screen after game over
	$Message.text = "Dodge the \nCreeps!"
	$Message.show()
	yield(get_tree().create_timer(1), "timeout") #make a 1 sec timer and wait for it to expire
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score) #We'll call this fun from main whenever the score changes
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_MessageTimer_timeout():
	$Message.hide() #we'll be starting this timer everytime we've written a msg
					# so we hide this message once the timers done


func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_game")
