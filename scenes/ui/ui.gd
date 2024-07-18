class_name UserInterface
extends Control


@onready var interact_icons = $InteractIcons


func _ready() -> void:
	Game.ui = self


func show_icon(icon_id: Values.INTERACT_TYPE) -> void:
	match icon_id:
		Values.INTERACT_TYPE.NONE:
			for icon in interact_icons.get_children():
				icon.hide()
		Values.INTERACT_TYPE.LOOK:
			for icon in interact_icons.get_children():
				icon.hide()
			interact_icons.get_node("EyeIcon").show()
		Values.INTERACT_TYPE.GRAB:
			for icon in interact_icons.get_children():
				icon.hide()
			interact_icons.get_node("HandGrabIcon").show()
