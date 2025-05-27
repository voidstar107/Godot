extends CanvasLayer

signal start_game # Notifies 'Main' node that the button has been pressed

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over(): # Game over function that shows message for 2 seconds
	show_message("Game Over")
	await $MessageTimer.timeout # Wait until the MessageTimer has counted down.
	
	$Message.text = "Dodge the Creeps!"
	$Message.show()
	await get_tree().create_timer(1.0).timeout # Make one-shot timer and wait for it to finish.
	# create_timer() - SceneTree function that's useful for adding delay
	$StartButton.show() # Show start button after 2 seconds
	update_score(0) # Reset score to 0 before game starts
	
func update_score(score):
	$ScoreLabel.text = str(score)


func _on_start_button_pressed() -> void:
	# Hide start button when game starts
	$StartButton.hide()
	start_game.emit()


func _on_message_timer_timeout() -> void:
	$Message.hide() # Hide title when game starts 
