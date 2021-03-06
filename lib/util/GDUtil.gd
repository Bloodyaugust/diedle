extends Node

static func centroid(points:Array) -> Vector2:
  var centroid:Vector2 = Vector2.ZERO

  if points.size() == 0:
    return centroid

  for _point in points:
    centroid += _point

  centroid = centroid / float(points.size())

  return centroid

static func free_children(node):
  for n in node.get_children():
      n.free()

static func tilemap_global_cell_position(tilemap: TileMap, position: Vector2) -> Vector2:
  return tilemap.to_global(tilemap.map_to_world(tilemap.world_to_map(tilemap.to_local(position))) + (tilemap.cell_size / 2))

static func queue_free_children(node):
  for n in node.get_children():
      n.queue_free()

static func reference_safe(node:Node) -> bool:
  return node != null && !node.is_queued_for_deletion() && is_instance_valid(node)
