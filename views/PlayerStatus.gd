extends Control

onready var _money:Label = find_node("Money")

func _on_store_state_changed(state_key:String, substate) -> void:
  match state_key:
    "money":
      _money.text = "%06d" % substate

func _ready():
  Store.connect("state_changed", self, "_on_store_state_changed")
