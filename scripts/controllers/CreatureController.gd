extends Node

signal creature_spawned(creature)

const creature_scene:PackedScene = preload("res://actors/Creature.tscn")

onready var _enemy_spawns:Array = get_tree().get_nodes_in_group("enemy_spawns")
onready var _player_spawns:Array = get_tree().get_nodes_in_group("player_spawns")

var _spawn_slots:Dictionary

func _on_creature_died(spawn) -> void:
  _spawn_slots[spawn] = null

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

func spawn_player() -> void:
  var _players = get_tree().get_nodes_in_group("players")

  if _players.size() < _player_spawns.size():
    var _new_creature := creature_scene.instance()

    _new_creature.load_player()
    get_tree().get_root().add_child(_new_creature)
    _new_creature.global_position = _player_spawns[_players.size() - 1].global_position
    emit_signal("creature_spawned", _new_creature)
    print("Spawned player")

func _ready():  
  for _spawn in _enemy_spawns:
    _spawn_slots[_spawn] = null
