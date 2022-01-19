extends Control

const _creature_scene:PackedScene = preload("res://views/components/Creature.tscn")

onready var _creatures_container:Control = find_node("Creatures")

func _on_creature_died(creature_component) -> void:
  creature_component.queue_free()

func _on_creature_spawned(creature) -> void:
  var _new_creature_component := _creature_scene.instance()

  _new_creature_component.creature = creature
  creature.connect("creature_died", self, "_on_creature_died", [_new_creature_component])

  _creatures_container.add_child(_new_creature_component)

func _ready():
  CreatureController.connect("creature_spawned", self, "_on_creature_spawned")
