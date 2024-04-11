extends Node2D

const chaoTypes = GlobalDefinitions.chaoTypes

var chaoType = chaoTypes.Ifrit
var d = 0
@onready var ownerPlayer = Object

# Called when the node enters the scene tree for the first time.
func _ready():
	$sprite.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	d += delta
	var circlePos = Vector2(sin(d * 2),cos(d * 2)) * Vector2(30,20)
	circlePos += Vector2(0,-50)
	var desiredPosition = ownerPlayer.global_position + circlePos
	
	$sprite.flip_h = 0 < self.global_position.x - desiredPosition.x
	if self.global_position == desiredPosition:
		$sprite.flip_h = ownerPlayer.get_node("charAnimator/charSprite").flip_h
	self.global_position = self.global_position.move_toward(desiredPosition, 10)
	
	var oldAnimation = $sprite.animation
	$sprite.animation = str(chaoTypes.keys()[chaoType]).to_lower()
	if $sprite.animation != oldAnimation:
		$sprite.play()
