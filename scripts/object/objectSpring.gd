extends Node2D

@export var springPower = 1200

# Called when the node enters the scene tree for the first time.
func _ready():
	$sprite.animation = "idle"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $sprite.animation == "activate" and $sprite.is_playing() == false:
		$sprite.animation = "idle"
		$sprite.play()


func _on_area_2d_body_entered(body):
	if body.get_parent().is_in_group("Player"):
		body.get_parent().actionSpring(springPower)
		$sprite.animation = "activate"
		$sprite.play()
		$springSFX.play()
