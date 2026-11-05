extends Node2D

@onready var painel_ui       : Control = $CanvasLayer/PainelUI
@onready var label_equacao   : Label   = $CanvasLayer/PainelUI/VBoxContainer/LabelEquacao
@onready var label_feedback  : Label   = $CanvasLayer/PainelUI/VBoxContainer/LabelFeedback
@onready var botao_f1        : Button  = $CanvasLayer/PainelUI/VBoxContainer/HBoxFracoes/BotaoF1
@onready var botao_f2        : Button  = $CanvasLayer/PainelUI/VBoxContainer/HBoxFracoes/BotaoF2
@onready var botao_f3        : Button  = $CanvasLayer/PainelUI/VBoxContainer/HBoxFracoes/BotaoF3
@onready var botao_verificar : Button  = $CanvasLayer/PainelUI/VBoxContainer/BotaoVerificar

const FRACOES_DISPONIVEIS : Array = [
	{ "num": 1, "den": 4, "label": "1/4" },
	{ "num": 1, "den": 2, "label": "1/2" },
	{ "num": 1, "den": 4, "label": "1/4" },
]

const SOMA_ALVO_NUM : int = 1
const SOMA_ALVO_DEN : int = 1

var _slots : Array = [null, null, null]


func _ready() -> void:
	painel_ui.visible = false
	painel_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	$CanvasLayer.process_mode = Node.PROCESS_MODE_ALWAYS

	botao_f1.text = FRACOES_DISPONIVEIS[0].label
	botao_f2.text = FRACOES_DISPONIVEIS[1].label
	botao_f3.text = FRACOES_DISPONIVEIS[2].label

	botao_f1.pressed.connect(_on_fracao_pressionada.bind(0))
	botao_f2.pressed.connect(_on_fracao_pressionada.bind(1))
	botao_f3.pressed.connect(_on_fracao_pressionada.bind(2))
	botao_verificar.pressed.connect(_verificar_resposta)

	SignalBus.abrir_painel_puzzle.connect(_abrir_painel)


func _abrir_painel() -> void:
	_resetar_slots()
	label_feedback.text = ""
	painel_ui.visible = true
	get_tree().paused = true


func _fechar_painel() -> void:
	painel_ui.visible = false
	get_tree().paused = false


func _on_fracao_pressionada(indice: int) -> void:
	for i in range(_slots.size()):
		if _slots[i] == null:
			_slots[i] = FRACOES_DISPONIVEIS[indice]
			_atualizar_label_equacao()
			return
	label_feedback.text = "Todos os slots estao preenchidos!"


func _atualizar_label_equacao() -> void:
	var partes : Array = []
	for slot in _slots:
		partes.append(slot.label if slot != null else "[ ]")
	label_equacao.text = " + ".join(partes) + " = ?"


func _verificar_resposta() -> void:
	for slot in _slots:
		if slot == null:
			label_feedback.text = "Preencha todos os campos!"
			return

	var num_total : int = 0
	var den_comum : int = 1
	for slot in _slots:
		num_total = num_total * slot.den + slot.num * den_comum
		den_comum  = den_comum * slot.den

	var mdc_val : int = _mdc(abs(num_total), abs(den_comum))
	num_total  /= mdc_val
	den_comum  /= mdc_val

	if num_total == SOMA_ALVO_NUM and den_comum == SOMA_ALVO_DEN:
		_on_puzzle_correto()
	else:
		_on_puzzle_errado()


func _on_puzzle_correto() -> void:
	label_feedback.text = "CORRETO! A ponte se une!"
	label_equacao.text   = "1/4 + 1/2 + 1/4 = 1"
	await get_tree().create_timer(1.5, true).timeout
	_fechar_painel()
	SignalBus.puzzle_resolvido.emit()


func _on_puzzle_errado() -> void:
	label_feedback.text = "Soma incorreta! Tente novamente."
	SignalBus.resposta_errada.emit()
	await get_tree().create_timer(1.2, true).timeout
	_resetar_slots()
	label_feedback.text = "Dica: a soma deve ser igual a 1 inteiro."


func _resetar_slots() -> void:
	for i in range(_slots.size()):
		_slots[i] = null
	_atualizar_label_equacao()


func _mdc(a: int, b: int) -> int:
	while b != 0:
		var temp : int = b
		b = a % b
		a = temp
	return a