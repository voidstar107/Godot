extends Area2D

signal hit # Add signal to detect when player's hit by enemy
@export var speed : int = 400 # How fast the player will move (pixels/sec)
var screen_size : Vector2 # Size of game window; statically typed to try and get feel for Godot's types

func _ready(): # Std Godot func that does following when node enters scene tree
	screen_size = get_viewport_rect().size # Recall that windows and aspect ratio settings were changed in Project settings
	hide() # Hides player when game starts
	
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		
	if velocity.length() > 0: # If player is moving, play animation
		velocity = velocity.normalized() * speed # Prevents faster diagonal movement for player
		$AnimatedSprite2D.play() # $ is short for get_node(); so, code is short for get_node("AnimatedSprite2D").play()
	else: # Don't play animation if player is not moving
		$AnimatedSprite2D.stop()
	
	position += velocity * delta # Update player's position with movement direction/velocity; delta ensures movement consistent if frame rate changes
	position = position.clamp(Vector2.ZERO, screen_size) # Prevent player from leaving screen
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0 # Flip sprite horizontally if moving left
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0 # Flip sprite vertically if moving down

func start(pos):
	position = pos
	$AnimatedSprite2D.animation = "idle" # Reset player sprite to default
	$AnimatedSprite2D.flip_v = false
	show()
	$CollisionShape2D.disabled = false

func _on_body_entered(body: Node2D) -> void:
	hide() # Player disappears after being hit
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true) # Disable player's collision so hit signal isn't triggered more than once
	# Deferred makes Godot wait to disable collision shape until it's safe
