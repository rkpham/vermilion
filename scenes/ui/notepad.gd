class_name Notepad
extends Control

const BRUSH_SIZE: float = 1.7

var hovering: bool = false
var drawing: bool = false
var brushes: Array[Vector2] = []
var undo_amts: Array[int] = []
var last_drew_pos: Vector2 = Vector2.ZERO


func _process(delta: float) -> void:
	var rect = get_rect()
	var smaller_rect = Rect2(rect.position + Vector2.ONE * 2.0, rect.size - Vector2.ONE * 4.0)
	var has_mouse = smaller_rect.has_point(get_global_mouse_position())
	
	if hovering and not has_mouse:
		end_stroke()
	
	if has_mouse and not hovering and Input.is_action_pressed("mouse_left"):
		start_stroke()
	
	hovering = has_mouse
	
	if hovering and Input.is_action_just_pressed("mouse_left"):
		start_stroke()
	
	if Input.is_action_just_released("mouse_left"):
		end_stroke()
	
	if drawing:
		add_brush(get_local_mouse_position())


func _draw() -> void:
	for i in range(brushes.size()):
		draw_circle(brushes[i], 1, Color.BLACK)
		if i > 0:
			if not i in undo_amts:
				draw_line(brushes[i - 1], brushes[i], Color.BLACK, BRUSH_SIZE, false)


func add_brush(pos: Vector2) -> void:
	if last_drew_pos == Vector2.ZERO:
		brushes.append(pos)
		last_drew_pos = pos
		queue_redraw()
	if (pos - last_drew_pos).length() > 1:
		brushes.append(pos)
		last_drew_pos = pos
		queue_redraw()


func start_stroke() -> void:
	drawing = true
	undo_amts.append(brushes.size())
	add_brush(get_local_mouse_position())


func end_stroke() -> void:
	drawing = false


func undo() -> void:
	if undo_amts.size() > 0:
		var brushes_to_remove = brushes.size() - undo_amts.pop_back()
		
		for i in range(brushes_to_remove):
			brushes.pop_back()
		
		queue_redraw()
