extends Node2D

const equipment_scene:PackedScene = preload("res://actors/Equippable.tscn")

enum CREATURE_STATES {
  IDLE,
  COMBAT
}

signal creature_changed
signal creature_equipment_changed
signal creature_died

var data:Dictionary

onready var _equipment_container = find_node("Equipment")
onready var _state = CREATURE_STATES.IDLE
onready var _tree := get_tree()

var _current_health:float
var _target
var _time_to_attack:float

func add_equipment(equipment_id:String) -> void:
  var _new_equipment = equipment_scene.instance()

  _new_equipment.load_equippable(equipment_id)
  _equipment_container.add_child(_new_equipment)
  emit_signal("creature_equipment_changed")

func attack(creature:Node2D) -> void:
  var _attack_data = {
    "damage": get_total_attribute("damage")
  }

  _target.damage(_attack_data)
  print(data.id + " attacked: " + _target.data.id + " for " + str(_attack_data.damage))

func damage(attack_data:Dictionary) -> void:
  var _damage_after_defense = attack_data.damage - get_total_attribute("defense")

  _current_health -= _damage_after_defense
  emit_signal("creature_changed")
  print(data.id + " was damaged for " + str(_damage_after_defense))

  if _current_health <= 0:
    emit_signal("creature_died")
    queue_free()
    print(data.id + " died")

func get_equipment() -> Array:
  return _equipment_container.get_children()

func get_total_attribute(attribute:String) -> float:
  var _attribute_value = data[attribute]
  var _equipment = _equipment_container.get_children()

  for _item in _equipment:
    if _item.data.attribute == attribute:
      if attribute == "attack-speed":
        _attribute_value -= _item.data["attribute-amount"]
      else:
        _attribute_value += _item.data["attribute-amount"]

  return _attribute_value

func load_enemy(id:String) -> void:
  data = Depot.get_line("creatures", id)

  _equipment_container = find_node("Equipment")

  _current_health = get_total_attribute("health")
  _time_to_attack = _get_time_to_attack()
  add_to_group("enemies")

func load_player() -> void:
  data = Depot.get_line("creatures", "player")

  _equipment_container = find_node("Equipment")

  add_equipment("wooden-sword")
  add_equipment("attack-speed-necklace")
  add_equipment("attack-speed-necklace")
  add_equipment("attack-speed-necklace")
  add_equipment("attack-speed-necklace")
  add_equipment("attack-speed-necklace")
  add_equipment("attack-speed-necklace")
  add_equipment("attack-speed-necklace")
  add_equipment("attack-speed-necklace")

  _current_health = get_total_attribute("health")
  _time_to_attack = _get_time_to_attack()
  add_to_group("player")

func _find_target() -> void:
  var _potential_targets:Array

  if is_in_group("player"):
    _potential_targets = _tree.get_nodes_in_group("enemies")
  else:
    _potential_targets = _tree.get_nodes_in_group("player")

  if _potential_targets.size() > 0:
    _target = _potential_targets[0]
  else:
    _target = null

func _get_time_to_attack() -> float:
  var _attack_speed = get_total_attribute("attack-speed")

  if _time_to_attack < 0:
    _attack_speed += _time_to_attack

  return _attack_speed

func _process(delta):
  emit_signal("creature_changed")

  if _current_health > 0:
    if !GDUtil.reference_safe(_target):
      _find_target()
  
    if GDUtil.reference_safe(_target):
      _state = CREATURE_STATES.COMBAT

    else:
      _state = CREATURE_STATES.IDLE

  match _state:
    CREATURE_STATES.COMBAT:
      _time_to_attack -= delta

      if _time_to_attack <= 0:
          attack(_target)
          _time_to_attack = _get_time_to_attack()

    CREATURE_STATES.IDLE:
      _time_to_attack = _get_time_to_attack()
