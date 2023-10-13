extends Spatial

signal piece_pressed
signal piece_released

onready var white_default_MAT = preload("res://Materials/white_default_MAT.tres")
onready var white_default_v2_MAT = preload("res://Materials/white_default_v2_MAT.tres")
onready var white_inactive_MAT = preload("res://Materials/white_inactive_MAT.tres")
onready var white_inactive_v2_MAT = preload("res://Materials/white_inactive_v2_MAT.tres")
onready var black_default_MAT = preload("res://Materials/black_default_MAT.tres")
onready var black_default_v2_MAT = preload("res://Materials/black_default_v2_MAT.tres")
onready var black_inactive_MAT = preload("res://Materials/black_inactive_MAT.tres")
onready var black_inactive_v2_MAT = preload("res://Materials/black_inactive_v2_MAT.tres")
onready var piece_move_elig_MAT = preload("res://Materials/piece_move_eligible_MAT.tres")
onready var piece_move_inelig_MAT = preload("res://Materials/piece_move_ineligible_MAT.tres")

onready var mesh_simple = preload("res://Models/default_piece.obj")
onready var mesh_complex = preload("res://Models/default_piece_v2.obj")

onready var MovePieceTween = get_node("Tween")

onready var move_piece_sound1 = preload("res://SoundFX/piece_move_orig.wav")
onready var move_piece_sound2 = preload("res://SoundFX/piece_move_slow.wav")
onready var move_piece_sound3 = preload("res://SoundFX/piece_move_fast.wav")
onready var remove_piece_sound = preload("res://SoundFX/piece_removed.wav")
onready var select_piece_sound = preload("res://SoundFX/piece_selected.wav")
onready var playable_sound_FX = [move_piece_sound1, move_piece_sound2, move_piece_sound3]

onready var simple_mesh = true
onready var currentPos = -1
onready var currentColor = "white"
onready var isInGame = true
onready var touchCounter = 0
onready var isMoveEligible = false


func set_piece_white_active():
	$Area.show()
	if simple_mesh == true:
		$MeshInstance.set_material_override(white_default_MAT)
	else:
		$MeshInstance.set_material_override(white_default_v2_MAT)

func set_piece_white_inactive():
	$Area.hide()
	if simple_mesh == true:
		$MeshInstance.set_material_override(white_inactive_MAT)
	else:
		$MeshInstance.set_material_override(white_inactive_v2_MAT)

func set_piece_black_active():
	$Area.show()
	if simple_mesh == true:
		$MeshInstance.set_material_override(black_default_MAT)
	else:
		$MeshInstance.set_material_override(black_default_v2_MAT)

func set_piece_black_inactive():
	$Area.hide()
	if simple_mesh == true:
		$MeshInstance.set_material_override(black_inactive_MAT)
	else:
		$MeshInstance.set_material_override(black_inactive_v2_MAT)

func set_piece_move_eligible():
	$MeshInstance.set_material_override(piece_move_elig_MAT)

func set_piece_move_ineligible():
	$MeshInstance.set_material_override(piece_move_inelig_MAT)

func _on_Area_mouse_entered():
	touchCounter += 1
	if touchCounter == 1:
		emit_signal("piece_pressed")
		play_select_piece_sound()
	elif touchCounter >= 2:
		touchCounter = 0
		emit_signal("piece_released")

func _on_Area_mouse_exited():
	emit_signal("piece_released")
	touchCounter = 0
	if currentColor == "white":
		set_piece_white_active()
	else:
		set_piece_black_active()

func animate_move_piece(selectedPiece, finalPos):
	MovePieceTween.interpolate_property(selectedPiece, "translation", selectedPiece.translation, 
		finalPos.translation, 0.2, Tween.TRANS_SINE, Tween.EASE_OUT)
	MovePieceTween.start()
	play_move_piece_sound()

func play_move_piece_sound():
	$SoundFXPlayer.set_stream(playable_sound_FX[randi()%3])
	$SoundFXPlayer.play()

func play_remove_piece_sound():
	$SoundFXPlayer.set_stream(remove_piece_sound)
	$SoundFXPlayer.play()

func play_select_piece_sound():
	$SoundFXPlayer.set_stream(select_piece_sound)
	$SoundFXPlayer.play()

func change_mesh_simple():
	$MeshInstance.set_mesh(mesh_simple)
	$MeshInstance.set_scale(Vector3(0.85, 0.85, 0.85))
	simple_mesh = true

func change_mesh_complex():
	$MeshInstance.set_mesh(mesh_complex)
	$MeshInstance.set_scale(Vector3(0.6, 0.6, 0.6))
	simple_mesh = false

