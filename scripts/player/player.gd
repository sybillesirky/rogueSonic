extends Node2D

var testDamage = false

var homingDestination = Vector2(0,0)
var currentHomingTarget = ""

const state = GlobalDefinitions.state
const character = GlobalDefinitions.character
const specialAction = GlobalDefinitions.specialAction

const chaoObject = preload("res://scenes/chao.tscn")

func actionSpring(springVelocity):
	$char._changeState(state.Jump)
	$char/specialActions.currentSpecialAction = specialAction.None
	$char.velocity.y = -1 * springVelocity


func _findHomingTarget():
	# Two variables to store the best target candidate
	var nearestHomingDestination = Vector2(0,0)
	var nearestTargetDistance = 10000
	var nearestHomingTarget = ""
	
	# Loop through all candidates and get the one with the shortest legal distance
	for target in get_tree().get_nodes_in_group("homingAttackTarget"):
		var targetPosition = target.global_position - self.position
		var targetDistance = abs(targetPosition - $char.position).length()
		var playerFacingTarget = ($char.position.x - targetPosition.x) * $char.horizontalDirection < 0
		var targetBelowPlayer = $char.position.y - targetPosition.y < 0
		if targetDistance < nearestTargetDistance and targetBelowPlayer and playerFacingTarget and targetDistance < 200:
			nearestHomingDestination = targetPosition
			nearestTargetDistance = targetDistance
			nearestHomingTarget = str(target)
	
	if nearestHomingDestination == Vector2(0,0):
		currentHomingTarget = ""
		$homingReticle.visible = false
	elif nearestHomingTarget != currentHomingTarget:
		currentHomingTarget = nearestHomingTarget
		$UIAudioPlayer._playLockOn()
		$homingReticle.visible = true
		$homingReticle.position = nearestHomingDestination
	homingDestination = nearestHomingDestination
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("debug_button"):
		var chao = chaoObject.instantiate()
		get_parent().add_child(chao)
		chao.ownerPlayer = $char
	
	if $char.currentState == state.Jump:
		_findHomingTarget()
		
	# Follow the character
	$playerCamera.position = $char.position
	
	$playerCamera/DEBUG.text = str($char.state.keys()[$char.currentState]) + "\n" + str($char.global_position)

func _getHurt(body):
	if body == $char and $char.currentState != GlobalDefinitions.state.Hurt and $char/invulnTimer.is_stopped():
		$char._changeState(5)
		$homingReticle.visible = false
