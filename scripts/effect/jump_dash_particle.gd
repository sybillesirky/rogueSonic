extends Node2D


func _ready():
	$sprite.play("0")


func _on_sprite_animation_finished():
	queue_free()
