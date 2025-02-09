extends Resource

class_name AreaNode

enum NodeType { COMBAT, CLINIC, ENCOUNTER, SHOP }

static func node_type_to_string(node_type: NodeType) -> String:
	match node_type:
		NodeType.COMBAT:
			return "COMBAT"
		NodeType.CLINIC:
			return "CLINIC"
		NodeType.ENCOUNTER:
			return "ENCOUNTER"
		NodeType.SHOP:
			return "SHOP"
		_:
			return "UNKNOWN"

var type: NodeType
var connections: Array
var name: String

func _init(_type: NodeType):
	type = _type
	connections = []
	name = ""

func as_string() -> String:
	var connection_types = connections.map(func(conn) -> String:
		return AreaNode.node_type_to_string(conn.type))
	return "Name: %s, Type: %s, Connections: %s" % [name, AreaNode.node_type_to_string(type), str(connection_types)]
