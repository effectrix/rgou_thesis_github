extends Spatial

enum {WHITE_MOVE , BLACK_MOVE}
var state
var selectedPiece = 0
var playerPicked = false
var rolledNumber = 0
var bonusRoll = false
var white_pieces_playing = 6
var black_pieces_playing = 6
var materials_v2 = false
var piece_moved = false
var new_game = false

onready var board_simple = preload("res://Models/board_default_v3.obj")
onready var board_complex = preload("res://Models/ploca_druga_varijanta.obj")
onready var board_MAT1 = preload("res://Materials/board_red_MAT.tres")
onready var board_MAT2 = preload("res://Materials/board_regular_MAT.tres")
onready var board_MAT3 = preload("res://Materials/board_rosetta_MAT.tres")
onready var board_v2_MAT = preload("res://Materials/board_v2_MAT.tres")

onready var music1 = preload("res://Music/music1.ogg")
onready var music2 = preload("res://Music/music2.ogg")
onready var music3 = preload("res://Music/music3.ogg")
onready var music4 = preload("res://Music/music4.ogg")
onready var music5 = preload("res://Music/music5.ogg")
onready var player_wins = preload("res://SoundFX/player_wins_v2.wav")
onready var playableMusic = [music1, music2, music3, music4, music5]

func _ready():
	randomize()
	rolledNumber = 0
	initialize_fields()
	yield(get_tree().create_timer(1.5), "timeout")
	initialize_pieces()
	initialize_music()
	play_music()
	yield(get_tree().create_timer(1), "timeout")
	$DiceRoll.show()
	yield(get_tree().create_timer(.5), "timeout")
	initialize_dice()
	print("\n= = = = = = = = = = = = = = = = = =")
	print("Starting new game...")

func initialize_dice():
	$DiceRoll.connect("dice_roll_pressed", get_node("."), "_on_dice_roll_pressed")
	show_dice_roll()

func initialize_music():
	playableMusic.shuffle()
	$MusicPlayer.set_stream(playableMusic.back())
	
func play_music():
	$MusicPlayer.volume_db = -15
	$MusicPlayer.play()
	print("Currently playing:", playableMusic.back())

func show_dice_roll():
	$DiceRoll.enable_dice_roll()

func pick_player():
	playerPicked = true
	var decide_player = randi()%2
	if decide_player == 0:
		state = WHITE_MOVE
		print("white player selected")
		$DiceRoll.white_to_move()
		white_piece_set_active()
	elif decide_player == 1:
		state = BLACK_MOVE
		print("black player selected")
		$DiceRoll.black_to_move()
		black_piece_set_active()

func update_field_status():
	for i in range(0, $Fields/WhiteStart.get_child_count()):
		$Fields/WhiteStart.get_child(i).isFieldTakenW = false
		$Fields/BlackStart.get_child(i).isFieldTakenB = false
	for i in range(0, $Fields/Battle.get_child_count()):
		$Fields/Battle.get_child(i).isFieldTakenW = false
		$Fields/Battle.get_child(i).isFieldTakenB = false
	for i in range(0, $Fields/WhiteFinish.get_child_count()):
		$Fields/WhiteFinish.get_child(i).isFieldTakenW = false
		$Fields/BlackFinish.get_child(i).isFieldTakenB = false
	for i in range(0, $WhitePiece.get_child_count()):
		var whiteCheck = $WhitePiece.get_child(i).currentPos
		if whiteCheck == -1:
			pass
		elif whiteCheck >= 0 and whiteCheck <= 3:
			$Fields/WhiteStart.get_child(whiteCheck).isFieldTakenW = true
		elif whiteCheck >= 4 and whiteCheck <= 11:
			$Fields/Battle.get_child(whiteCheck - 4).isFieldTakenW = true
		elif whiteCheck >= 12 and whiteCheck <= 13:
			$Fields/WhiteFinish.get_child(whiteCheck - 12).isFieldTakenW = true
		elif whiteCheck >= 14:
			pass
	for i in range(0, $BlackPiece.get_child_count()):
		var blackCheck = $BlackPiece.get_child(i).currentPos
		if blackCheck == -1:
			pass
		elif blackCheck >= 0 and blackCheck <= 3:
			$Fields/BlackStart.get_child(blackCheck).isFieldTakenB = true
		elif blackCheck >= 4 and blackCheck <= 11:
			$Fields/Battle.get_child(blackCheck - 4).isFieldTakenB = true
		elif blackCheck >= 12 and blackCheck <= 13:
			$Fields/BlackFinish.get_child(blackCheck - 12).isFieldTakenB = true
		elif blackCheck >= 14:
			pass

func white_piece_set_active():
	for i in range(0, $WhitePiece.get_child_count()):
		if $WhitePiece.get_child(i).isInGame == true:
			$WhitePiece.get_child(i).set_piece_white_active()
		else:
			pass

func white_piece_set_inactive():
	for i in range(0, $WhitePiece.get_child_count()):
		if $WhitePiece.get_child(i).isInGame == true:
			$WhitePiece.get_child(i).set_piece_white_inactive()
		else:
			pass

func black_piece_set_active():
	for i in range(0, $BlackPiece.get_child_count()):
		if $BlackPiece.get_child(i).isInGame == true:
			$BlackPiece.get_child(i).set_piece_black_active()
		else:
			pass

