extends Control

@export var title_label: RichTextLabel
@export var text_label: RichTextLabel
@export var options_container: VBoxContainer

var current_location: String = ""
var is_safe: bool = false

func _ready() -> void:
	if title_label and text_label and options_container:
		title_label.bbcode_enabled = true
		text_label.bbcode_enabled = true
		
		# Читаем данные из глобальной памяти
		current_location = GlobalSettings.current_location
		is_safe = GlobalSettings.is_wearing_safety_gear
		
		_show_accident_scene()
	else:
		print("ОШИБКА: Свяжи узлы в Инспекторе action_scene!")

# Показываем саму ситуацию выхода на объект
func _show_accident_scene() -> void:
	title_label.text = "[color=yellow]ВЫХОД НА ОБЪЕКТ...[/color]"
	
	if current_location == "Стройка":
		text_label.text = "Персонаж заходит на строительную площадку и идет под машиной для поднятия грузов на высотные здания. Внезапно из-за сильной вибрации механизма сверху срывается тяжелый строительный болт и летит прямо на голову персонажу!"
	elif current_location == "Лаборатория":
		text_label.text = "Персонаж приступает к работе с агрессивной кислотой. Внезапно мерная колба выскальзывает из рук и разбивается, направляя поток брызг прямо на персонажа!"
	elif current_location == "Пожарные":
		text_label.text = "Персонаж заходит в горящий ангар. В ту же секунду крыша позади него рушится, и помещение мгновенно затягивает густым смертоносным угарным газом!"
	elif current_location == "Нефтезавод":
		text_label.text = "Персонаж спускается в пустой бак для осмотра швов. Внутри стоит высокая концентрация паров бензина. Персонаж делает шаг и шаркает подошвой по металлу..."

	var check_btn := Button.new()
	check_btn.text = "Посмотреть последствия"
	check_btn.pressed.connect(_show_final_result)
	options_container.add_child(check_btn)

# Показываем финал: Успех или Смерть
func _show_final_result() -> void:
	for child in options_container.get_children():
		child.queue_free()
		
	if is_safe:
		title_label.text = "[color=green]УСПЕШНО! БЕЗОПАСНОСТЬ СОБЛЮДЕНА[/color]"
		
		if current_location == "Стройка":
			text_label.text = "Надежная каска повышенной прочности выдержала страшный удар! Болт отскочил в сторону. Персонаж успешно завершил инспекцию стройки."
		elif current_location == "Лаборатория":
			text_label.text = "Специальный халат, очки-маска и толстые перчатки защитили тело. Кислота не попала на кожу. Вы в полной безопасности!"
		elif current_location == "Пожарные":
			text_label.text = "Боевой термокостюм защитил от жара, а баллон с воздухом позволил спокойно дышать в дыму. Вы нашли выход и спаслись."
		elif current_location == "Нефтезавод":
			text_label.text = "Антистатическая обувь не создала искру, а шланговый противогаз защитил дыхание. Осмотр завершен без происшествий."

		var map_btn := Button.new()
		map_btn.text = "Вернуться на карту"
		map_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://game_map.tscn"))
		options_container.add_child(map_btn)
	else:
		title_label.text = "[color=red]ИГРА ОКОНЧЕНА (НЕСЧАСТНЫЙ СЛУЧАЙ)[/color]"
		
		# ОТНИМАЕМ ОДНУ ЖИЗНЬ
		GlobalSettings.current_lives -= 1
		
		# Описание смертей
		var death_text = ""
		if current_location == "Стройка":
			death_text = "Обычная кепка не защитила голову от падения тяжелого предмета. При ходьбе под машиной для высотных зданий сорвавшийся болт пробил череп. Персонаж погиб."
		elif current_location == "Лаборатория":
			death_text = "Кислота прожгла тонкую домашнюю одежду и попала на незащищенные глаза и кожу. Тяжелейшие ожоги и аварийный исход."
		elif current_location == "Пожарные":
			death_text = "Без дыхательного аппарата в обычной куртке персонаж потерял сознание от угарного газа через 20 секунд и погиб."
		elif current_location == "Нефтезавод":
			death_text = "Обычная обувь вызвала статическую искру. Пары бензина сдетонировали, резервуар разорвало мощнейшим взрывом."

		# Проверяем, остались ли еще попытки
		if GlobalSettings.current_lives > 0:
			text_label.text = "[color=red]СМЕРТЬ: " + death_text + "\n\nУ вас осталась еще попытка![/color]"
			
			var retry_btn := Button.new()
			retry_btn.text = "Попробовать снова (Вернуться на карту)"
			retry_btn.pressed.connect(func(): get_tree().change_scene_to_file("res://game_map.tscn"))
			options_container.add_child(retry_btn)
		else:
			text_label.text = "[color=red]СМЕРТЬ: " + death_text + "\n\n[b]У вас закончились все жизни! Игра полностью проиграна.[/b][/color]"
			
			var restart_btn := Button.new()
			restart_btn.text = "В главное меню (Сброс прогресса)"
			restart_btn.pressed.connect(func(): 
				GlobalSettings.reset_game() # Полностью сбрасываем жизни до 3
				get_tree().change_scene_to_file("res://main_menu.tscn")
			)
			options_container.add_child(restart_btn)
