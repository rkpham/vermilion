class_name Journal
extends Control

var current_page_set: int = 0:
	set = _set_current_left_page

@export_multiline var pages: Array[String] = []

@onready var left_text: RichTextLabel = $PaperLeft/PageText
@onready var right_text: RichTextLabel = $PaperRight/PageText
@onready var turn_text: RichTextLabel = $PageTurn/PaperTurn/PageText
@onready var anim: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	if pages.size() > 0:
		left_text.text = pages[0]
	if pages.size() > 1:
		right_text.text = pages[1]
	
	Game.note_picked_up.connect(_add_page)

# Page sets are each pairs of pages; turning a page gives you the next 2
# Pages are therefore considered in sets of 2
func _set_current_left_page(_page_set: int) -> void:
	if _page_set < 0 or _page_set * 2 >= pages.size() or pages.size() == 0 or anim.is_playing():
		return
	
	var left_page_idx = _page_set * 2
	var right_page_idx = _page_set * 2 + 1
	
	# Guard clause above inherently bounds checks for left page idx
	if _page_set < current_page_set:
		turn_text.text = left_text.text
		left_text.text = pages[left_page_idx]
		anim.play("turn_prev_start")
		await anim.animation_finished
		turn_text.text = pages[right_page_idx]
		anim.play("turn_prev_end")
		await anim.animation_finished
		right_text.text = pages[right_page_idx]
	elif _page_set > current_page_set:
		turn_text.text = right_text.text
		if right_page_idx < pages.size():
			right_text.text = pages[right_page_idx]
		else:
			right_text.text = ""
		anim.play("turn_next_start")
		await anim.animation_finished
		turn_text.text = pages[left_page_idx]
		anim.play("turn_next_end")
		await anim.animation_finished
		left_text.text = pages[left_page_idx]
	current_page_set = _page_set


func _on_paper_left_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		current_page_set -= 1


func _on_paper_right_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		current_page_set += 1

func _add_page(text: String) -> void:
	if text not in pages:
		pages.append(text)
