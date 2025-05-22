extends MeshInstance3D

#var hypercube_vertices = []
#var rotation_angle = 0.0
#
#func _ready():
	#generate_hypercube()
	#set_process(true)
#
#func _process(delta):
	#rotation_angle += delta
	#draw_hypercube()
#
#func generate_hypercube():
	#var cube_vertices = [
		#Vector3(-1, -1, -1),
		#Vector3(1, -1, -1),
		#Vector3(1, 1, -1),
		#Vector3(-1, 1, -1),
		#Vector3(-1, -1, 1),
		#Vector3(1, -1, 1),
		#Vector3(1, 1, 1),
		#Vector3(-1, 1, 1)
	#]
	#for vertex in cube_vertices:
		#hypercube_vertices.append(Vector4(vertex.x, vertex.y, vertex.z, -1))
		#hypercube_vertices.append(Vector4(vertex.x, vertex.y, vertex.z, 1))
#
#func rotate_4d(vertex, angle):
	#var cos_angle = cos(angle)
	#var sin_angle = sin(angle)
	#var rotated_vertex = Vector4(
		#vertex.x * cos_angle - vertex.w * sin_angle,
		#vertex.y,
		#vertex.z,
		#vertex.x * sin_angle + vertex.w * cos_angle
	#)
	#return rotated_vertex
#
#func project_to_3d(vertex4):
	#var w = 2 / (2 - vertex4.w)
	#return Vector3(vertex4.x * w, vertex4.y * w, vertex4.z * w)
#
#func draw_hypercube():
	#var mesh_instance = get_node("MeshInstance3D")
	#var array_mesh = ArrayMesh.new()
	#var vertices = PackedVector3Array()
	#
	#for vertex4 in hypercube_vertices:
		#var rotated_vertex = rotate_4d(vertex4, rotation_angle)
		#var vertex3 = project_to_3d(rotated_vertex)
		#vertices.append(vertex3)
	#
	#var arrays = []
	#arrays.resize(Mesh.ARRAY_MAX)
	#arrays[Mesh.ARRAY_VERTEX] = vertices
	#
	#array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_POINTS, arrays)
	#
	## Create a new MeshInstance3D and assign the mesh
	#mesh_instance.mesh = array_mesh

