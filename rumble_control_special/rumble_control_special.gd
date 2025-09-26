@tool
extends RumbleControl
# An example of rumble control with a custom rumble pattern.
# A series of three weak-then-strong rumbles.


func _rumble_gamepad(device_index: int, weak_magnitude: float, strong_magnitude: float) -> void:
	var step_duration := duration / 9.0

	for _i in range(3):
		Input.start_joy_vibration(device_index, weak_magnitude * 0.0, strong_magnitude, step_duration)
		timer.start(step_duration)
		await timer.timeout

		Input.start_joy_vibration(device_index, weak_magnitude, strong_magnitude * 0.0, step_duration)
		timer.start(step_duration * 2.0)
		await timer.timeout


func _rumble_handheld() -> void:
	# step_duration is in ms, step_duration_timer is in seconds
	var step_duration: int = int((handheld_duration - 250) / 9)
	var step_duration_timer: float = handheld_duration / 9000.0

	for _i in range(3):
		Input.vibrate_handheld(step_duration)
		timer.start(step_duration_timer)
		await timer.timeout

		Input.vibrate_handheld(step_duration * 2)
		timer.start(step_duration_timer * 1.5)
		await timer.timeout
