extends Area2D

@export var item_id = 1


func _ready():
	if Variables.picked_items.get(item_id, false):
		queue_free()
		
func _on_body_entered(body: Node2D) -> void:	
	if body.name == "first_normal_character":
		Variables.picked_items[item_id] = true
		Variables.time+=10
		print(Variables.picked_items.size())
		queue_free()
