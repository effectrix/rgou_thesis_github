extends Spatial

signal field_pressed
signal field_released
signal field_wStart_pressed
signal field_bStart_pressed
signal field_battle_pressed
signal field_wFinish_pressed
signal field_bFinish_pressed
signal field_wExit_pressed
signal field_bExit_pressed

var isFieldTakenW = false
var isFieldTakenB = false

onready var fieldMoveValid = preload("res://Materials/field_eligible_MAT.tres")
onready var fieldMoveInvalid = preload("res://Materials/field_ineligible_MAT.tres")
onready var fieldDefaultMAT = preload("res://Materials/field_default_MAT.tres")
onready var fieldRosettaMAT = preload("res://Materials/field_rosetta_MAT.tres")

func _ready():
	$Spatial.hide()
	pass

func field_move_valid():
	$Spatial.show()
	$Spatial/Area.show()
	$Spatial/CSGBox.set_material(fieldMoveValid)

func field_move_invalid():
	$Spatial.show()
	$Spatial/Area.hide()
	$Spatial/CSGBox.set_material(fieldMoveInvalid)

func field_set_rosetta_mat():
	$CSGBox.set_material(fieldRosettaMAT)

func field_hide():
	$Spatial.hide()

func _on_Area_mouse_entered():
	field_hide()
	emit_signal("field_pressed")
	emit_signal("field_wStart_pressed")
	emit_signal("field_bStart_pressed")
	emit_signal("field_battle_pressed")
	emit_signal("field_wFinish_pressed")
	emit_signal("field_bFinish_pressed")
	emit_signal("field_wExit_pressed")
	emit_signal("field_bExit_pressed")

func _on_Area_mouse_exited():
	field_hide()
	emit_signal("field_released")
