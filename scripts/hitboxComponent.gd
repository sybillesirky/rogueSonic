extends Area2D
class_name HitboxComponent

@export var health : HealthComponent

func _hit(damage):
	if health:
		health._hit(damage)


func _on_area_entered(area):
	if area.get_parent().get_parent().is_in_group("Player"):
		var attackStrength = area.get_parent().get_parent().attackStrength
		_hit(attackStrength)
		print("test")
