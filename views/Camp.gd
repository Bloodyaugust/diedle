extends Control

const _building_component:PackedScene = preload("res://views/components/Building.tscn")

onready var _buildings_container:VBoxContainer = find_node("Buildings")

func _initialize() -> void:
  var _buildings = Depot.get_lines("buildings")

  for _building in _buildings:
    var _new_building_component = _building_component.instance()
    _new_building_component.data = _building

    _buildings_container.add_child(_new_building_component)

func _on_store_state_changed(state_key: String, substate) -> void:
  match state_key:
    "game":
      match substate:
        GameConstants.GAME_CAMP:
          visible = true
        _:
          visible = false

func _ready():
  Store.connect("state_changed", self, "_on_store_state_changed")

  call_deferred("_initialize")
