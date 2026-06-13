class_name MST
extends RefCounted

var n: int
var edges: Array = []

var _parent := {}
var _rank := {}

const CYCLE_PROBA = 0.1

func _init(size: int):
	n = size
	_generate()


func _generate() -> void:
	var all_edges: Array = []

	# Create nodes
	for x in range(-n, n + 1):
		for y in range(-n, n + 1):
			var p = Vector2i(x, y)
			_parent[p] = p
			_rank[p] = 0

			# Add grid edges (only right and down to avoid duplicates)
			if x < n:
				all_edges.append([p, Vector2i(x + 1, y)])

			if y < n:
				all_edges.append([p, Vector2i(x, y + 1)])

	# Randomize edge order
	all_edges.shuffle()
	edges = [[Vector2i(-1, 0), Vector2i(0, 0)], [Vector2i(0, -1), Vector2i(0, 0)],
	[Vector2i(0, 0), Vector2i(0, 1)], [Vector2i(0, -0), Vector2i(1, 0)]]
	for edge in edges:
		_union(edge[0], edge[1])
		
	# Kruskal
	for edge in all_edges:
		var a: Vector2i = edge[0]
		var b: Vector2i = edge[1]

		if _find(a) != _find(b) or randf() < CYCLE_PROBA:
			_union(a, b)
			edges.append(edge)


func _find(v):
	if _parent[v] != v:
		_parent[v] = _find(_parent[v])
	return _parent[v]


func _union(a, b) -> void:
	var ra = _find(a)
	var rb = _find(b)

	if ra == rb:
		return

	if _rank[ra] < _rank[rb]:
		_parent[ra] = rb
	elif _rank[ra] > _rank[rb]:
		_parent[rb] = ra
	else:
		_parent[rb] = ra
		_rank[ra] += 1
