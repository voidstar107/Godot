extends RigidBody2D

func _ready():
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names()) # Get list of animation names from Animated2DSprite's sprite_frames property ["walk", "swim", "fly"]
	$AnimatedSprite2D.animation = mob_types.pick_random()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
		queue_free() # Free/delete enemy at end of frame when it leaves the screen
