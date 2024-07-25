class_name UserPreferences extends Resource

@export var fullscreen: bool = false
@export var sensitivity:int = 15

func save() -> void:
	ResourceSaver.save(self, "user://user_preferences.tres")

static func load_or_create() -> UserPreferences:
	var res: UserPreferences = load("user://user_preferences.tres") as UserPreferences
	if !res:
		res = UserPreferences.new()
	return res
