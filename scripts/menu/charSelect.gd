extends Control


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("left"):
		PlayerInfo.player1.currentCharacter -= 1
		if PlayerInfo.player1.currentCharacter < 0:
			PlayerInfo.player1.currentCharacter = len(GlobalDefinitions.character) - 1
	if Input.is_action_just_pressed("right"):
		PlayerInfo.player1.currentCharacter += 1
		if PlayerInfo.player1.currentCharacter == len(GlobalDefinitions.character):
			PlayerInfo.player1.currentCharacter = 0
	
	var characterId = PlayerInfo.player1.currentCharacter
	var characterName = GlobalDefinitions.character.keys()[characterId]
	$charName.text = str(characterName)


func _on_start_button_pressed():
	FadeTransition.fadeTransition("res://scenes/envir/world.tscn")
