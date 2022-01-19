extends Node

signal creature_spawned(creature)

const creature_scene:PackedScene = preload("res://actors/Creature.tscn")

func spawn_enemy(creature_id:String) -> void:
  var _new_creature := creature_scene.instance()

  _new_creature.load_enemy(creature_id)
  get_tree().get_root().add_child(_new_creature)
  emit_signal("creature_spawned", _new_creature)
  print("Spawned enemy: " + creature_id)

func spawn_player() -> void:
  var _new_creature := creature_scene.instance()

  _new_creature.load_player()
  get_tree().get_root().add_child(_new_creature)
  emit_signal("creature_spawned", _new_creature)
  print("Spawned player")
