@tool
extends CharacterBody3D

@export var w_position: float = 0.0
@export var w_rotation: float = 0.0

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

var hypercube_vertices = []
var debug_printed = false

func _ready():
	print("Calling generate_hypercube from _ready")
	generate_hypercube()
	print("Hypercube vertices after generate_hypercube in _ready: ", hypercube_vertices.size())
	set_process(true)

func _process(_delta):
	if not debug_printed:
		print("Calling draw_hypercube from _process with debug")
		print("Hypercube vertices before draw_hypercube in _process: ", hypercube_vertices.size())
		draw_hypercube(true)
		debug_printed = true
	else:
		draw_hypercube(false)

func generate_hypercube():
	print("Generating hypercube vertices")
	hypercube_vertices = []  # Aseguramos que hypercube_vertices esté inicializado
	for vertex in cube_vertices:
		hypercube_vertices.append(Vector4(vertex.x, vertex.y, vertex.z, -1))
		hypercube_vertices.append(Vector4(vertex.x, vertex.y, vertex.z, 1))
		print("Added vertex: ", Vector4(vertex.x, vertex.y, vertex.z, -1))
		print("Added vertex: ", Vector4(vertex.x, vertex.y, vertex.z, 1))
	print("Hypercube vertices generated: ", hypercube_vertices.size())

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
	var w = 2 / (2 - vertex4.w + w_position)
	return Vector3(vertex4.x * w, vertex4.y * w, vertex4.z * w)

func sd_hypercube(p, b):
	var d = abs(p) - b
	return min(max(d.x, max(d.y, max(d.z, d.w))), 0.0) + max(d, Vector4.ZERO).length()

func draw_hypercube(should_print_debug=true):
	#print("Drawing hypercube")
	var mesh_instance = get_node("MeshInstance3D")
	if not mesh_instance:
		print("Error: MeshInstance3D no encontrado")
		return
	
	var array_mesh = ArrayMesh.new()
	var vertices = PackedVector3Array()
	var indices = PackedInt32Array()
	var uvs = PackedVector2Array()
	var tangents = PackedFloat32Array()
	
	if hypercube_vertices == null or hypercube_vertices.size() == 0:
		print("Error: hypercube_vertices está vacío o no inicializado")
		return
	
	var projected_vertices = []
	for vertex4 in hypercube_vertices:
		if vertex4 == null:
			print("Error: vertex4 es null")
			continue
		var rotated_vertex = rotate_4d(vertex4, w_rotation)
		var vertex3 = project_to_3d(rotated_vertex)
		projected_vertices.append(vertex3)
		vertices.append(vertex3)
		uvs.append(Vector2(0, 0))  # Añadimos coordenadas UV por defecto
		tangents.append_array([1.0, 0.0, 0.0, 1.0])  # Añadimos tangentes por defecto (4 componentes por tangente)
	
	# Definir las caras del hipercubo
	var faces = [
		[0, 1, 2, 3], [4, 5, 6, 7], [0, 1, 5, 4], [2, 3, 7, 6],
		[0, 3, 7, 4], [1, 2, 6, 5], [8, 9, 10, 11], [12, 13, 14, 15],
		[8, 9, 13, 12], [10, 11, 15, 14], [8, 11, 15, 12], [9, 10, 14, 13],
		[0, 1, 9, 8], [2, 3, 11, 10], [4, 5, 13, 12], [6, 7, 15, 14],
		[0, 3, 11, 8], [1, 2, 10, 9], [4, 7, 15, 12], [5, 6, 14, 13]
	]
	
	for face in faces:
		indices.append(face[0])
		indices.append(face[1])
		indices.append(face[2])
		indices.append(face[2])
		indices.append(face[3])
		indices.append(face[0])
	
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_INDEX] = indices
	arrays[Mesh.ARRAY_TEX_UV] = uvs
	arrays[Mesh.ARRAY_TANGENT] = tangents
	
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	
	mesh_instance.mesh = array_mesh
	
	if should_print_debug:
		print("Número de vértices proyectados: ", projected_vertices.size())
		print("Número de índices: ", indices.size())
		var num_aristas = float(indices.size()) / 2.0
		print("Número de aristas proyectadas: ", num_aristas)
		if indices.size() % 2 != 0:
			print("Error: La cantidad de índices no es múltiplo de 2")
		else:
			print("Los índices son correctos")