func black_piece_set_inactive():
	for i in range(0, $BlackPiece.get_child_count()):
		if $BlackPiece.get_child(i).isInGame == true:
			$BlackPiece.get_child(i).set_piece_black_inactive()
		else:
			pass

func switch_player():
	yield(get_tree().create_timer(.5), "timeout")
	if state == WHITE_MOVE:
		black_piece_set_active()
		white_piece_set_inactive()
		print("black player selected")
		state = BLACK_MOVE
		$DiceRoll.black_to_move()
	elif state == BLACK_MOVE:
		white_piece_set_active()
		black_piece_set_inactive()
		print("white player selected")
		state = WHITE_MOVE
		$DiceRoll.white_to_move()

func initialize_pieces():
	for i in range(0, $WhitePiece.get_child_count()):
		$WhitePiece.get_child(i).connect("piece_pressed", get_node("."), "_on_piece_pressed", [i])
		$WhitePiece.get_child(i).connect("piece_released", get_node("."), "_on_piece_released", [i])
		$BlackPiece.get_child(i).connect("piece_pressed", get_node("."), "_on_piece_pressed", [i])
		$BlackPiece.get_child(i).connect("piece_released", get_node("."), "_on_piece_released", [i])
	var random_piece_pick = randi()%2
	if random_piece_pick == 0:
		initialize_white_pieces()
		yield(get_tree().create_timer(.5), "timeout")
		initialize_black_pieces()
	elif random_piece_pick == 1:
		initialize_black_pieces()
		yield(get_tree().create_timer(.5), "timeout")
		initialize_white_pieces()

func initialize_white_pieces():
	for i in range(0, $WhitePiece.get_child_count()):
		$WhitePiece.get_child(i).set_piece_white_inactive()
	for i in range(0, $WhitePiece.get_child_count()):
		$WhitePiece.get_child(i).animate_move_piece($WhitePiece.get_child(i), $EnterPositions/WhiteEnter.get_child(i))
		yield(get_tree().create_timer(rand_range(.1, .3)), "timeout")

func initialize_black_pieces():
	for i in range(0, $BlackPiece.get_child_count()):
		$BlackPiece.get_child(i).set_piece_black_inactive()
		$BlackPiece.get_child(i).currentColor = "black"
	for i in range(0, $BlackPiece.get_child_count()):
		$BlackPiece.get_child(i).animate_move_piece($BlackPiece.get_child(i), $EnterPositions/BlackEnter.get_child(i))
		yield(get_tree().create_timer(rand_range(.1, .3)), "timeout")

func initialize_fields():
	$Fields.show()
	for i in range(0, $Fields/WhiteStart.get_child_count()):
		$Fields/WhiteStart.get_child(i).connect("field_wStart_pressed", get_node("."), "_on_field_wStart_pressed", [i])
		$Fields/WhiteStart.get_child(i).connect("field_released", get_node("."), "_on_field_released", [i])
		$Fields/BlackStart.get_child(i).connect("field_bStart_pressed", get_node("."), "_on_field_bStart_pressed", [i])
		$Fields/BlackStart.get_child(i).connect("field_released", get_node("."), "_on_field_released", [i])
	for i in range(0, $Fields/Battle.get_child_count()):
		$Fields/Battle.get_child(i).connect("field_battle_pressed", get_node("."), "_on_field_battle_pressed", [i])
		$Fields/Battle.get_child(i).connect("field_released", get_node("."), "_on_field_released", [i])
	for i in range(0, $Fields/WhiteFinish.get_child_count()):
		$Fields/WhiteFinish.get_child(i).connect("field_wFinish_pressed", get_node("."), "_on_field_wFinish_pressed", [i])
		$Fields/WhiteFinish.get_child(i).connect("field_released", get_node("."), "_on_field_released", [i])
		$Fields/BlackFinish.get_child(i).connect("field_bFinish_pressed", get_node("."), "_on_field_bFinish_pressed", [i])
		$Fields/BlackFinish.get_child(i).connect("field_released", get_node("."), "_on_field_released", [i])
	$Fields/WhiteExit.get_child(0).connect("field_wExit_pressed", get_node("."), "_on_field_wExit_pressed")
	$Fields/BlackExit.get_child(0).connect("field_bExit_pressed", get_node("."), "_on_field_bExit_pressed")

func _on_field_released(_i):
	pass

func _on_field_wStart_pressed(i):
	white_piece_set_inactive()
	piece_moved = true
	yield(get_tree().create_timer(.5), "timeout")
	var positionW = $WhitePiece.get_child(selectedPiece).currentPos
	$WhitePiece.get_child(selectedPiece).animate_move_piece($WhitePiece.get_child(selectedPiece), 
		$Fields/WhiteStart.get_child(i))
	yield(get_tree().create_timer(.5), "timeout")
	$Fields/WhiteStart.get_child(i).isFieldTakenW = true
	if i - rolledNumber >= 0:
		$Fields/WhiteStart.get_child(i - rolledNumber).isFieldTakenW = false
		$WhitePiece.get_child(selectedPiece).currentPos = i
	else:
		$WhitePiece.get_child(selectedPiece).currentPos = i
	if i == 3:
		bonusRoll = true
	update_field_status()
	yield(get_tree().create_timer(.5), "timeout")
	$DiceRoll.enable_dice_roll()

