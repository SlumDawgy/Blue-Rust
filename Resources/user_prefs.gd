class_name UserPreferences extends Resource

@export_range(0, 1, 0.05) var music_audio_level : float = 1.0
@export_range(0, 1, 0.05) var sfx_audio_level : float = 1.0
@export_range(0, 1, 0.05) var master_audio_level : float = 1.0

@export_range(0, 1, 1) var language_selected : int = 0


func save() -> void:
	ResourceSaver.save(self, "user://user_prefs.tres")
	

static func load_or_create() -> UserPreferences:
	var res: UserPreferences = load("user://user_prefs.tres") as UserPreferences
	if !res:
		res = UserPreferences.new()
	return res
