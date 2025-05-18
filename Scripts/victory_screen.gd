extends Control

@onready var money = $Panel/Money
@onready var flight_coins_accumulated = $"Panel/FlightCoins Accumulated"
@onready var total_time = $"Panel/Total Time"
@onready var next = $Next
@onready var victory_anims = $VictoryAnims

var progress := 0.0
var start_earned = GameManager.earned_money
var end_earned = 0.0
var start_total = GameManager.total_money
var end_total = GameManager.total_money + start_earned
var tweening = false
var tweening2 = false
var speed_mod:float = 10.0

var time_counter:float = 0

#region TODO update GameManager Time to reset to 0
# GameManager.level_time
# print(round(GameManager.level_time, 2))
#endregion

func _ready():
	GameManager.total_total_money += GameManager.earned_money
	GameManager.total_total_time += GameManager.level_time
	$"Panel/Total Time".text = "Total Time: " + ("%.2f" % time_counter)
	
	print(GameManager.level_time)
	SoundBus.rolling_suitcase.stop()
	update_labels()
	next.disabled = true
	await get_tree().create_timer(1.0).timeout
	victory_anims.play("MoneyDrop")
	await victory_anims.animation_finished
	transfer_money()
	

func _on_next_pressed():
	$Next.disabled = true
	SoundBus.button.play()
	if GameManager.current_level >= 10:
		TransitionEffect.transition_to_scene("res://Scenes/game_complete.tscn")
	else:
		TransitionEffect.transition_to_scene("res://Scenes/shop.tscn")
	
func _process(delta: float) -> void:
	
	if tweening:
		#print(speed_mod)
		speed_mod = speed_mod * (1.0+(delta/10.0))
		GameManager.earned_money = max(0, GameManager.earned_money - delta * 100 * speed_mod * speed_mod * speed_mod * .1)
		GameManager.total_money = min(end_total, GameManager.total_money + delta * 100 * speed_mod * speed_mod * speed_mod * .1)
		$blip.pitch_scale = speed_mod/11.0
		update_labels()
		if GameManager.total_money == end_total:
			victory_anims.play("Fade")
			tweening = false
			$blip.stop()
			$blip.pitch_scale = 1.0
			
			do_wait()
			
			
	if tweening2:
		
		#print("time count: ", time_counter, " delta: ", delta, " delta*100", delta*100.0)
		time_counter = min(GameManager.level_time, time_counter + delta * 20.0)
		$"Panel/Total Time".text = "Total Time: " + ("%.2f" % time_counter) + "s"
		if time_counter >= GameManager.level_time:
			tweening2 = false
			next.disabled = false
			$blip.stop()

func do_wait():
	await get_tree().create_timer(1.0).timeout
	$blip.play(0)
	tweening2 = true
				
func transfer_money():
	start_earned = GameManager.earned_money
	end_earned = 0.0
	speed_mod = 10.0
	start_total = GameManager.total_money
	end_total = GameManager.total_money + start_earned
	

	$blip.play(0)
	tweening = true
	# Use a dummy value to tween progress (0.0 to 1.0)
	progress = 0


	
func update_labels():

	var val = "d.%02d"
	var str = "$%0" + str(digit_count(GameManager.total_money + GameManager.earned_money) - 2) + val
	
	$"Panel/New Money".text = "+" + str % [GameManager.earned_money / 100, GameManager.earned_money % 100]
	$Panel/TotalMoney.text = (str) % [GameManager.total_money / 100, GameManager.total_money % 100]

func digit_count(n: int) -> int:
	return str(abs(n)).length()
