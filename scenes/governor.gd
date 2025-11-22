extends Node

# 探索率：0 表示完全贪心，1 表示完全随机
@export var exploration_rate: float = 0.2

# 以后可以变成 RL 的参数；现在先简单存点统计
var total_decisions: int = 0
var road_count: int = 0
var river_count: int = 0
var river_bias: float = 0.0


# WorldState 会在每次做路线评估后调用这个函数
func decide_route(road_u: float, river_u: float) -> String:
	total_decisions += 1

	# 1. 探索：以 exploration_rate 的概率随机选一条路
	if randf() < exploration_rate:
		var r = "road" if (randi() % 2 == 0) else "river"
		_record_choice(r)
		return r

	# 2. 利用：选 utility 更高的那条
	if road_u >= river_u:
		_record_choice("road")
		return "road"
	else:
		_record_choice("river")
		return "river"


# 以后可以用来给 RL 记录 reward，现在先简单统计
func _record_choice(route: String) -> void:
	if route == "road":
		road_count += 1
	elif route == "river":
		river_count += 1


# （可选）WorldState 在每次完成贸易后，可以把结果反馈给 Governor
func report_trade(route: String, profit: float) -> void:
	# 现在先打印，后面可以在这里做 RL 更新
	print("[Governor] trade via ", route, " profit=", profit)
