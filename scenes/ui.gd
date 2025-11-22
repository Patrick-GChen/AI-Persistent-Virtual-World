extends CanvasLayer   # 如果 UI 是 CanvasLayer；如果是 Node2D 就写 Node2D

@onready var world_state: Node = get_parent().get_node("WorldState")

@onready var label_city_a: Label = $InfoPanel/VBoxContainer/Label_cityA
@onready var label_city_b: Label = $InfoPanel/VBoxContainer/Label_cityB
@onready var label_route: Label  = $InfoPanel/VBoxContainer/Label_route
@onready var label_util: Label   = $InfoPanel/VBoxContainer/Label_util
@onready var stats_label: Label = $InfoPanel/VBoxContainer/Label_governor

@onready var city_a: Node2D = get_parent().get_node("CityA")
@onready var city_b: Node2D = get_parent().get_node("CityB")

@onready var governor = get_parent().get_node("Governor")


func _process(delta: float) -> void:
	# 城市 A
	label_city_a.text = "CityA  库存: %.1f  需求: %.1f  价格: %.2f" % [
		city_a.stock_grain,
		city_a.demand_grain,
		city_a.get_price_grain()
	]

	# 城市 B
	label_city_b.text = "CityB  库存: %.1f  需求: %.1f  价格: %.2f" % [
		city_b.stock_grain,
		city_b.demand_grain,
		city_b.get_price_grain()
	]

	# 最近一次路线决策
	label_route.text = "Last route: %s" % world_state.last_route

	# 最近一次效用
	label_util.text = "U_road: %.1f   U_river: %.1f" % [
		world_state.last_road_u,
		world_state.last_river_u
	]
	# ----------- Governor 状态（重点）-----------
	if governor:
		if stats_label == null:
			print("stats_label is NULL!")  # 如果这句出来，说明路径写错了
		else:
			stats_label.text = """
				Governor 状态\n
				Decisions: %d\n
				Road: %d\n
				River: %d\n
				Bias: %.3f\n
				Exploration: %.3f
				""" % [
				governor.total_decisions,
				governor.road_count,
				governor.river_count,
				governor.river_bias,
				governor.exploration_rate
				]
