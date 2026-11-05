extends CharacterBody2D

const VELOCIDADE        : float = 220.0
const FORCA_PULO        : float = -480.0
const GRAVIDADE         : float = 980.0
const INTERVALO_PASSOS  : float = 0.35

@onready var sprite          : Sprite2D           = $Sprite2D
@onready var anim_player     : AnimationPlayer    = $AnimationPlayer
@onready var audio_pulo      : AudioStreamPlayer2D = $AudioPulo
@onready var audio_passos    : AudioStreamPlayer2D = $AudioPassos

var pode_interagir  : bool  = false
var _timer_passos   : float = 0.0
var _estava_no_chao : bool  = true


func _physics_process(delta: float) -> void:
	_aplicar_gravidade(delta)

	var direcao : float = Input.get_axis("ui_left", "ui_right")
	velocity.x = direcao * VELOCIDADE

	_processar_pulo()

	if pode_interagir and Input.is_action_just_pressed("interagir"):
		SignalBus.abrir_painel_puzzle.emit()

	move_and_slide()

	_atualizar_animacao(direcao)
	_atualizar_passos(delta, direcao)


func _aplicar_gravidade(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVIDADE * delta


func _processar_pulo() -> void:
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = FORCA_PULO
		audio_pulo.play()


func _atualizar_animacao(direcao: float) -> void:
	if not is_on_floor():
		anim_player.play("jump")
	elif direcao != 0.0:
		sprite.flip_h = direcao < 0.0
		anim_player.play("walk")
	else:
		anim_player.play("idle")


func _atualizar_passos(delta: float, direcao: float) -> void:
	if is_on_floor() and absf(direcao) > 0.0:
		_timer_passos -= delta
		if _timer_passos <= 0.0:
			audio_passos.play()
			_timer_passos = INTERVALO_PASSOS
	else:
		_timer_passos = 0.0


func _on_area_painel_body_entered(body: Node2D) -> void:
	if body == self:
		pode_interagir = true


func _on_area_painel_body_exited(body: Node2D) -> void:
	if body == self:
		pode_interagir = false
