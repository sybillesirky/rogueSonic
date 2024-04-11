extends Node2D
class_name HealthComponent

var health : float
@export var MAX_HEALTH = 1


func _ready():
	health = MAX_HEALTH


func _hit(damage):
	health -= damage
	if health <= 0:
		get_parent().onKill()
