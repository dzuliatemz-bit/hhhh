extends Control

@export var title_label: RichTextLabel
@export var text_label: RichTextLabel
@export var options_container: VBoxContainer
@export var character_sprite: TextureRect

var current_location: String = ""

func _ready() -> void:
	if title_label and text_label and options_container and character_sprite:
		current_location = GlobalSettings.current_location
		_setup_wardrobe()
	else:
		print("ОШИБКА: Свяжи узлы в Инспекторе dialogue_scene!")

func _setup_wardrobe() -> void:
	# Сбрасываем выбор перед началом квеста
	GlobalSettings.is_wearing_safety_gear = false
	
	if current_location == "Стройка":
		title_label.text = "Раздевалка: Подготовка к выходу на Стройку"
		text_label.text = "Вы собираетесь выйти на строительную площадку, где работают высотные машины и краны. Что вы наденете?"
		_add_option("Каска повышенной прочности и страховочная привязь", true, "res://icon.svg")
		_add_option("Обычная кепка от солнца и легкие кроссовки", false, "")
		
	elif current_location == "Лаборатория":
		title_label.text = "Раздевалка: Санитарная лаборатория"
		text_label.text = "Вам предстоит переливать агрессивные химикаты. Выберите комплект одежды:"
		_add_option("Химический защитный халат, очки-маска и толстые перчатки", true, "res://icon.svg")
		_add_option("Обычная медицинская форма без маски", false, "")

	elif current_location == "Пожарные":
		title_label.text = "Раздевалка: Пожарная служба"
		text_label.text = "Поступил вызов на тушение склада лакокрасочных материалов. Что берем?"
		_add_option("Боевая одежда пожарного (БОП) и дыхательный аппарат", true, "res://icon.svg")
		_add_option("Обычная рабочая куртка и резиновые сапоги", false, "")

	elif current_location == "Нефтезавод":
		title_label.text = "Раздевалка: Нефтяной завод"
		text_label.text = "Предстоит внутренний осмотр пустого резервуара из-под бензина. Выберите экипировку:"
		_add_option("Антистатический костюм и шланговый противогаз", true, "res://icon.svg")
		_add_option("Стандартная спецовка и обычная пластиковая каска", false, "")

func _add_option(btn_text: String, is_safe: bool, outfit_path: String) -> void:
	var button := Button.new()
	button.text = btn_text
	button.pressed.connect(func():
		# Запоминаем выбор в глобальные настройки
		GlobalSettings.is_wearing_safety_gear = is_safe
		
		# Меняем картинку персонажа, если она есть
		if outfit_path != "":
			character_sprite.texture = load(outfit_path)
			
		# Сразу переключаемся на отдельное НОВОЕ ОКНО ДЕЙСТВИЯ
		get_tree().change_scene_to_file("res://action_scene.tscn")
	)
	options_container.add_child(button)
