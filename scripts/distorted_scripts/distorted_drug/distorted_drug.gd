extends Area2D
		
@export var item_id = 6

func _ready():
	if Variables.picked_items.get(item_id, false):
		queue_free()
		
func _on_body_entered(body: Node2D) -> void:	
	if body.name == "first_distorted_character":
		Variables.picked_items[item_id] = true
		Variables.time +=10
		queue_free()
