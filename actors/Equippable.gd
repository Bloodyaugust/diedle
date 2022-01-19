extends Node2D

var data:Dictionary

func load_equippable(id:String) -> void:
  data = Depot.get_line("equipment", id)
