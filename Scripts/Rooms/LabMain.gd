extends Node2D
class_name MainScene

@export_category("Music")
@export var lab_music: AudioStream
@export var bio2_music: AudioStream
@export var boss_music: AudioStream

@export_category("Player")
@export var LANTERN_flag: bool = false

@export_category("Enemies")
@export var SKELTOR_flag: bool = false

@export_category("Room Bools")
@export var FOREST1_flag1: bool = false
@export var FOREST1_flag2: bool = false
@export var FOREST1_flag3: bool = false
@export var FOREST1_flag4: bool = false

@export var FOREST2_flag1: bool = false
@export var FOREST2_flag2: bool = false
@export var FOREST2_flag3: bool = false
@export var FOREST2_flag4: bool = false

@export var ARCH1_flag1: bool = false
@export var ARCH1_flag2: bool = false
@export var ARCH1_flag3: bool = false
@export var ARCH1_flag4: bool = false
@export var ARCH1_flag5: bool = false
@export var ARCH1_flag6: bool = false
@export var ARCH1_flag7: bool = false
@export var ARCH1_flag8: bool = false

@export var ARCH2_flag1: bool = false
@export var ARCH2_flag2: bool = false
@export var ARCH2_flag3: bool = false
@export var ARCH2_flag4: bool = false

@export var CHEM1_flag1: bool = false
@export var CHEM1_flag2: bool = false
@export var CHEM1_flag3: bool = false
@export var CHEM1_flag4: bool = false

@export var CHEM2_flag1: bool = false
@export var CHEM2_flag2: bool = false
@export var CHEM2_flag3: bool = false
@export var CHEM2_flag4: bool = false

@export var BIO1_flag1: bool = false
@export var BIO1_flag2: bool = false
@export var BIO1_flag3: bool = false
@export var BIO1_flag4: bool = false

@export var BIO2_flag1: bool = false
@export var BIO2_flag2: bool = false
@export var BIO2_flag3: bool = false
@export var BIO2_flag4: bool = false
@export var BIO2_flag5: bool = false

@export var SECRET1_flag1: bool = false
@export var SECRET1_flag2: bool = false
@export var SECRET1_flag3: bool = false
@export var SECRET1_flag4: bool = false
@export var SECRET1_flag5: bool = false
@export var SECRET1_flag6: bool = false

@export var SECRET2_flag1: bool = false
@export var SECRET2_flag2: bool = false
@export var SECRET2_flag3: bool = false
@export var SECRET2_flag4: bool = false
@export var SECRET2_flag5: bool = false
@export var SECRET2_flag6: bool = false
@export var SECRET2_flag7: bool = false
@export var SECRET2_flag8: bool = false
@export var SECRET2_flag9: bool = false
@export var SECRET2_flag10: bool = false
@export var SECRET2_flag11: bool = false
@export var SECRET2_flag12: bool = false
@export var SECRET2_flag13: bool = false

@export var finished_flag: bool = false

@export_category("Menus")

@onready var player = $Player
@onready var room_container = $RoomContainer
@onready var dialogue_timer : Timer = $DialogueTimer

# Dialogue options
@export var dialogue_box: NinePatchRect
@export var dialogue_text: Label
var is_dialogue_visible: bool = false


func _ready():
	AudioManager.play_music(lab_music)
	#connect("game_over", game_over)
	dialogue_timer.timeout.connect(_on_dialogue_timer_timeout)
	
func _process(_delta):
	check_room_flags()