func _on_field_bStart_pressed(i):
	black_piece_set_inactive()
	piece_moved = true
	yield(get_tree().create_timer(.5), "timeout")
	var positionB = $BlackPiece.get_child(selectedPiece).currentPos
	$BlackPiece.get_child(selectedPiece).animate_move_piece($BlackPiece.get_child(selectedPiece), 
		$Fields/BlackStart.get_child(i))
	yield(get_tree().create_timer(.5), "timeout")
	$Fields/BlackStart.get_child(i).isFieldTakenB = true
	if i - rolledNumber >= 0:
		$Fields/BlackStart.get_child(i - rolledNumber).isFieldTakenB = false
		$BlackPiece.get_child(selectedPiece).currentPos = i
	else:
		$BlackPiece.get_child(selectedPiece).currentPos = $Fields/BlackStart.get_child(i).get_index()
		
	if i == 3:
		bonusRoll = true
	yield(get_tree().create_timer(.5), "timeout")
	$DiceRoll.enable_dice_roll()

func _on_field_battle_pressed(i):
	var backwardsField = i - rolledNumber
	piece_moved = true
	if state == WHITE_MOVE:
		white_piece_set_inactive()
		yield(get_tree().create_timer(.5), "timeout")
		$WhitePiece.get_child(selectedPiece).animate_move_piece($WhitePiece.get_child(selectedPiece), 
			$Fields/Battle.get_child(i))
		$Fields/Battle.get_child(i).isFieldTakenW = true
		if $Fields/Battle.get_child(i).isFieldTakenB == true:
			for j in range(6):
				if $BlackPiece.get_child(j).currentPos == (i + 4):
					$BlackPiece.get_child(j).animate_move_piece($BlackPiece.get_child(j), 
						$EnterPositions/BlackEnter.get_child(j))
					$BlackPiece.get_child(j).currentPos = -1
					$Fields/Battle.get_child(i).isFieldTakenB = false
					$BlackPiece.get_child(j).play_remove_piece_sound()
				else:
					pass
		else:
			pass
		if backwardsField < 0:
			$Fields/WhiteStart.get_child(abs(backwardsField + 4)).isFieldTakenW = false
		else:
			$Fields/Battle.get_child(backwardsField).isFieldTakenW = false
		$WhitePiece.get_child(selectedPiece).currentPos = i + 4
		if i == 3:
			bonusRoll = true
		yield(get_tree().create_timer(.5), "timeout")
		$DiceRoll.enable_dice_roll()

	elif state == BLACK_MOVE:
		black_piece_set_inactive()
		yield(get_tree().create_timer(.5), "timeout")
		$BlackPiece.get_child(selectedPiece).animate_move_piece($BlackPiece.get_child(selectedPiece), 
			$Fields/Battle.get_child(i))
		$Fields/Battle.get_child(i).isFieldTakenB = true
		if $Fields/Battle.get_child(i).isFieldTakenW == true:
			for j in range(6):
				if $WhitePiece.get_child(j).currentPos == (i + 4):
					$WhitePiece.get_child(j).animate_move_piece($WhitePiece.get_child(j), 
						$EnterPositions/WhiteEnter.get_child(j))
					$WhitePiece.get_child(j).currentPos = -1
					$Fields/Battle.get_child(i).isFieldTakenW = false
					$WhitePiece.get_child(j).play_remove_piece_sound()
				else:
					pass
		else:
			pass
		if backwardsField < 0:
			$Fields/BlackStart.get_child(abs(backwardsField + 4)).isFieldTakenB = false
		else:
			$Fields/Battle.get_child(backwardsField).isFieldTakenB = false
		$BlackPiece.get_child(selectedPiece).currentPos = i + 4
		if i == 3:
			bonusRoll = true
		yield(get_tree().create_timer(.5), "timeout")
		$DiceRoll.enable_dice_roll()

func _on_field_wFinish_pressed(i):
	white_piece_set_inactive()
	piece_moved = true
	var positionW = $WhitePiece.get_child(selectedPiece).currentPos
	yield(get_tree().create_timer(.5), "timeout")
	$WhitePiece.get_child(selectedPiece).animate_move_piece($WhitePiece.get_child(selectedPiece), 
		$Fields/WhiteFinish.get_child(i))
	$Fields/WhiteFinish.get_child(i).isFieldTakenW = true
	if positionW < 12:
		$Fields/Battle.get_child(positionW - 4).isFieldTakenW = false
	else:
		$Fields/WhiteFinish.get_child(positionW - 4).isFieldTakenW = false
	$WhitePiece.get_child(selectedPiece).currentPos = i + 12
	if i == 1:
		bonusRoll = true
	yield(get_tree().create_timer(.5), "timeout")
	$DiceRoll.enable_dice_roll()

