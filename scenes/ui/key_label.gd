extends Label

func _ready():
	Game.key_changed.connect(_key_changed)

func _key_changed():
	if Game.current_key == "":
		text = ""
	else:
		text = "Current Key: %s" % [Game.current_key]
