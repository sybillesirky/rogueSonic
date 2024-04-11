extends Node2D

const chaoTypes = GlobalDefinitions.chaoTypes
@export var boxContents = GlobalDefinitions.chaoTypes.None
@export var ringCost = 30
@export var isRandom = true

const chaoObject = preload("res://scenes/chao.tscn")


func onKill():
	# Add ability
	PlayerInfo.player1.chaoSlotForward = boxContents
	
	# Open box
	$box.animation = "open"
	$box.play()
	$breakAudio.play()
	
	# Delete unnecessary components
	$chao.queue_free()
	$healthComponent.queue_free()
	$hitboxComponent.queue_free()
	
	#Spawn the Chao
	var chao = chaoObject.instantiate()
	get_parent().add_child(chao)
	chao.chaoType = boxContents
	chao.global_position = self.global_position
	chao.ownerPlayer = get_tree().get_first_node_in_group("Player").get_node("char")


# Called when the node enters the scene tree for the first time.
func _ready():
	if isRandom:
		boxContents = randi_range(1,len(chaoTypes)-1)
	$chao.animation = str(chaoTypes.keys()[boxContents]).to_lower()
	$chao.play()
	$box.animation = "closed"
	$box.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