func _on_field_bFinish_pressed(i):
	black_piece_set_inactive()
	piece_moved = true
	var positionB = $BlackPiece.get_child(selectedPiece).currentPos
	yield(get_tree().create_timer(.5), "timeout")
	$BlackPiece.get_child(selectedPiece).animate_move_piece($BlackPiece.get_child(selectedPiece), 
		$Fields/BlackFinish.get_child(i))
	$Fields/BlackFinish.get_child(i).isFieldTakenB = true
	if positionB < 12:
		$Fields/Battle.get_child(positionB - 4).isFieldTakenB = false
	else:
		$Fields/BlackFinish.get_child(0).isFieldTakenB = false
	$BlackPiece.get_child(selectedPiece).currentPos = i + 12
	if i == 1:
		bonusRoll = true
	yield(get_tree().create_timer(.5), "timeout")
	$DiceRoll.enable_dice_roll()

func _on_field_wExit_pressed():
	white_piece_set_inactive()
	piece_moved = true
	var positionW = $WhitePiece.get_child(selectedPiece).currentPos
	if positionW < 12:
		$Fields/Battle.get_child(positionW - 4).isFieldTakenW = false
	else:
		$Fields/WhiteFinish.get_child(positionW - 12).isFieldTakenW = false
	yield(get_tree().create_timer(.5), "timeout")
	$WhitePiece.get_child(selectedPiece).animate_move_piece($WhitePiece.get_child(selectedPiece), 
		$ExitPositions/WhiteExit.get_child(selectedPiece))
	$WhitePiece.get_child(selectedPiece).currentPos = 14
	$WhitePiece.get_child(selectedPiece).isInGame = false
	white_pieces_playing -= 1
	if white_pieces_playing == 0:
		end_game()
	else:
		pass
	$DiceRoll.enable_dice_roll()

func _on_field_bExit_pressed():
	black_piece_set_inactive()
	piece_moved = true
	var positionB = $BlackPiece.get_child(selectedPiece).currentPos
	if positionB < 12:
		$Fields/Battle.get_child(positionB - 4).isFieldTakenB = false
	else:
		$Fields/BlackFinish.get_child(positionB - 12).isFieldTakenB = false
	yield(get_tree().create_timer(.5), "timeout")
	$BlackPiece.get_child(selectedPiece).animate_move_piece($BlackPiece.get_child(selectedPiece), 
		$ExitPositions/BlackExit.get_child(selectedPiece))
	$BlackPiece.get_child(selectedPiece).currentPos = 14
	$BlackPiece.get_child(selectedPiece).isInGame = false
	black_pieces_playing -= 1
	if black_pieces_playing == 0:
		end_game()
	else:
		pass
	$DiceRoll.enable_dice_roll()

func _on_piece_pressed(i):
	selectedPiece = i
	if state == WHITE_MOVE:
		var futurePositionW = $WhitePiece.get_child(i).currentPos + rolledNumber
		if futurePositionW >= 0 and futurePositionW <= 3:
			if $Fields/WhiteStart.get_child(futurePositionW).isFieldTakenW == false:
				$Fields/WhiteStart.get_child(futurePositionW).field_move_valid()
				$WhitePiece.get_child(i).set_piece_move_eligible()
			else:
				$Fields/WhiteStart.get_child(futurePositionW).field_move_invalid()
				$WhitePiece.get_child(i).set_piece_move_ineligible()
		elif futurePositionW >= 4 and futurePositionW <= 11:
			if ($Fields/Battle.get_child(futurePositionW - 4).get_index() == 3 and 
				$Fields/Battle.get_child(futurePositionW - 4).isFieldTakenW == true):
				$Fields/Battle.get_child(futurePositionW - 4).field_move_invalid()
				$WhitePiece.get_child(i).set_piece_move_ineligible()
			elif ($Fields/Battle.get_child(futurePositionW - 4).get_index() == 3 and 
				$Fields/Battle.get_child(futurePositionW - 4).isFieldTakenB == true):
				$Fields/Battle.get_child(futurePositionW - 4).field_move_invalid()
				$WhitePiece.get_child(i).set_piece_move_ineligible()
			elif ($Fields/Battle.get_child(futurePositionW - 4).isFieldTakenW == false or 
				$Fields/Battle.get_child(futurePositionW - 4).isFieldTakenB == true):
				$Fields/Battle.get_child(futurePositionW - 4).field_move_valid()
				$WhitePiece.get_child(i).set_piece_move_eligible()
			else:
				$Fields/Battle.get_child(futurePositionW - 4).field_move_invalid()
				$WhitePiece.get_child(i).set_piece_move_ineligible()
		elif futurePositionW > 11 and futurePositionW < 14:
			if $Fields/WhiteFinish.get_child(futurePositionW - 12).isFieldTakenW == false:
				$Fields/WhiteFinish.get_child(futurePositionW - 12).field_move_valid()
				$WhitePiece.get_child(i).set_piece_move_eligible()
			else:
				$Fields/WhiteFinish.get_child(futurePositionW - 12).field_move_invalid()
				$WhitePiece.get_child(i).set_piece_move_ineligible()
		elif futurePositionW == 14:
			$Fields/WhiteExit.get_child(0).field_move_valid()
			$WhitePiece.get_child(i).set_piece_move_eligible()
		elif futurePositionW > 14:
			$Fields/WhiteExit.get_child(0).field_move_invalid()
			$WhitePiece.get_child(i).set_piece_move_ineligible()
	elif state == BLACK_MOVE:
		var futurePositionB = $BlackPiece.get_child(i).currentPos + rolledNumber
		if futurePositionB >= 0 and futurePositionB < 4:
			if $Fields/BlackStart.get_child(futurePositionB).isFieldTakenB == false:
				$Fields/BlackStart.get_child(futurePositionB).field_move_valid()
				$BlackPiece.get_child(i).set_piece_move_eligible()
			else:
				$Fields/BlackStart.get_child(futurePositionB).field_move_invalid()
				$BlackPiece.get_child(i).set_piece_move_ineligible()
		elif futurePositionB > 3 and futurePositionB < 12:
			if ($Fields/Battle.get_child(futurePositionB - 4).get_index() == 3 and 
				$Fields/Battle.get_child(futurePositionB - 4).isFieldTakenW == true):
				$Fields/Battle.get_child(futurePositionB - 4).field_move_invalid()
				$BlackPiece.get_child(i).set_piece_move_ineligible()
			elif ($Fields/Battle.get_child(futurePositionB - 4).get_index() == 3 and 
				$Fields/Battle.get_child(futurePositionB - 4).isFieldTakenB == true):
				$Fields/Battle.get_child(futurePositionB - 4).field_move_invalid()
				$BlackPiece.get_child(i).set_piece_move_ineligible()
			elif ($Fields/Battle.get_child(futurePositionB - 4).isFieldTakenB == false or 
				$Fields/Battle.get_child(futurePositionB - 4).isFieldTakenW == true):
				$Fields/Battle.get_child(futurePositionB - 4).field_move_valid()
				$BlackPiece.get_child(i).set_piece_move_eligible()
			else:
				$Fields/Battle.get_child(futurePositionB - 4).field_move_invalid()
				$BlackPiece.get_child(i).set_piece_move_ineligible()
		elif futurePositionB > 11 and futurePositionB < 14:
			if $Fields/BlackFinish.get_child(futurePositionB - 12).isFieldTakenB == false:
				$Fields/BlackFinish.get_child(futurePositionB - 12).field_move_valid()
				$BlackPiece.get_child(i).set_piece_move_eligible()
			else:
				$Fields/BlackFinish.get_child(futurePositionB - 12).field_move_invalid()
				$BlackPiece.get_child(i).set_piece_move_ineligible()
		elif futurePositionB == 14:
			$Fields/BlackExit.get_child(0).field_move_valid()
			$BlackPiece.get_child(i).set_piece_move_eligible()
		elif futurePositionB > 14:
			$Fields/BlackExit.get_child(0).field_move_invalid()
			$BlackPiece.get_child(i).set_piece_move_ineligible()

