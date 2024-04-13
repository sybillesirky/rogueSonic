extends Control


func _on_start_pressed():
	FadeTransition.fadeTransition("res://scenes/menu/char_select.tscn")


func _on_exit_pressed():
	get_tree().quit()
