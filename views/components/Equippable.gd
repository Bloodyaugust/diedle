extends Control

var data:Dictionary

onready var _name:Label = find_node("Name")
onready var _attribute:Label = find_node("Attribute")
onready var _attribute_amount:Label = find_node("AttributeAmount")

func _ready():
  _name.text = data.id
  _attribute.text = data.attribute + ":"
  _attribute_amount.text = str(data["attribute-amount"])
