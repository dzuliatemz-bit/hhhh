extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_play_pressed() -> void:
	GlobalSettings.reset_game() # Сбрасывает жизни до 3 перед началом игры
	get_tree().change_scene_to_file("res://game_map.tscn")