func _on_piece_released(i):
	if state == WHITE_MOVE:
		var futurePosition = $WhitePiece.get_child(i).currentPos + rolledNumber
		if futurePosition >= 0 and futurePosition < 4:
			$Fields/WhiteStart.get_child(futurePosition).field_hide()
		elif futurePosition > 3 and futurePosition < 12:
			$Fields/Battle.get_child(futurePosition - 4).field_hide()
		elif futurePosition > 11 and futurePosition < 14:
			$Fields/WhiteFinish.get_child(futurePosition - 12).field_hide()
		elif futurePosition == 14:
			$Fields/WhiteExit.get_child(0).field_hide()
		elif futurePosition > 14:
			$Fields/WhiteExit.get_child(0).field_hide()
	elif state == BLACK_MOVE:
		var futurePosition = $BlackPiece.get_child(i).currentPos + rolledNumber
		if futurePosition >= 0 and futurePosition < 4:
			$Fields/BlackStart.get_child(futurePosition).field_hide()
		elif futurePosition > 3 and futurePosition < 12:
			$Fields/Battle.get_child(futurePosition - 4).field_hide()
		elif futurePosition > 11 and futurePosition < 14:
			$Fields/BlackFinish.get_child(futurePosition - 12).field_hide()
		elif futurePosition == 14:
			$Fields/BlackExit.get_child(0).field_hide()
		elif futurePosition > 14:
			$Fields/BlackExit.get_child(0).field_hide()

func debug_field_status():
	print("\n")
	print("= = = = = = = = = = = = = = = =")
	print("White Start Fields Status:")
	for i in range(0, $Fields/WhiteStart.get_child_count()):
		print("White Start ", i, ": ", $Fields/WhiteStart.get_child(i).isFieldTakenW)
	print("Black Start Fields Status:")
	for i in range(0, $Fields/BlackStart.get_child_count()):
		print("Black Start ", i, ": ", $Fields/BlackStart.get_child(i).isFieldTakenB)
	print("Battle Fields Status:")
	for i in range(0, $Fields/Battle.get_child_count()):
		print("Battle White ", i, ": ", $Fields/Battle.get_child(i).isFieldTakenW)
		print("Battle Black ", i, ": ", $Fields/Battle.get_child(i).isFieldTakenB)
	print("White Finish Fields Status:")
	for i in range(0, $Fields/WhiteFinish.get_child_count()):
		print("White Finish ", i, ": ", $Fields/WhiteFinish.get_child(i).isFieldTakenW)
	print("Black Finish Fields Status:")
	for i in range(0, $Fields/BlackFinish.get_child_count()):
		print("Black Finish", i, ": ", $Fields/BlackFinish.get_child(i).isFieldTakenB)
	print("\n")

