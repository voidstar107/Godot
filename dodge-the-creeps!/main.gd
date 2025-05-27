extends Node

@export var mob_scene: PackedScene # Lets choose Mob scene to instance
var score : int

func _ready():
	pass # new_game()
	
func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over() # Call game over function from HUD scene
	$Music.stop()
	$DeathSound.play()

func new_game():
	get_tree().call_group("mobs", "queue_free") # Calls queue_free on every mob node in mobs group; every mob deletes itself
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score) # Set score to 0 when game starts
	$HUD.show_message("Get Ready")
	$Music.play()

func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate() # Create new instance of the Mob scene
	
	# Choose random location on Path2D
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# Set mob's position to random location
	mob.position = mob_spawn_location.position
	
	# Set mob's direction perpendicular to path direction
	var direction = mob_spawn_location.rotation + PI / 2 # Pi represents half turn in radians
	
	# Add randomness to direction
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Set random velocity for mob
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# Spawn mob by adding it to Main scene
	add_child(mob)


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score) # Keeps display in sync with changing score


func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
	
