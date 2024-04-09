extends CharacterBody2D

const character = GlobalDefinitions.character
const state = GlobalDefinitions.state
const specialAction = GlobalDefinitions.specialAction

var currentState = state.Idle
var previousState = state.Idle

@export var speedCap = 1000
@export var jumpVelocity = 700
@export var gravity = 30
@export var friction = 5
@export var acceleration = 5
@export var deceleration = 20
var horizontalDirection = 1
var inputDirection = 0
var forwardAngle = Vector2(1,0)
var rollAngle = Vector2(0,0)
var playerRotation = 0
var allowInput = true


func _changeState(nextState):
	# Do nothing if the state didn't change
	if nextState == currentState: return
	
	# Update the state trackers
	previousState = currentState
	currentState = nextState
	
	# Get out of hurt state behaviour
	if previousState == state.Hurt and !$hurtTimer.is_stopped():
		$hurtTimer.stop()
		$invulnTimer.start()
	
	# Play the roll sound if we enter Roll state
	if nextState == state.Roll:
		$effectAudioPlayer.playPlayerSFX(3, PlayerInfo.currentCharacter)
	
	# Play the hurt SFX if we enter that state
	if nextState == state.Hurt:
		velocity = Vector2(-horizontalDirection * 2, -5) * 100
		velocity.y *= -up_direction.y
		allowInput = false
		$hurtTimer.start()
		$voiceAudioPlayer.playPlayerVoice(1, PlayerInfo.currentCharacter)
		$specialActions.currentSpecialAction = 0


func _setPlayerState():
	# Crouch
	if velocity == Vector2(0,0) and Input.is_action_pressed("down") and is_on_floor():
		_changeState(state.Crouch)
		allowInput = true
		return
	
	# Idle (standing)
	if velocity == Vector2(0,0) and is_on_floor():
		_changeState(state.Idle)
		allowInput = true
		return
	
	# If not in jump/fall/roll while in the air, you fall
	if !is_on_floor() and (currentState == state.Idle or currentState == state.Run):
		_changeState(state.Fall)
		return
	
	# Force stay on Roll until we're stationary
	if velocity != Vector2(0,0) and currentState == state.Roll:
		return
	
	# Run
	if is_on_floor() and velocity != Vector2(0,0):
		_changeState(state.Run)
		allowInput = true
		return
	
	# Move out of the hurt state if the timer runs out
	if currentState == state.Hurt and $hurtTimer.is_stopped():
		_changeState(state.Fall)
		$invulnTimer.start()


