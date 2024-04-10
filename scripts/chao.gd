extends Node2D

const chaoTypes = GlobalDefinitions.chaoTypes

var chaoType = chaoTypes.Cheese
@onready var ownerPlayer = Object

# Called when the node enters the scene tree for the first time.
func _ready():
	$sprite.animation = "cheese"
	$sprite.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var desiredPosition = ownerPlayer.global_position + Vector2(30,-50)
	$sprite.flip_h = ownerPlayer.get_node("charAnimator/charSprite").flip_h
	self.global_position = self.global_position.move_toward(desiredPosition, 10)
	if abs(ownerPlayer.playerRotation) >= 3:
		$sprite.flip_h = !$sprite.flip_h
		print("test")
