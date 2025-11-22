extends Node

@export var spawn_interval: float = 3.0
@export var caravan_scene: PackedScene
@onready var world_state: Node = get_parent().get_node("WorldState")
@onready var river_path: Path2D = get_parent().get_node("RiverPath")
@onready var road_path: Path2D = get_parent().get_node("RoadPath")

var _timer: float = 0.0


func _process(delta: float) -> void:
	_timer += delta
	if _timer >= spawn_interval:
		_timer = 0.0
		spawn_caravan()


func spawn_caravan() -> void:
	if caravan_scene == null:
		return
	
	if world_state.city_a.stock_grain <= 0.0:
		print("Skip spawn, CityA empty")
		return
	
	# 新增：如果 CityA 几乎没货了，就不再发车
	if not world_state.can_export_from_a():
		print("Skip spawn, CityA stock too low:", world_state.city_a.stock_grain)
		return
		
	var route: String = world_state.choose_best_route()  # "road" or "river"
	print(route)
	var path: Path2D = road_path if route == "road" else river_path


	var caravan: PathFollow2D = caravan_scene.instantiate()
	caravan.route_type = route

	# 挂到对应路径下面
	path.add_child(caravan)

	# 起点从 progress = 0 开始
	caravan.progress = 0.0
