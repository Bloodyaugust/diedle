extends Node

signal creature_spawned(creature)

const creature_scene:PackedScene = preload("res://actors/Creature.tscn")

onready var _enemy_spawns:Array = get_tree().get_nodes_in_group("enemy_spawns")
onready var _player_spawns:Array = get_tree().get_nodes_in_group("player_spawns")

var _enemy_lines:Array
var _spawn_slots:Dictionary

func _on_creature_died(spawn) -> void:
  _spawn_slots[spawn] = null

  var _wave_ended:bool = true
  for _creature in _spawn_slots.values():
    if _creature != null:
      _wave_ended = false

  if _wave_ended:
    Store.set_state("game", GameConstants.GAME_REST)

func _on_store_state_changed(state_key:String, substate) -> void:
  match state_key:
    "game":
      match substate:
        GameConstants.GAME_DELVE:
          var _spawning_creatures:Array = _create_wave()

          for _creature in _spawning_creatures:
            spawn_enemy(_creature)

          Store.set_state("game", GameConstants.GAME_COMBAT)

func spawn_enemy(creature_id:String) -> void:
  var _enemies = get_tree().get_nodes_in_group("enemies")

  if _enemies.size() < _enemy_spawns.size():
    var _new_creature := creature_scene.instance()

    _new_creature.load_enemy(creature_id)
    get_tree().get_root().add_child(_new_creature)

    for _spawn in _spawn_slots.keys():
      if _spawn_slots[_spawn] == null:
        _spawn_slots[_spawn] = _new_creature
        _new_creature.global_position = _spawn.global_position
        _new_creature.connect("creature_died", self, "_on_creature_died", [_spawn])
        break

    emit_signal("creature_spawned", _new_creature)
    print("Spawned enemy: " + creature_id)

func spawn_player(run:String = "") -> void:
  var _players = get_tree().get_nodes_in_group("players")

  if _players.size() < _player_spawns.size():
    var _new_creature := creature_scene.instance()

    _new_creature.load_player(run)
    get_tree().get_root().add_child(_new_creature)
    _new_creature.global_position = _player_spawns[_players.size() - 1].global_position
    emit_signal("creature_spawned", _new_creature)
    print("Spawned player")


func _create_wave() -> Array:
  var _wave:Array = []
  var _wave_value:float = 0
  var _max_creatures:int = _spawn_slots.keys().size()
  var _max_total_value:float = Store.state.money + 5

  while _wave.size() < _max_creatures && _wave_value < _max_total_value:
    var _potential_creature:Dictionary = _enemy_lines[randi() % _enemy_lines.size()]

    if _wave_value + _potential_creature.value <= _max_total_value:
      _wave_value += _potential_creature.value
      _wave.append(_potential_creature.id)

  return _wave

func _ready():
  Store.connect("state_changed", self, "_on_store_state_changed")

  for _spawn in _enemy_spawns:
    _spawn_slots[_spawn] = null

  _enemy_lines = []
  for _line in Depot.get_lines("creatures"):
    if _line.id != "player":
      _enemy_lines.append(_line)
