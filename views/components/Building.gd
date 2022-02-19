extends Control

onready var _name:Label = find_node("Name")
onready var _cost:Label = find_node("Cost")

var data:Dictionary

func _on_gui_input(event: InputEvent) -> void:
  if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
    if Store.state.money >= data.cost:
      Store.set_state("building_selection", data)

func _on_store_state_changed(state_key: String, substate) -> void:
  match state_key:
    "money":
      if substate >= data.cost:
        modulate = Color.white
      else:
        modulate = Color.black

func _ready():
  connect("gui_input", self, "_on_gui_input")
  Store.connect("state_changed", self, "_on_store_state_changed")

  _name.text = data.id
  _cost.text = str(data.cost)