func debug_piece_status():
	print("\n")
	print("White Piece Status:")
	for i in range(0, $WhitePiece.get_child_count()):
		print("White Piece Current Position :", $WhitePiece.get_child(i).currentPos)
	print("Black Piece Status")
	for i in range(0, $BlackPiece.get_child_count()):
		print("Black Piece Current Position :", $BlackPiece.get_child(i).currentPos)
	print("\n")

func _on_dice_roll_pressed(number_rolled):
	yield(get_tree().create_timer(.5), "timeout")
	piece_moved = false
	rolledNumber = number_rolled
	if bonusRoll == true:
		bonusRoll = false
		if rolledNumber == 0:
			print("Bonus Roll! Rolled number is zero")
			$DiceRoll/Label.set_text("Dobiveni broj je nula!")
			yield(get_tree().create_timer(2), "timeout")
			$DiceRoll/Label.set_text("")
			if playerPicked == false:
				print("Bonus Roll! Rolled number was zero and player wasn't picked yet")
				$DiceRoll.enable_dice_roll()
			elif playerPicked == true:
				print("Bonus Roll! Rolled number was zero and player was already picked")
				$DiceRoll.enable_dice_roll()
		elif rolledNumber > 0:
			print("Bonus Roll! Rolled number was greater than zero")
			if state == WHITE_MOVE:
				print("Bonus Roll! Rolled number was greater than zero and it is white's turn")
				white_piece_set_active()
			elif state == BLACK_MOVE:
				print("Bonus Roll! Rolled number was greater than zero and it is black's turn")
				black_piece_set_active()
	else:
		if rolledNumber == 0:
			print("Rolled number is zero")
			$DiceRoll/Label.set_text("Dobiveni broj je 0!")
			yield(get_tree().create_timer(3), "timeout")
			$DiceRoll/Label.set_text("")
			if playerPicked == false:
				print("Rolled number was zero and player hasn't been picked yet")
				$DiceRoll.enable_dice_roll()
			elif playerPicked == true:
				print("Rolled number was zero and player is already picked")
				$DiceRoll.enable_dice_roll()
		elif rolledNumber > 0:
			print("Rolled number is greater than zero")
			if playerPicked == false:
				print("Rolled number is greater than zero and player hasn't been picked yet")
				pick_player()
			elif playerPicked == true:
				print("Rolled number is greater than zero and need to switch players")
				switch_player()
#	update_field_status()
#	check_move_eligible()
#	debug_field_status()
#	debug_piece_status()

#func check_move_eligible():
#	for i in range(0, 6):
#		futurePosW.insert(i, 0)
#		futurePosB.insert(i, 0)
#	if state == WHITE_MOVE:
#		for i in range(0, $WhitePiece.get_child_count()):
#			if $WhitePiece.get_child(i).isInGame == true:
#				var futurePos = $WhitePiece.get_child(i).currentPos + rolledNumber
#				print(futurePos)
#				if futurePos > -1 and futurePos < 4:
#					if $Fields/WhiteStart.get_child(futurePos).isFieldTakenW == true:
#						$WhitePiece.get_child(i).isMoveEligible = false
#					else:
#						$WhitePiece.get_child(i).isMoveEligible = true
#						futurePosW.insert(i, futurePos)
#				elif futurePos > 3 and futurePos < 7:
#					if $Fields/Battle.get_child(futurePos).isFieldTakenW == true:
#						$WhitePiece.get_child(i).isMoveEligible = false
#					elif $Fields/Battle.get_child(futurePos).isFieldTakenB == true:
#						$WhitePiece.get_child(i).isMoveEligible = true
#						futurePosW.insert(i, futurePos)
#				elif futurePos == 7:
#					if $Fields/Battle.get_child(futurePos).isFieldTakenW == true:
#						$WhitePiece.get_child(i).isMoveEligible = false
#					elif $Fields/Battle.get_child(futurePos).isFieldTakenB == true:
#						$WhitePiece.get_child(i).isMoveEligible = false
#					else:
#						$WhitePiece.get_child(i).isMoveEligible = true
#						futurePosW.insert(i, futurePos)
#				elif futurePos > 7 and futurePos < 12:
#					if $Fields/Battle.get_child(futurePos).isFieldTakenW == true:
#						$WhitePiece.get_child(i).isMoveEligible = false
#					elif $Fields/Battle.get_child(futurePos).isFieldTakenB == true:
#						$WhitePiece.get_child(i).isMoveEligible = true
#						futurePosW.insert(i, futurePos)
#				elif futurePos > 11 and futurePos < 14:
#					if $Fields/WhiteFinish.get_child(futurePos).isFieldTakenW == true:
#						$WhitePiece.get_child(i).isMoveEligible = false
#					else:
#						$WhitePiece.get_child(i).isMoveEligible = true
#						futurePosW.insert(i, futurePos)
#				elif futurePos == 13:
#					$WhitePiece.isMoveEligible = true
#					futurePosW.insert(i, futurePos)
#				else:
#					print("no move possible!")
#			else:
#				pass
#	elif state == BLACK_MOVE:
#		for i in range(0, $BlackPiece.get_child_count()):
#			if $BlackPiece.get_child(i).isInGame == true:
#				var futurePos = $BlackPiece.get_child(i).currentPos + rolledNumber
#				if futurePos > -1 and futurePos < 4:
#					if $Fields/BlackStart.get_child(futurePos).isFieldTakenB == true:
#						$BlackPiece.get_child(i).isMoveEligible = false
#					else:
#						$BlackPiece.get_child(i).isMoveEligible = true
#						futurePosB.insert(i, futurePos)
#				elif futurePos > 3 and futurePos < 7:
#					if $Fields/Battle.get_child(futurePos).isFieldTakenB == true:
#						$BlackPiece.get_child(i).isMoveEligible = false
#					elif $Fields/Battle.get_child(futurePos).isFieldTakenW == true:
#						$BlackPiece.get_child(i).isMoveEligible = true
#						futurePosB.insert(i, futurePos)
#				elif futurePos == 7:
#					if $Fields/Battle.get_child(futurePos).isFieldTakenB == true:
#						$WhitePiece.get_child(i).isMoveEligible = false
#					elif $Fields/Battle.get_child(futurePos).isFieldTakenW == true:
#						$WhitePiece.get_child(i).isMoveEligible = false
#					else:
#						$WhitePiece.get_child(i).isMoveEligible = true
#						futurePosB.insert(i, futurePos)
#				elif futurePos > 7 and futurePos < 12:
#					if $Fields/Battle.get_child(futurePos).isFieldTakenB == true:
#						$BlackPiece.get_child(i).isMoveEligible = false
#					elif $Fields/Battle.get_child(futurePos).isFieldTakenW == true:
#						$BlackPiece.get_child(i).isMoveEligible = true
#						futurePosB.insert(i, futurePos)
#				elif futurePos > 11 and futurePos < 14:
#					if $Fields/BlackFinish.get_child(futurePos).isFieldTakenB == true:
#						$BlackPiece.get_child(i).isMoveEligible = false
#					else:
#						$BlackPiece.get_child(i).isMoveEligible = true
#						futurePosB.insert(i, futurePos)
#				elif futurePos == 13:
#					$BlackPiece.isMoveEligible = true
#					futurePosB.insert(i, futurePos)
#				else:
#					print("no move possible!")
#			else:
#				pass
#		pass

