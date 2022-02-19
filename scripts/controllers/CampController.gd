extends Node

const _building_scene:PackedScene = preload("res://actors/Building.tscn")
const _building_texture = preload("res://icon.png")
const _building_allowed_texture_color:Color = Color(1.0, 1.0, 1.0, 0.2)
const _building_not_allowed_texture_color:Color = Color(0.8, 0.2, 0.2, 0.2)
const _camp_scene:PackedScene = preload("res://actors/Camp.tscn")

var _building_indicator:Sprite
var _camp_tiles:TileMap

func _initialize() -> void:
  _building_indicator = Sprite.new()
  _building_indicator.visible = false
  _building_indicator.texture = _building_texture
  _building_indicator.modulate = _building_allowed_texture_color
  _building_indicator.z_index = 1

  get_tree().get_root().add_child(_building_indicator)

  _camp_tiles = _camp_scene.instance()

  get_tree().get_root().add_child(_camp_tiles)

func _on_store_state_changed(state_key:String, substate) -> void:
  match state_key:
    "building_selection":
      if substate:
        _building_indicator.visible = true
      else:
        _building_indicator.visible = false

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

func _process(delta):
  if _building_indicator:
    _building_indicator.global_position = GDUtil.tilemap_global_cell_position(_camp_tiles, _building_indicator.get_global_mouse_position())

    var _space = _building_indicator.get_world_2d().direct_space_state
    if _space.intersect_point(_building_indicator.get_global_mouse_position(), 1, [], 2147483647, true, true):
      _building_indicator.modulate = _building_not_allowed_texture_color
    else:
      _building_indicator.modulate = _building_allowed_texture_color

func _ready():
  Store.connect("state_changed", self, "_on_store_state_changed")

  call_deferred("_initialize")

func _unhandled_input(event):
  if event is InputEventMouseButton && event.button_index == BUTTON_RIGHT && event.is_pressed():
    if Store.state.building_selection:
      Store.set_state("building_selection", null)

  if event is InputEventMouseButton && event.button_index == BUTTON_LEFT && event.is_pressed():
    if Store.state.building_selection:
      var _space = _building_indicator.get_world_2d().direct_space_state
      if !_space.intersect_point(_building_indicator.get_global_mouse_position(), 1, [], 2147483647, true, true):
        var _new_building = _building_scene.instance()
        _new_building.global_position = GDUtil.tilemap_global_cell_position(_camp_tiles, _building_indicator.get_global_mouse_position())

        _camp_tiles.add_child(_new_building)
        print("made building")
