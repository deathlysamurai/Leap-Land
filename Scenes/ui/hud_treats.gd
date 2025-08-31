extends Control


func _ready() -> void:
	unlock_treats()

func unlock_treats() -> void:
	var unlocked_treats = Data.current_level - 1
	var treats = %HudTreatContainer.get_children()
	for i in unlocked_treats:
		treats[i].modulate = Color(1,1,1,1)