func check_room_flags():
	if "FOREST1_PATH" in room_container.current_room:
		if !FOREST1_flag1:
			show_dialogue("I know the lab was around here somewhere...")
			FOREST1_flag1 = true
		
		if FOREST1_flag2:
			show_dialogue("Maybe I can JUMP and get a better view from up there?")
			
		if FOREST1_flag3:
			show_dialogue("That vine up there looks sturdy enough to GRAPPLE!")
		
		if FOREST1_flag4:
			show_dialogue("I'm going to have to time this JUMP GRAPPLE just right.")
	
	elif "FOREST2_PATH" in room_container.current_room:
		if FOREST2_flag1 and !SECRET2_flag13:
			show_dialogue("A good JUMP DASH will get me across that gap.")
			
		if FOREST2_flag2 and !SECRET2_flag13:
			show_dialogue("That damn fence, I don't want to fall down there...")
			
		if FOREST2_flag3 and !SECRET2_flag13:
			show_dialogue("Well at least it's still standing. Guess I'll see if anyone is home.")
		
		if SECRET2_flag13:
			AudioManager.play_music(bio2_music)
			show_dialogue("Am I... safe?")
			room_container.transition_fader.fade_out()
			finished_flag = true
			await get_tree().create_timer(10).timeout

		
		if finished_flag:
			get_tree().change_scene_to_file(GlobalPaths.MAIN_MENU_SCREEN_PATH)
			
			
	elif "ARCH1_PATH" in room_container.current_room:
		if ARCH1_flag1 and !ARCH1_flag2:
			show_dialogue("Oh hi! I didn't know anyb...?")
			ARCH1_flag2 = true
		if ARCH1_flag3 and !ARCH1_flag4:
			show_dialogue("I could have sworn I saw someone...")
			ARCH1_flag4 = true
		if ARCH1_flag5 and !ARCH1_flag6:
			show_dialogue("Looks like the best way is down.")
			ARCH1_flag6 = true
		if ARCH1_flag7 and !ARCH1_flag8:
			show_dialogue("Dammit, it's locked! I need to find a way out before these Shades get me!")
			ARCH1_flag8 = true
			
	
	elif "SECRET1_PATH" in room_container.current_room:
		if SECRET1_flag1 and !SECRET1_flag2:
			show_dialogue("I could really use a light down here.")
			SECRET1_flag2 = true
		
		if SECRET1_flag3 and !SECRET1_flag4:
			show_dialogue("This Lab seems to go much deeper than I remember?")
			SECRET1_flag4 = true
			
		if SECRET1_flag5 and !SECRET1_flag6:
			show_dialogue("What the hell are these creatures?!")
			SECRET1_flag6 = true
	
	elif "SECRET2_PATH" in room_container.current_room:
		if !SECRET2_flag1 and !SECRET2_flag2:
			SECRET2_flag1 = true
			SECRET2_flag2 = true
			show_dialogue("Where did this room come from? What is that light?")
			AudioManager.stop_music()
		
		if SECRET2_flag3 and !SECRET2_flag4:
			AudioManager.play_music(lab_music)
			SECRET2_flag4 = true
			SECRET2_flag5 = true
			show_dialogue("This lantern is so hot, I can only hold it with my metal hand.")
	
		if SECRET2_flag5 and !SECRET2_flag6:
			SECRET2_flag6 = true
			show_dialogue("I guess I'll have to go back up and look for a different route?")
							
		if SECRET2_flag7 and !SECRET2_flag8:
			AudioManager.stop_music()
			show_dialogue("A perfect circle...")
			SECRET2_flag8 = true
			
		if SECRET2_flag9 and !SECRET2_flag10:
			AudioManager.play_music(boss_music)
			show_dialogue("Huh?!")
			SECRET2_flag10 = true
			SKELTOR_flag = true
			
		if SECRET2_flag11 and !SECRET2_flag12:
			show_dialogue("What is that monstrosity?!")
			SECRET2_flag12 = true
	
	elif "ARCH2_PATH" in room_container.current_room:	
		if ARCH2_flag1 and !ARCH2_flag2:
			show_dialogue("I can't grapple up to this ledge while holding this lantern!")
			ARCH2_flag2 = true
		
	elif "CHEM1_PATH" in room_container.current_room:
		if !CHEM1_flag1 and !CHEM1_flag2:
			show_dialogue("Wait... This is where I discovered the formula for Alium...")
			CHEM1_flag1 = true
			CHEM1_flag2 = true
		if CHEM1_flag3 and !CHEM1_flag4:
			show_dialogue("Is that... ME?")
			CHEM1_flag4 = true
			
	elif "CHEM2_PATH" in room_container.current_room:
		if !CHEM2_flag1 and !CHEM2_flag2:
			show_dialogue("My study, I'd never forget the smell!")
			CHEM2_flag1 = true
			CHEM2_flag2 = true
		if CHEM2_flag3 and !CHEM2_flag4:
			show_dialogue("Heh, I always did love those damn hats.")
			CHEM2_flag4 = true
			
	elif "BIO1_PATH" in room_container.current_room:
		if !BIO1_flag1 and !BIO1_flag2:
			show_dialogue("I hope this doesn't lead to where I think it does, better be careful of broken glass.")
			BIO1_flag1 = true
			BIO1_flag2 = true
		
	elif "BIO2_PATH" in room_container.current_room:
		if !BIO2_flag1:
			AudioManager.stop_music()
			BIO2_flag1 = true
		elif BIO2_flag2 and !BIO2_flag3:
			AudioManager.play_music(bio2_music)
			show_dialogue("No. NO! STOP!")
			BIO2_flag3 = true
		
		if BIO2_flag4 and !BIO2_flag5:
			show_dialogue("It's too late, I can't go back and stop myself...")
			BIO2_flag5 = true		

		
func show_dialogue(dialogue: String):
	dialogue_text.text = dialogue
	dialogue_box.visible = true
	is_dialogue_visible = true
	dialogue_timer.start()
	
func hide_dialogue():
	dialogue_box.visible = false
	is_dialogue_visible = false
	
func _on_dialogue_timer_timeout():
	print('there')
	hide_dialogue()
