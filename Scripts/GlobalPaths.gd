# GlobalPaths.gd
extends Node

# SCENES
# SCENES/MC
const GRAPPLING_HOOK_PATH: String = "res://Scenes/Player/GrapplingHook.tscn"

# SCENES/UI
const MAIN_MENU_SCREEN_PATH: String = "res://Scenes/UI/Main_Menu.tscn"
const DEATH_SCREEN_PATH: String = "res://Scenes/UI/death_ui.tscn"
const OPTIONS_SCREEN_PATH: String = "res://Scenes/UI/Main_Menu_Options.tscn"
const END_GAME_SCENE_PATH: String = "res://Scenes/UI/endGame.tscn"
# SCENES/LEVELS
# SCENES/LEVELS/PRISON
const PRISON_START_SCENE_PATH: String = "res://Scenes/Levels/Prison/prison_start_1.tscn"
const PRISON_BREAKING_BRIDGE_SCENE_PATH: String = "res://Scenes/Levels/Prison/prison_Breaking_Bridge_Room_2.tscn"
const PRISON_GRAPPLE_ROOM_SCENE_PATH: String = "res://Scenes/Levels/Prison/prison_Grapple_Room_3.tscn"
const PRISON_VERTICLE_ONE_SCENE_PATH: String = "res://Scenes/Levels/Prison/prison_Verticle_Room_4.tscn"
const PRISON_VERTICLE_TO_BOSS_SCENE_PATH: String = "res://Scenes/Levels/Prison/prison_Verticle_To Boss_5.tscn"
const PRISON_WATER_GRAPPLE_SCENE_PATH: String = "res://Scenes/Levels/Prison/prison_Water_Grapple_Room_6.tscn"
const PRISON_TRANSITION_TO_BOSS_SCENE_PATH: String = "res://Scenes/Levels/Prison/prison_Transition_To_Boss_7.tscn"
const PRISON_BOSS_ROOM_SCENE_PATH: String = "res://Scenes/Levels/Prison/prison_Boss_Room.tscn"
const PRISON_AFTER_BOSS_ROOM_SCENE_PATH: String = "res://Scenes/Levels/Prison/prison_After_Boss_Room.tscn"
const PRISON_SAVE_ROOM_ONE_SCENE_PATH: String = "res://Scenes/Levels/Prison/prison_Save_Room_1.tscn"
const PRISON_SAVE_ROOM_TWO_SCENE_PATH: String = "res://Scenes/Levels/Prison/prison_Save_Room_2.tscn"
# SCENES/LEVELS/DREAMSCENE
const DREAM_SCENE_PATH: String = "res://Scenes/Levels/DreamSequences/DashDreamSequence.tscn"

# ASSETS
# ASSETS/SPRITES
# ASSETS/SPRITES/LANTURN
const LANTURN_EMPTY_PATH: String = "res://Assets/Sprites/Lanturn/lanturn_empty.png"
const LANTURN_FULL_PATH: String = "res://Assets/Sprites/Lanturn/lanturn_full.png"
const LANTURN_ANIMATION_PATH: String = "res://Assets/Sprites/Lanturn/lanturn_animation.png"

# ASSETS/SPRITES/MC
const PLAYER_AIM_PATH: String = "res://Assets/Sprites/Player/Aim.png"
const PLAYER_AIMING_PATH: String = "res://Assets/Sprites/Player/Aiming.png"

const DASH_UPGRADE: String = "res://Scenes/Items/fragment_piece.tscn"

#AUDIO BUSES
const AUDIO_BUS_LAYOUT = "res://default_bus_layout.tres"
const MASTER_BUS :String = &"Master"
const BGM_BUS : String = &"BGM"
const SFX_BUS : String = &"SFX"
const MASTER_BUS_INDEX : int = 0
const SFX_BUS_INDEX : int = 1
const BGM_BUS_INDEX : int = 2

#LOADING
var LOADING : bool = false
