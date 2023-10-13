extends Control

signal dice_roll_pressed(arg1)

onready var dice1 = get_node("Container/ColorRect/Label")
onready var dice2 = get_node("Container/ColorRect2/Label")
onready var dice3 = get_node("Container/ColorRect3/Label")
onready var dice4 = get_node("Container/ColorRect4/Label")
onready var dice_rolls = [dice1, dice2, dice3, dice4]
onready var dice_roll1 = preload("res://SoundFX/dice_rolled_default.wav")
onready var dice_roll2 = preload("res://SoundFX/dice_rolled_fast.wav")
onready var dice_roll3 = preload("res://SoundFX/dice_rolled_slow.wav")
onready var dice_soundFX = [dice_roll1, dice_roll2, dice_roll3]

func _ready():
	set_dice_text_empty()
	$".".hide()
	disable_dice_roll()

func set_dice_text_empty():
	for i in range(4):
		dice_rolls[i].set_text("0")
	$Label.set_text("Trenutno na potezu:\n\nIGRAC NIJE ODABRAN!")

func roll_dice():
	var number_rolled = 0
	$Button/Label.set_text("Bacam\nkockice...")
	yield(get_tree().create_timer(.75), "timeout")
	for i in range(4):
		var one_dice_roll = randi()%2
		dice_rolls[i].set_text(str(one_dice_roll))
		number_rolled += one_dice_roll
	$Button/Label.set_text(str(number_rolled))
	emit_signal("dice_roll_pressed", number_rolled)

func enable_dice_roll():
	$Button.disabled = false
	$Button/Label.set_text("BACI\nKOCKICE")

func disable_dice_roll():
	$Button.disabled = true

func white_to_move():
	$Label.set_text("Trenutno na potezu:\n\nBIJELI IGRAC")

func black_to_move():
	$Label.set_text("Trenutno na potezu:\n\nCRNI IGRAC")

func _on_Button_pressed():
	roll_dice()
	play_dice_roll_sound()
	disable_dice_roll()

func play_dice_roll_sound():
	$SoundFXPlayer2.volume_db = -7.5
	$SoundFXPlayer2.set_stream(dice_soundFX[randi()%3])
	$SoundFXPlayer2.play()
