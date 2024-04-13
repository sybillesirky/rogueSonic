extends Control

var soundMove = preload("res://assets/sound/menu/menuMove.wav")
var soundSelect = preload("res://assets/sound/menu/menuSelect.wav")


const characterDescriptions = [
	'"Fastest Thing Alive"', 		# Sonic
	'"The Ultimate Lifeform"', 		# Shadow
	'"Two-Tailed Technician"', 		# Tails
	'"Chaos is Power"' 				# Super Sonic
]


func getDefaultAbilityString(charID):
	match charID:
		GlobalDefinitions.character.Sonic:
			return "JUMP DASH"
		GlobalDefinitions.character.Shadow:
			return "CHAOS DASH"
		GlobalDefinitions.character.SuperSonic:
			return "ARROW OF LIGHT"
		GlobalDefinitions.character.Tails:
			return "HOVERJUMP"


func startGame():
	playSFX(soundSelect)
	
	# Reset the players stats
	PlayerInfo.player1.inventory = []
	PlayerInfo.player1.chaoSlotForward = GlobalDefinitions.chaoTypes.None
	PlayerInfo.player1.chaoSlotDownward = GlobalDefinitions.chaoTypes.None
	PlayerInfo.player1.chaoSlotUpward = GlobalDefinitions.chaoTypes.None
	
	FadeTransition.fadeTransition("res://scenes/envir/world.tscn")


func playSFX(input):
	$SFX.stream = input
	$SFX.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("jump"):
		startGame()
		return
	if Input.is_action_just_pressed("left"):
		playSFX(soundMove)
		PlayerInfo.player1.currentCharacter -= 1
		if PlayerInfo.player1.currentCharacter < 0:
			PlayerInfo.player1.currentCharacter = len(GlobalDefinitions.character) - 1
	if Input.is_action_just_pressed("right"):
		playSFX(soundMove)
		PlayerInfo.player1.currentCharacter += 1
		if PlayerInfo.player1.currentCharacter == len(GlobalDefinitions.character):
			PlayerInfo.player1.currentCharacter = 0
	
	var characterId = PlayerInfo.player1.currentCharacter
	var characterName = GlobalDefinitions.character.keys()[characterId]
	$charName.text = str(characterName).to_upper()
	if $charName.text == "SUPERSONIC":
		$charName.text = "SUPER SONIC"
	$charName.text = "< " + $charName.text + " >"
	$charTitle.text = characterDescriptions[characterId]
	$charAbility.text = "DEFAULT ABILITY: " + getDefaultAbilityString(characterId)
	$charPoster.animation = str(characterName).to_lower()