func _physics_process(delta):
	# Debug switch character
	if Input.is_action_just_pressed("debug_button_2"):
		print("test")
		print(PlayerInfo.currentCharacter)
		PlayerInfo.currentCharacter += 1
		if PlayerInfo.currentCharacter == len(character):
			PlayerInfo.currentCharacter = 0
	
		match PlayerInfo.currentCharacter:
			character.Sonic:
				PlayerInfo.availableActionForward = specialAction.jumpDash
				PlayerInfo.availableActionDownward = specialAction.Bounce
			
			character.Shadow:
				PlayerInfo.availableActionForward = specialAction.chaosDash
				PlayerInfo.availableActionDownward = specialAction.Bounce
			
			character.SuperSonic:
				PlayerInfo.availableActionForward = specialAction.jumpDash
				PlayerInfo.availableActionDownward = specialAction.Bounce
	
	# Set some constants
	floor_stop_on_slope = false
	floor_snap_length = 40
	Engine.max_fps = 60
	max_slides = 1000
	
	# If we're going fast while on the ground, the floor determines up direction
	if velocity.length() > 300 and is_on_floor():
		up_direction = get_floor_normal()
	else:
		up_direction = Vector2(0,-1)
	
	# Player Rotation: Match the floor's angle
	if is_on_floor():
		playerRotation = get_floor_normal().rotated(0.5*PI).angle()
	else:
		# If our angle isn't normal in the air, gradually move back to normal
		if playerRotation > 0:
			playerRotation -= 0.1
			if playerRotation < 0:
				playerRotation = 0
		elif playerRotation < 0:
			playerRotation += 0.1
			if playerRotation > 0:
				playerRotation = 0
	
	# Rotate sprite to match
	$charAnimator/charSprite.rotation = playerRotation
	$charCollision.rotation = playerRotation
	
	# Get input direction
	inputDirection = Input.get_axis("left", "right")
	if !allowInput:
		inputDirection = 0
	
	# Determine horizontal direction
	if velocity.x == 0 and inputDirection != 0:
		horizontalDirection = inputDirection
	if (horizontalDirection > 0 and velocity.x < -0.1) or (horizontalDirection < 0 and velocity.x > 0.1):
		horizontalDirection = -horizontalDirection
	
	# Invert horizontal direction on ceilings
	if up_direction.y > 0:
		horizontalDirection = -horizontalDirection
	
	# Get the forward angle
	forwardAngle = abs(forwardAngle)
	if get_floor_normal() != Vector2(0,0):
		forwardAngle = get_floor_normal().rotated(0.5 * PI)
	if horizontalDirection == -1:
		forwardAngle = forwardAngle.rotated(PI)
	
	# Horizontal direction is fixed while in the air
	if !is_on_floor():
		forwardAngle = Vector2(horizontalDirection, 0)
	
	# Increase/Decrease speed
	var speed = 0
	if horizontalDirection == inputDirection: # Accelerating
		if currentState != state.Roll:
			if abs(velocity.x) > speedCap:
				speed = 0
			elif velocity.length() < 300 and is_on_floor():
				speed = acceleration * 2 + friction
			elif velocity.length() > 600 and is_on_floor():
				speed = acceleration * 0.5 + friction
			else:
				speed = acceleration + friction
	elif horizontalDirection == -inputDirection: # Braking
		speed = -deceleration
	
	# Friction
	var frictionVector = -Vector2(1,0).rotated(velocity.angle())
	frictionVector.y = 0
	frictionVector *= friction
	if velocity != Vector2(0,0):
		velocity += frictionVector
	
	# If the velocity is too small, just set it to 0,0 to prevent microvalues
	if velocity.length() < 5:
		velocity = Vector2(0,0)
	
	# Gravity
	var gravityVector = Vector2(0, gravity)
	if !is_on_floor():
		velocity += gravityVector
	
	# Jump
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity += get_floor_normal() * jumpVelocity
		_changeState(state.Jump)
		$jumpActionTimer.start()
		$effectAudioPlayer.playPlayerSFX(0, PlayerInfo.currentCharacter)
	
	# Floor glue, this keeps the character on the wall/ceiling when running on it
	if is_on_floor() and up_direction != Vector2(0,-1) and currentState == state.Run:
		velocity += 300 * -get_floor_normal()
	
	# Roll
	if Input.is_action_just_pressed("down") and velocity.x != 0 and is_on_floor():
		_changeState(state.Roll)
	
	# Different collisions in certain circumstances
	if currentState == state.Roll:
		$charCollision.shape.size.y = 16
		$charCollision.position.y = -8
	elif currentState == state.Crouch:
		$charCollision.shape.size.y = 24
		$charCollision.position.y = -12
	else:
		$charCollision.shape.size.y = 32
		$charCollision.position.y = -16
	
	# Apply the speed in accordance with the forward angle
	velocity += speed * forwardAngle
	
	# Call the special actions which can override/modify default physics
	velocity = $specialActions._specialActionsHandler(PlayerInfo.currentCharacter, currentState, velocity, delta)
	
	# Prevent micovalues again
	if abs(velocity.y) < 0.0001:
		velocity.y = 0
	
	# Finally, do the physics
	move_and_slide()
	
	# Manage the player state and animations
	_setPlayerState()
	$charAnimator._animatePlayer(PlayerInfo.currentCharacter, currentState, $specialActions.currentSpecialAction)
