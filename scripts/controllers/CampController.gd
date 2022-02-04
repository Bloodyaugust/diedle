extends Node

func _on_store_state_changed(state_key:String, substate) -> void:
  match state_key:
    "game":
      match substate:
        GameConstants.GAME_CAMP:
          var _players:Array = get_tree().get_nodes_in_group("players")
          
          for _player in _players:
            _player.heal_full()
            
            var _player_equipment = _player.get_equipment()
            Store.persistent_store.runs[Store.state.run].equipment = []
            for _equippable in _player_equipment:
              Store.persistent_store.runs[Store.state.run].equipment.append(_equippable.data.id)
            Store.persistent_store.runs[Store.state.run].money = Store.state.money
            Store.save_persistent_store()

func _ready():
  Store.connect("state_changed", self, "_on_store_state_changed")
