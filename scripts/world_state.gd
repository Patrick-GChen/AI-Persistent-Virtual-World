extends Node

# 引用城市 & 路径
@onready var city_a: Node2D = get_parent().get_node("CityA")
@onready var city_b: Node2D = get_parent().get_node("CityB")
@onready var river_path: Path2D = get_parent().get_node("RiverPath")
@onready var road_path: Path2D  = get_parent().get_node("RoadPath")
@onready var governor: Node = get_parent().get_node("Governor")

# 路线参数（可以之后在 Inspector 里慢慢调）
@export var road_speed: float = 140.0
@export var river_speed: float = 80.0

@export var road_capacity: float = 40.0
@export var river_capacity: float = 120.0

@export var road_risk_base: float = 0.15   # 基础风险
@export var river_risk_base: float = 0.05

@export var cost_per_time: float = 1.5     # 单位时间运输成本

@export var min_cargo_threshold: float = 5.0   # 最少发货量阈值，可以自己调


var last_route: String = ""         # 最近一次选择的路线
var last_road_u: float = 0.0        # 最近一次 road 效用
var last_river_u: float = 0.0       # 最近一次 river 效用
var total_trades := 0   			# 用来统计完成的贸易数量

var econ_timer: float = 0.0
@export var econ_step: float = 1.0   # 每隔 1 秒经济更新一次，可以在 Inspector 调

func _process(delta: float) -> void:
	econ_timer += delta
	while econ_timer >= econ_step:
		econ_timer -= econ_step
		_update_economy(econ_step)

func _update_economy(dt: float) -> void:
	# 让两个城市根据生产/消耗更新库存
	city_a.tick(dt)
	city_b.tick(dt)
	
func _get_path_length(path: Path2D) -> float:
	if path and path.curve:
		return path.curve.get_baked_length()
	return 1.0


func evaluate_route(
		from_city: Node2D,
		to_city: Node2D,
		route_type: String
	) -> float:
	# 1. 拿路径 & 参数
	var path: Path2D
	var speed: float
	var capacity: float
	var base_risk: float

	if route_type == "road":
		path = road_path
		speed = road_speed
		capacity = road_capacity
		base_risk = road_risk_base
	else:
		path = river_path
		speed = river_speed
		capacity = river_capacity
		base_risk = river_risk_base


	# 2. 距离 / 时间 / 运输成本
	var distance: float = _get_path_length(path)
	var travel_time: float = distance / max(speed, 1.0)
	var transport_cost_per_unit: float = travel_time * cost_per_time

	# 3. 商品价格（调用 city.gd 里的函数）
	var from_price: float = from_city.get_price_grain()
	var to_price: float = to_city.get_price_grain()
	var profit_per_unit: float = to_price - from_price - transport_cost_per_unit

	# 4. 风险惩罚：两城越不安全，惩罚越高
	var c_from: float = from_city.safety
	var c_to: float = to_city.safety
	var avg_safety: float = (c_from + c_to) * 0.5
	var risk_penalty: float = base_risk * (2.0 - avg_safety * 2.0) * 10.0

	# 5. 总效用：总利润 - 风险惩罚
	var total_profit: float = profit_per_unit * capacity
	var utility: float = total_profit - risk_penalty
	return utility



func can_export_from_a() -> bool:
	return city_a.stock_grain >= min_cargo_threshold


func choose_best_route() -> String:
	var road_u: float = evaluate_route(city_a, city_b, "road")
	var river_u: float = evaluate_route(city_a, city_b, "river")

	last_road_u = road_u
	last_river_u = river_u

	var route: String = "road"

	if governor:
		route = governor.decide_route(road_u, river_u)
	else:
		# fallback：如果没找到 governor，就用原来的逻辑
		route = "road" if road_u >= river_u else "river"

	last_route = route
	return route






func apply_trade_from_a_to_b(cargo_amount: float, route: String) -> void:
	var actual_cargo: float = min(cargo_amount, city_a.stock_grain)

	if actual_cargo <= 0.0:
		print("Skip trade because no stock in CityA, stock=", city_a.stock_grain)
		return

	# 更新库存
	city_a.stock_grain -= actual_cargo
	city_b.stock_grain += actual_cargo

	total_trades += 1

	# 粗略算一个利润（先不考虑运输成本，简单一点）
	var from_price: float = city_a.get_price_grain()
	var to_price: float = city_b.get_price_grain()
	var profit_per_unit: float = to_price - from_price
	var profit: float = profit_per_unit * actual_cargo

	print("[TRADE #", total_trades, "] route=", route,
		" cargo=", actual_cargo,
		"  A_stock=", city_a.stock_grain,
		"  B_stock=", city_b.stock_grain,
		"  profit=", profit)

	# ★ 把这次贸易的结果告诉 Governor（以后 RL 就在这里更新）
	if governor:
		governor.report_trade(route, profit)