#func _on_piece_pressed(i):
#	selectedPiece = i
#	if state == WHITE_MOVE:
#		if $WhitePiece.get_child(i).isMoveEligible == true:
#			var position = futurePosW[i]
#			if position > -1 and position < 4:
#				$Fields/WhiteStart.get_child(position).field_move_valid()
#				$WhitePiece.get_child(i).set_piece_move_eligible()
#			elif position > 3 and position < 7:
#				$Fields/Battle.get_child(position - 4).field_move_valid()
#				$WhitePiece.get_child(i).set_piece_move_eligible()
#			elif position == 7:
#				$Fields/Battle.get_child(3).field_move_valid()
#				$WhitePiece.get_child(i).set_piece_move_eligible()
#			elif position > 7 and position < 12:
#				$Fields/Battle.get_child(position - 4).field_move_valid()
#				$WhitePiece.get_child(i).set_piece_move_eligible()
#			elif position > 11 and position < 14:
#				$Fields/WhiteFinish.get_child(position - 12).field_move_valid()
#				$WhitePiece.get_child(i).set_piece_move_eligible()
#			else:
#				pass
#		elif $WhitePiece.get_child(i).isMoveEligible == false:
#			var position = futurePosW[i]
#			if position > -1 and position < 4:
#				$Fields/WhiteStart.get_child(position).field_move_invalid()
#				$WhitePiece.get_child(i).set_piece_move_ineligible()
#			elif position > 3 and position < 7:
#				$Fields/Battle.get_child(position - 4).field_move_invalid()
#				$WhitePiece.get_child(i).set_piece_move_ineligible()
#			elif position == 7:
#				$Fields/Battle.get_child(3).field_move_invalid()
#				$WhitePiece.get_child(i).set_piece_move_ineligible()
#			elif position > 7 and position < 12:
#				$Fields/Battle.get_child(position - 4).field_move_invalid()
#				$WhitePiece.get_child(i).set_piece_move_ineligible()
#			elif position > 11 and position < 14:
#				$Fields/WhiteFinish.get_child(position - 12).field_move_invalid()
#				$WhitePiece.get_child(i).set_piece_move_ineligible()
#			else:
#				pass
#	elif state == BLACK_MOVE:
#		if $BlackPiece.get_child(i).isMoveEligible == true:
#			var position = futurePosB[i]
#			if position > -1 and position < 4:
#				$Fields/BlackStart.get_child(position).field_move_valid()
#				$BlackPiece.get_child(i).set_piece_move_eligible()
#			elif position > 3 and position < 7:
#				$Fields/Battle.get_child(position - 4).field_move_valid()
#				$BlackPiece.get_child(i).set_piece_move_eligible()
#			elif position == 7:
#				$Fields/Battle.get_child(3).field_move_valid()
#				$BlackPiece.get_child(i).set_piece_move_eligible()
#			elif position > 7 and position < 12:
#				$Fields/Battle.get_child(position - 4).field_move_valid()
#				$BlackPiece.get_child(i).set_piece_move_eligible()
#			elif position > 11 and position < 14:
#				$Fields/BlackFinish.get_child(position - 12).field_move_valid()
#				$BlackPiece.get_child(i).set_piece_move_eligible()
#			else:
#				pass
#		elif $BlackPiece.get_child(i).isMoveEligible == false:
#			var position = futurePosB[i]
#			if position > -1 and position < 4:
#				$Fields/BlackStart.get_child(position).field_move_invalid()
#				$BlackPiece.get_child(i).set_piece_move_ineligible()
#			elif position > 3 and position < 7:
#				$Fields/Battle.get_child(position - 4).field_move_invalid()
#				$BlackPiece.get_child(i).set_piece_move_ineligible()
#			elif position == 7:
#				$Fields/Battle.get_child(3).field_move_invalid()
#				$BlackPiece.get_child(i).set_piece_move_ineligible()
#			elif position > 7 and position < 12:
#				$Fields/Battle.get_child(position - 4).field_move_invalid()
#				$BlackPiece.get_child(i).set_piece_move_ineligible()
#			elif position > 11 and position < 14:
#				$Fields/BlackFinish.get_child(position - 12).field_move_invalid()
#				$BlackPiece.get_child(i).set_piece_move_ineligible()
#			else:
#				pass


