extends Node

var db:Object
var sheets:Dictionary
var guid_hash:Dictionary

func get_line(sheet_name:String, id:String) -> Dictionary:
  var _lines = get_lines(sheet_name)

  for _line in _lines:
    if _line.id == id:
      return _line

  return {}

func get_lines(sheet_name:String) -> Array:
  return get_sheet(sheet_name).lines

func get_sheet(name:String) -> Dictionary:
  for _key in sheets.keys():
    if sheets[_key].name == name:
      return sheets[_key]
  
  return {}

func _load_db() -> Object:
  var file = File.new()
  file.open("res://data/depot.dpo", File.READ)

  var json = file.get_as_text()
  file.close()

  var parsed_json = JSON.parse(json)

  return parsed_json.result

func _init():
  db = _load_db()

  for _sheet in db.sheets:
    sheets[_sheet.guid] = _sheet
    guid_hash[_sheet.guid] = _sheet

    for _line in _sheet.lines:
      guid_hash[_line.guid] = _line

  for _sheet in db.sheets:
    var _line_references:Array = []
    for _column in _sheet.columns:
      if _column.typeStr == "lineReference":
        _line_references.append(_column.name)

    for _line in _sheet.lines:
      for _line_reference in _line_references:
        _line[_line_reference] = guid_hash[_line[_line_reference]]
