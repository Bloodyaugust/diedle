extends Control

onready var _enemy_list:ItemList = find_node("EnemyList")
onready var _load_run:Button = find_node("LoadRun")
onready var _spawn_enemy:Button = find_node("SpawnEnemy")
onready var _spawn_player:Button = find_node("SpawnPlayer")

func _on_store_state_changed(state_key: String, substate) -> void:
  match state_key:
    "debug":
      visible = substate

func _on_load_run_pressed() -> void:
  Store.set_state("run", "debug_run")
  CreatureController.spawn_player("debug_run")
  Store.set_state("money", Store.persistent_store.runs["debug_run"].money)
  Store.set_state("game", GameConstants.GAME_CAMP)

func _on_spawn_enemy_pressed() -> void:
  CreatureController.spawn_enemy(_enemy_list.get_item_text(_enemy_list.get_selected_items()[0]))

func _on_spawn_player_pressed() -> void:
  Store.persistent_store.runs["debug_run"] = {
    "equipment": [],
    "money": 0
  }
  Store.save_persistent_store()
  Store.set_state("run", "debug_run")
  Store.set_state("game", GameConstants.GAME_CAMP)
  Store.set_state("money", 0)
  CreatureController.spawn_player()

func _input(event):
  if event.is_action_pressed("debug"):
    Store.set_state("debug", !Store.state.debug)

func _ready():
  Store.connect("state_changed", self, "_on_store_state_changed")

  visible = false

  var _creatures:Array = Depot.get_lines("creatures")
  for _creature in _creatures:
    if _creature.id != "player":
      _enemy_list.add_item(_creature.id)

  _enemy_list.select(0)

  _load_run.connect("pressed", self, "_on_load_run_pressed")
  _spawn_enemy.connect("pressed", self, "_on_spawn_enemy_pressed")
  _spawn_player.connect("pressed", self, "_on_spawn_player_pressed")
