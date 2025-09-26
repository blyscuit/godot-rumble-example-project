@tool
class_name RumbleControl
extends Control

# A control node for testing a rumble configuration.
# Both a gamepad and handheld variant of a particular rumble can be implemented.
# This provides a simple, single rumble - but may be overridden to do more.

@export var label: String = "Rumble Control":
	set(value):
		label = value
		$Label.text = value

@export_range(0.0, 1.0) var weak_magnitude_factor: float = 1.0
@export_range(0.0, 1.0) var strong_magnitude_factor: float = 1.0

@export_range(0.01, 10.0) var duration: float = 1.0:
	set(value):
		duration = max(value, 0.01)

@export_range(10, 10000) var handheld_duration: int = 100:
	set(value):
		handheld_duration = max(value, 1)

@onready var timer: Timer = $Timer


func _ready() -> void:
	$Button.pressed.connect(_on_button_pressed)


func _get_amount() -> float:
	return $Slider.value


func _on_button_pressed() -> void:
	var amount := _get_amount()
	var weak_magnitude := amount * weak_magnitude_factor
	var strong_magnitude := amount * strong_magnitude_factor

	var gamepads: Array = Input.get_connected_joypads()
	if gamepads.size() > 0:
		for device_index in gamepads:
			# stop any previous rumbling
			Input.stop_joy_vibration(device_index)
			# perform the rumble
			_rumble_gamepad(device_index, weak_magnitude, strong_magnitude)

	elif OS.get_name() == "Android" or OS.get_name() == "iOS":
		_rumble_handheld()


func _rumble_gamepad(device_index: int, weak_magnitude: float, strong_magnitude: float) -> void:
	Input.start_joy_vibration(device_index, weak_magnitude, strong_magnitude, duration)


func _rumble_handheld() -> void:
	Input.vibrate_handheld(handheld_duration)
