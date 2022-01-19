extends Control

const equippable_scene:PackedScene = preload("res://views/components/Equippable.tscn")

var creature

onready var _name:Label = find_node("Name")
onready var _health:ProgressBar = find_node("Health")
onready var _attack:ProgressBar = find_node("Attack")
onready var _attack_damage:Label = find_node("AttackDamage")
onready var _attack_dps:Label = find_node("AttackDPS")
onready var _value:Label = find_node("Value")
onready var _equipment_container:Control = find_node("Equipment")

func _on_creature_equipment_changed() -> void:
  GDUtil.queue_free_children(_equipment_container)

  var _equipment:Array = creature.get_equipment()
  for _item in _equipment:
    var _new_equippable_component = equippable_scene.instance()

    _new_equippable_component.data = _item.data
    _equipment_container.add_child(_new_equippable_component)

func _on_creature_changed() -> void:
  _name.text = creature.data.id
  _value.text = "Value: " + str(creature.data.value)
  _attack_damage.text = str(creature.get_total_attribute("damage"))
  _attack_dps.text = "(" + str(stepify((1 / creature.get_total_attribute("attack-speed")) * creature.get_total_attribute("damage"), 0.01)) + "/sec)"
  _attack.value = lerp(100, 0, creature._time_to_attack / creature.get_total_attribute("attack-speed"))
  _health.value = lerp(0, 100, creature._current_health / creature.get_total_attribute("health"))

func _ready():
  creature.connect("creature_equipment_changed", self, "_on_creature_equipment_changed")
  creature.connect("creature_changed", self, "_on_creature_changed")

  _on_creature_equipment_changed()
