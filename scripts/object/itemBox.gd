extends Node2D

const items = GlobalDefinitions.items
const rareItems = GlobalDefinitions.rareItems
const uncommonItems = GlobalDefinitions.uncommonItems
const commonItems = GlobalDefinitions.commonItems
@export var boxContents = GlobalDefinitions.items.speedCapUp
@export var ringCost = 30
@export var isRandom = true

func onKill():
	$boxSprite.animation = "broken"
	$breakAudio.play()
	
	$contentSprite.queue_free()
	$HealthComponent.queue_free()
	$HitboxComponent.queue_free()
	
	# Add item to inventory
	for item in PlayerInfo.player1.inventory:
		if item[0] == boxContents:
			item[1] += 1
			return
	PlayerInfo.player1.inventory += [[boxContents, 1]]


# Called when the node enters the scene tree for the first time.
func _ready():
	if isRandom:
		var itemChance = randi_range(1,100)
		if itemChance <= 15:
			boxContents = rareItems[randi_range(0,len(rareItems)-1)]
		elif itemChance <= 50:
			boxContents = uncommonItems[randi_range(0,len(uncommonItems)-1)]
		else:
			boxContents = commonItems[randi_range(0,len(commonItems)-1)]
	
	if boxContents in GlobalDefinitions.uncommonItems:
		$boxSprite.animation = "uncommon"
	elif boxContents in GlobalDefinitions.rareItems:
		$boxSprite.animation = "rare"
	else:
		$boxSprite.animation = "common"
	$boxSprite.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
