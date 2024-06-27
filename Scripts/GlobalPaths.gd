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
const PRISON_SCENE_PATH: String = "res://Scenes/Levels/Prison/prison.tscn"
# SCENES/LEVELS/DREAMSCENE
const DREAM_SCENE_PATH: String = "res://Scenes/Levels/DreamSequences/DashDreamSequence.tscn"
#SCENES/LEVELS/SEWER
const 	SEWER_SCENE_PATH: String = "res://Scenes/Levels/Sewer/Sewer.tscn"
#SCENES/LEVELS/CITY
const  CITY_SCENE_PATH: String ="res://Scenes/Levels/City/City.tscn"
#SCENES/LEVELS/CLOCKTOWER
const  CLOCKTOWER_SCENE_PATH: String ="res://Scenes/Levels/ClockTower/ClockTower.tscn"
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
