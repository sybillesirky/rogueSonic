extends Node2D

const state = GlobalDefinitions.state

enum enemyState {
	Idle,
	Follow,
	Hurt
}

@onready var targetPlayer = get_tree().get_first_node_in_group("Player")

@export var delayTime = 30
var idleWaitTime = 5
var positionQueue = []
var miscQueue = [] # 0 = state; 1 = rotation; 2 = flip_h
var currentState = enemyState.Idle


func androidAnimator():
	var previousAnimation = $char/charSprite.animation
	match currentState:
		enemyState.Idle:
			if $char.is_on_floor():
				$char/charSprite.animation = "idle"
				$char/charSprite.offset.y = -3
			else:
				$char/charSprite.animation = "fall"
				$char/charSprite.offset.y = -5
		
		enemyState.Follow:
			match miscQueue[0][0]:
				state.Idle:
					$char/charSprite.animation = "idle"
					$char/charSprite.offset.y = -3
				state.Run:
					$char/charSprite.animation = "run"
					$char/charSprite.offset.y = -13
				state.Fall:
					$char/charSprite.animation = "fall"
					$char/charSprite.offset.y = 2
				state.Roll:
					$char/charSprite.animation = "roll"
					$char/charSprite.offset.y = 7
				_:
					$char/charSprite.animation = "jump"
					$char/charSprite.offset.y = 2
	
	if previousAnimation != $char/charSprite.animation:
		$char/charSprite.play()
	
	$char/charSprite.flip_h = miscQueue[0][2]


func androidChangeState(nextState):
	currentState = nextState
	print("test")


func androidIdle(delta):
	$char.velocity.y += 30
	idleWaitTime -= delta
	$char.move_and_slide()
	if idleWaitTime <= 0:
		currentState = enemyState.Follow


func androidFollow(delta):
	self.global_position = positionQueue[0]
	$char.position = Vector2(0,0)
	$char/charSprite.rotation = miscQueue[0][1]


func _process(delta):
	var targetChar = targetPlayer.get_node("char")
	if len(positionQueue) < delayTime:
		positionQueue += [targetChar.global_position]
		miscQueue += [[targetChar.currentState, targetChar.playerRotation, targetChar.get_node("charAnimator/charSprite").flip_h]]
	else:
		positionQueue.remove_at(0)
		positionQueue += [targetChar.global_position]
		
		miscQueue.remove_at(0)
		miscQueue += [[targetChar.currentState, targetChar.playerRotation, targetChar.get_node("charAnimator/charSprite").flip_h]]
	
	androidAnimator()


func _physics_process(delta):
	match currentState:
		enemyState.Idle:
			androidIdle(delta)
		enemyState.Follow:
			androidFollow(delta)


func _on_hit_box_body_entered(body):
	if body == targetPlayer.get_node("char"):
		targetPlayer._getHurt(body)
