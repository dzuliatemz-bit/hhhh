extends Control

# Экспортируем переменные, чтобы перетащить кнопки мышкой в Инспекторе
@export var play_button: Button
@export var exit_button: Button

func _ready() -> void:
	# Проверяем, не забыл ли ты привязать кнопки в Инспекторе
	if play_button and exit_button:
		play_button.pressed.connect(_on_play_pressed)
		exit_button.pressed.connect(_on_exit_pressed)
	else:
		print("ВНИМАНИЕ: Перетащи кнопки PlayButton и ExitButton в поле скрипта в Инспекторе справа!")

func _on_play_pressed() -> void:
	# Переходим на сцену карты. Убедись, что файл карты называется именно так
	var error = get_tree().change_scene_to_file("res://game_map.tscn")
	if error != OK:
		print("Ошибка загрузки карты! Проверь, что файл называется game_map.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
