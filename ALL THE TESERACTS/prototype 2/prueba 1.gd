extends CharacterBody3D

var hypercube_vertices = []
var hypercube_edges = []
var hypercube_faces = []
var rotation_angle = 0.0

func _ready():
	generate_hypercube()
	set_process(true)

func _process(delta):
	rotation_angle += delta
	draw_hypercube()

func generate_hypercube():
	var cube_vertices = [
		Vector3(-1, -1, -1),
		Vector3(1, -1, -1),
		Vector3(1, 1, -1),
		Vector3(-1, 1, -1),
		Vector3(-1, -1, 1),
		Vector3(1, -1, 1),
		Vector3(1, 1, 1),
		Vector3(-1, 1, 1)
	]
	for vertex in cube_vertices:
		hypercube_vertices.append(Vector4(vertex.x, vertex.y, vertex.z, -1))
		hypercube_vertices.append(Vector4(vertex.x, vertex.y, vertex.z, 1))
	
	# Definir las aristas del hipercubo
	hypercube_edges = [
		[0, 1], [1, 2], [2, 3], [3, 0],
		[4, 5], [5, 6], [6, 7], [7, 4],
		[0, 4], [1, 5], [2, 6], [3, 7],
		[8, 9], [9, 10], [10, 11], [11, 8],
		[12, 13], [13, 14], [14, 15], [15, 12],
		[8, 12], [9, 13], [10, 14], [11, 15],
		[0, 8], [1, 9], [2, 10], [3, 11],
		[4, 12], [5, 13], [6, 14], [7, 15]
	]

	# Definir las caras del hipercubo
	hypercube_faces = [
		[0, 1, 2, 3], [4, 5, 6, 7], [0, 1, 5, 4], [1, 2, 6, 5],
		[2, 3, 7, 6], [3, 0, 4, 7], [8, 9, 10, 11], [12, 13, 14, 15],
		[8, 9, 13, 12], [9, 10, 14, 13], [10, 11, 15, 14], [11, 8, 12, 15],
		[0, 8, 9, 1], [1, 9, 10, 2], [2, 10, 11, 3], [3, 11, 8, 0],
		[4, 12, 13, 5], [5, 13, 14, 6], [6, 14, 15, 7], [7, 15, 12, 4]
	]

func rotate_4d(vertex, angle):
	var cos_angle = cos(angle)
	var sin_angle = sin(angle)
	return Vector4(
		vertex.x * cos_angle - vertex.w * sin_angle,
		vertex.y,
		vertex.z,
		vertex.x * sin_angle + vertex.w * cos_angle
	)

func project_to_3d(vertex4):
	var w = 2 / (2 - vertex4.w)
	return Vector3(vertex4.x * w, vertex4.y * w, vertex4.z * w)

func draw_hypercube():
	var mesh_instance = get_node("MeshInstance3D")
	var array_mesh = ArrayMesh.new()
	var vertices = PackedVector3Array()
	var indices = PackedInt32Array()
	
	var projected_vertices = []
	for vertex4 in hypercube_vertices:
		var rotated_vertex = rotate_4d(vertex4, rotation_angle)
		var vertex3 = project_to_3d(rotated_vertex)
		projected_vertices.append(vertex3)
		vertices.append(vertex3)
	
	# Añadir aristas como líneas
	for edge in hypercube_edges:
		indices.append(edge[0])
		indices.append(edge[1])
	
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_INDEX] = indices
	
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)
	
	mesh_instance.mesh = array_mesh
	
	# Mensajes de depuración
	print("Número de vértices proyectados: ", projected_vertices.size())
	print("Número de índices: ", indices.size())

	# Contar el número de aristas proyectadas
	var num_aristas = float(indices.size()) / 2.0
	print("Número de aristas proyectadas: ", num_aristas)

	if indices.size() % 2 != 0:
		print("Error: La cantidad de índices no es múltiplo de 2")
	else:
		print("Los índices son correctos")
