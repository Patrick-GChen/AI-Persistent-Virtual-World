extends Node2D

@export var city_name: String = "CityA"

# 城市安全度：0 ~ 1
@export_range(0.0, 1.0) var safety: float = 1.0

# 简化起见，先只做一种商品：grain（粮食）
@export var stock_grain: float = 150.0      # 库存
@export var demand_grain: float = 80.0      # 需求

# 基础价格
@export var base_price_grain: float = 10.0
# 生产和消耗
@export var produce_rate: float = 10.0
@export var consume_rate: float = 3.0

func get_price_grain() -> float:
	# 缺货越厉害，价格越高

	var shortage: float = max(demand_grain - stock_grain, 0.0)
	var demand_factor: float = 1.0 + shortage / 100.0
	# 越不安全，贸易风险补偿越高
	var safety_factor := 1.0 + (1.0 - safety)

	return base_price_grain * demand_factor * safety_factor


#  新增：每一小步更新一次城市库存（生产 - 消耗）
func tick(delta: float) -> void:
	# 生产
	stock_grain += produce_rate * delta
	# 消耗
	stock_grain -= consume_rate * delta

	# 不允许出现负库存
	if stock_grain < 0.0:
		stock_grain = 0.0
