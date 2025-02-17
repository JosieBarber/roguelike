extends CardItem

class_name MultiplierCardItem

var new_type: String

func _init(new_type: String):
	self.new_type = new_type

func change_type() -> String:
	return new_type
