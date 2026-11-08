extends Control

@export var stroika_button: Button
@export var lab_button: Button
@export var fire_button: Button
@export var oil_button: Button

# Ссылка на наш новый счетчик жизней на экране
@export var lives_label: Label

func _ready() -> void:
	# Отображаем текущие жизни в виде сердечек
	_update_lives_display()
	
	if stroika_button and lab_button and fire_button and oil_button:
		stroika_button.pressed.connect(func(): _go_to_quest("Стройка"))
		lab_button.pressed.connect(func(): _go_to_quest("Лаборатория"))
		fire_button.pressed.connect(func(): _go_to_quest("Пожарные"))
		oil_button.pressed.connect(func(): _go_to_quest("Нефтезавод"))
	else:
		print("ВНИМАНИЕ: Привяжи все кнопки локаций в Инспекторе!")

func _update_lives_display() -> void:
	if lives_label:
		var hearts = ""
		for i in range(GlobalSettings.current_lives):
			hearts += "❤️"
		
		if hearts == "":
			lives_label.text = "Жизни: 💀 ВЫ ИГРАЛИ"
		else:
			lives_label.text = "Жизни: " + hearts

func _go_to_quest(location_name: String) -> void:
	GlobalSettings.current_location = location_name
	get_tree().change_scene_to_file("res://dialogue_scene.tscn")
