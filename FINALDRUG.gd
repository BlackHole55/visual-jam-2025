extends Area2D




func _on_body_entered(body: Node2D) -> void:
	if Variables.picked_items.size() >= 10:
		get_tree().change_scene_to_file("res://funny_joke.tscn")
	else:
		Variables.is_Dead = true
