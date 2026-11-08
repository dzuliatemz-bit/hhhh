extends Node

var current_location: String = ""        # Какую локацию выбрал на карте
var is_wearing_safety_gear: bool = false # Надел ли безопасную одежду?

# Новые переменные для системы жизней
var max_lives: int = 3
var current_lives: int = 3

# Функция для сброса игры к началу
func reset_game() -> void:
	current_lives = max_lives
	current_location = ""
	is_wearing_safety_gear = false
