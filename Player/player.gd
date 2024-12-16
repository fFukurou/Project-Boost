extends RigidBody3D

## How much vertical force to apply when moving.
@export_range(750.0, 3000.0) var thrust: float = 1000.0

@export var torque_thrust: float = 100

var is_transitioning: bool = false

@onready var explosion_audio: AudioStreamPlayer = $ExplosionAudio
@onready var success_audio: AudioStreamPlayer = $SuccessAudio
@onready var rocket_audio: AudioStreamPlayer3D = $RocketAudio
@onready var booster_particles: GPUParticles3D = $BoosterParticles
@onready var right_booster_particles: GPUParticles3D = $RightBoosterParticles
@onready var left_booster_particles: GPUParticles3D = $LeftBoosterParticles
@onready var explosion_particles: GPUParticles3D = $ExplosionParticles
@onready var success_particles: GPUParticles3D = $SuccessParticles


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thrust)
		booster_particles.emitting = true
		if rocket_audio.playing == false:
			rocket_audio.play()
	else:
		booster_particles.emitting = false
		rocket_audio.stop()
		
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0, 0.0, torque_thrust * delta))
		right_booster_particles.emitting = true
	else:
		right_booster_particles.emitting = false
		
		
	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0.0, 0.0, -torque_thrust * delta))
		left_booster_particles.emitting = true
	else:
		left_booster_particles.emitting = false
		
	if Input.is_action_pressed("restart"):
		get_tree().reload_current_scene()
		
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		
	if Input.is_action_just_pressed("jumpTo1"):
		get_tree().change_scene_to_file("res://Level/level1.tscn")
		
	if Input.is_action_just_pressed("jumpTo2"):
		get_tree().change_scene_to_file("res://Level/level2.tscn")
		
	if Input.is_action_just_pressed("jumpTo3"):
		get_tree().change_scene_to_file("res://Level/level3.tscn")
		
	if Input.is_action_just_pressed("jumpTo4"):
		get_tree().change_scene_to_file("res://Level/level4.tscn")
		
	if Input.is_action_just_pressed("jumpTo5"):
		get_tree().change_scene_to_file("res://Level/level5.tscn")
		
	if Input.is_action_just_pressed("jumpTo6"):
		get_tree().change_scene_to_file("res://Level/level6.tscn")
		
	if Input.is_action_just_pressed("jumpTo7"):
		get_tree().change_scene_to_file("res://Level/level7.tscn")
		
	if Input.is_action_just_pressed("jumpTo8"):
		get_tree().change_scene_to_file("res://Level/level8.tscn")
		
	if Input.is_action_just_pressed("jumpTo9"):
		get_tree().change_scene_to_file("res://Level/level9.tscn")
		
	if Input.is_action_just_pressed("jumpTo10"):
		get_tree().change_scene_to_file("res://Level/level10.tscn")
		
	


func _on_body_entered(body: Node) -> void:
	if is_transitioning == false:
		if "Goal" in body.get_groups():
			complete_level(body.file_path)
			
		elif "Hazard" in body.get_groups():
			crash_sequence()
			

func crash_sequence() -> void:
	print("You died...")
	explosion_particles.emitting = true
	explosion_audio.play()
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(1.0)
	tween.tween_callback(get_tree().reload_current_scene)
	

func complete_level(next_level_file: String) -> void:
	print("Level Completed!")
	success_particles.emitting = true
	success_audio.play()
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(2.0)
	tween.tween_callback(get_tree().change_scene_to_file.bind(next_level_file))