func _on_Button2_pressed():
	if new_game == true:
		start_new_game()
		new_game = false
	else:
		if materials_v2 == true:
			materials_v2 = false
		else:
			materials_v2 = true
		if materials_v2 == true:
			for i in range(6):
				$WhitePiece.get_child(i).change_mesh_complex()
				$WhitePiece.get_child(i).simple_mesh = false
				$BlackPiece.get_child(i).change_mesh_complex()
				$BlackPiece.get_child(i).simple_mesh = false
			$Spatial/MeshInstance.set_mesh(board_complex)
			$Spatial/MeshInstance.set_surface_material(0, board_v2_MAT)
			$Button2.set_text("KLASICNO")
		else:
			for i in range(6):
				$WhitePiece.get_child(i).change_mesh_simple()
				$WhitePiece.get_child(i).simple_mesh = true
				$BlackPiece.get_child(i).change_mesh_simple()
				$BlackPiece.get_child(i).simple_mesh = true
			$Spatial/MeshInstance.set_mesh(board_simple)
			$Spatial/MeshInstance.set_surface_material(0, board_MAT1)
			$Spatial/MeshInstance.set_surface_material(1, board_MAT2)
			$Spatial/MeshInstance.set_surface_material(2, board_MAT3)
			$Button2.set_text("JEDNOSTAVNO")
		if state == WHITE_MOVE:
			if piece_moved == false:
				white_piece_set_active()
				black_piece_set_inactive()
			else:
				white_piece_set_inactive()
				black_piece_set_inactive()
		elif state == BLACK_MOVE:
			if piece_moved == false:
				black_piece_set_active()
				white_piece_set_inactive()
			else:
				white_piece_set_inactive()
				black_piece_set_inactive()
		else:
			white_piece_set_inactive()
			black_piece_set_inactive()

func start_new_game():
	white_pieces_playing = 6
	black_pieces_playing = 6
	playerPicked = false
	rolledNumber = 0
	bonusRoll = false
	initialize_music()
	play_music()
	$Button2.set_modulate(Color(1, 1, 1, 0.35))
	$DiceRoll.enable_dice_roll()
	for i in range(4):
		$Fields/WhiteStart.get_child(i).isFieldTakenW = false
		$Fields/BlackStart.get_child(i).isFieldTakenB = false
	for i in range(8):
		$Fields/Battle.get_child(i).isFieldTakenW = false
		$Fields/Battle.get_child(i).isFieldTakenB = false
	for i in range(2):
		$Fields/WhiteFinish.get_child(i).isFieldTakenW = false
		$Fields/BlackFinish.get_child(i).isFieldTakenB = false
	for i in range(6):
		$WhitePiece.get_child(i).currentPos = -1
		$WhitePiece.get_child(i).isInGame = true
		$WhitePiece.get_child(i).translate(Vector3(-14, 0, 0))
		$BlackPiece.get_child(i).currentPos = -1
		$BlackPiece.get_child(i).isInGame = true
		$BlackPiece.get_child(i).translate(Vector3(-14, 0, 0))
	yield(get_tree().create_timer(1), "timeout")
	var random_piece_pick = randi()%2
	if random_piece_pick == 0:
		initialize_white_pieces()
		yield(get_tree().create_timer(.5), "timeout")
		initialize_black_pieces()
	elif random_piece_pick == 1:
		initialize_black_pieces()
		yield(get_tree().create_timer(.5), "timeout")
		initialize_white_pieces()
	
func end_game():
	white_piece_set_inactive()
	black_piece_set_inactive()
	$DiceRoll.disable_dice_roll()
	$MusicPlayer.stop()
	$MusicPlayer.set_stream(player_wins)
	$MusicPlayer.volume_db = -7
	$MusicPlayer.play()
	new_game = true
	if white_pieces_playing == 0:
		$DiceRoll/Button/Label.set_text("Bijeli je\npobjednik!")
	elif black_pieces_playing == 0:
		$DiceRoll/Button/Label.set_text("Crni je\npobjednik!")
	yield(get_tree().create_timer(3), "timeout")
	$Button2.set_text("Nova igra?")
	$Button2.set_modulate(Color(1, 1, 1, 1))
