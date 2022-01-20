extends Control

onready var _continue:Button = find_node("Continue")
onready var _delve:Button = find_node("Delve")
onready var _return:Button = find_node("Return")
onready var _in_combat:Label = find_node("InCombat")

func _on_continue_pressed() -> void:
  Store.set_state("game", GameConstants.GAME_DELVE)

func _on_delve_pressed() -> void:
  Store.set_state("game", GameConstants.GAME_DELVE)

func _on_return_pressed() -> void:
  Store.set_state("game", GameConstants.GAME_CAMP)

func _on_store_state_changed(state_key:String, substate) -> void:
  match state_key:
    "game":
      match substate:
        GameConstants.GAME_CAMP:
          _in_combat.visible = false
          _continue.visible = false
          _return.visible = false
          _delve.visible = true
        GameConstants.GAME_COMBAT:
          _in_combat.visible = true
          _continue.visible = false
          _return.visible = false
          _delve.visible = false
        GameConstants.GAME_DELVE:
          _in_combat.visible = false
          _continue.visible = true
          _return.visible = true
          _delve.visible = false

func _ready():
  Store.connect("state_changed", self, "_on_store_state_changed")
  _continue.connect("pressed", self, "_on_continue_pressed")
  _delve.connect("pressed", self, "_on_delve_pressed")
  _return.connect("pressed", self, "_on_return_pressed")
