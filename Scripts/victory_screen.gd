extends Control

@onready var money = $Panel/Money
@onready var flight_coins_accumulated = $"Panel/FlightCoins Accumulated"
@onready var total_time = $"Panel/Total Time"
var progress := 0.0


var start_earned = GameManager.earned_money
var end_earned = 0.0
var start_total = GameManager.total_money
var end_total = GameManager.total_money + start_earned
var tweening = false
var speed_mod:float = 10.0

func _ready():
	SoundBus.rolling_suitcase.stop()

	update_labels()
	await get_tree().create_timer(1.0).timeout
	$VictoryAnims.play("MoneyDrop")
	await $VictoryAnims.animation_finished
	transfer_money()

func _on_next_pressed():
	SoundBus.button.play()
	TransitionEffect.transition_to_scene("res://Scenes/shop.tscn")
	
func _process(delta: float) -> void:

	if tweening:
		print(speed_mod)
		speed_mod = speed_mod * (1.0+(delta/10.0))
		GameManager.earned_money = max(0, GameManager.earned_money - delta * 100 * speed_mod * speed_mod * speed_mod * .1)
		GameManager.total_money = min(end_total, GameManager.total_money + delta * 100 * speed_mod * speed_mod * speed_mod * .1)
		$blip.pitch_scale = speed_mod/11.0
		update_labels()
		if GameManager.total_money == end_total:
			$VictoryAnims.play("Fade")
			tweening = false
			$blip.stop()
	

func transfer_money():
	start_earned = GameManager.earned_money
	end_earned = 0.0
	speed_mod = 10.0
	start_total = GameManager.total_money
	end_total = GameManager.total_money + start_earned
	
	var tween:Tween = create_tween()
	$blip.play(0)
	tweening = true
	# Use a dummy value to tween progress (0.0 to 1.0)
	progress = 0

	
func _on_tween_finished():
	progress = 1.0
	update_labels()
	
func update_labels():

	var val = "d.%02d"
	var str = "$%0" + str(digit_count(GameManager.total_money + GameManager.earned_money) - 2) + val
	
	$"Panel/New Money".text = "+" + str % [GameManager.earned_money / 100, GameManager.earned_money % 100]
	$Panel/TotalMoney.text = (str) % [GameManager.total_money / 100, GameManager.total_money % 100]

func digit_count(n: int) -> int:
	return str(abs(n)).length()
