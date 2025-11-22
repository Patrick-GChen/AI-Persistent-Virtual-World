extends PathFollow2D

@export var speed: float = 150.0
@export var cargo_amount: float = 40.0
@export var route_type: String = "road"  # "road" or "river"

var world_state: Node = null


func _ready() -> void:
	# 找到 WorldState（Main 场景里）
	if get_tree().get_root().has_node("Main/WorldState"):
		world_state = get_tree().get_root().get_node("Main/WorldState")
	# 确保不自动循环，自己判断结束
	loop = false

func _process(delta: float) -> void:
	progress += speed * delta

	# 到路径终点：认为到达 B 城，做结算
	if progress >=  get_curve_length():
		_on_arrive_destination()


func get_curve_length() -> float:
	var p = get_parent()
	while p and not (p is Path2D):
		p = p.get_parent()

	if p and p.curve:
		return p.curve.get_baked_length()

	return 1000.0



func _on_arrive_destination() -> void:
	print("caravan arrived id=", get_instance_id(),
		" route=", route_type, " cargo=", cargo_amount,
		" world_state=", world_state)
		
	if world_state:
		world_state.apply_trade_from_a_to_b(cargo_amount, route_type)
	else:
		print("world_state NOT FOUND!!")
	queue_free()
