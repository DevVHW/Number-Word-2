extends Node2D
## Painel de frações: o jogador escolhe 3 frações cuja soma seja 1 inteiro.

@onready var painel_ui       : PanelContainer = $CanvasLayer/PainelUI
@onready var vbox            : VBoxContainer = $CanvasLayer/PainelUI/VBoxContainer
@onready var label_enunciado : Label   = $CanvasLayer/PainelUI/VBoxContainer/LabelEnunciado
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

const DICAS : Array = [
	"Dica: a soma das 3 frações precisa dar 1 inteiro (4/4).",
	"Dica: 1/2 é o mesmo que 2/4. Pense em quartos!",
	"Dica: 2/4 + 1/4 + 1/4 = 4/4 = 1. Quais botões valem isso?",
]

var _slots : Array = [null, null, null]
var _resolvido : bool = false
var _dica_atual : int = 0

var _barra_soma   : ProgressBar
var _label_soma   : Label
var _botao_limpar : Button
var _botao_desfazer : Button
var _botao_dica   : Button
var _botao_fechar : Button
var _som_acerto   : AudioStreamPlayer
var _som_erro     : AudioStreamPlayer
var _som_clique   : AudioStreamPlayer
var _aviso_e      : Label


func _ready() -> void:
	painel_ui.visible = false
	painel_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	$CanvasLayer.process_mode = Node.PROCESS_MODE_ALWAYS
	painel_ui.add_theme_stylebox_override("panel", UiUtil.estilo_painel())

	label_enunciado.text = "Totem: \"O Caos Numérico partiu a ponte em pedaços!\"\nMISSÃO: escolha 3 frações que, somadas, formem 1 INTEIRO.\nA ordem não importa. Use Desfazer para corrigir uma escolha."
	label_enunciado.add_theme_font_size_override("font_size", 18)
	label_enunciado.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var titulo := UiUtil.titulo("Painel das Frações", 30)
	vbox.add_child(titulo)
	vbox.move_child(titulo, 0)

	var modelo := UiUtil.botao("x")
	for b in [botao_f1, botao_f2, botao_f3, botao_verificar]:
		for estado in ["normal", "hover", "pressed", "focus", "disabled"]:
			b.add_theme_stylebox_override(estado, modelo.get_theme_stylebox("normal" if estado == "disabled" else estado))
		b.add_theme_font_override("font", UiUtil.FONTE_NEGRITO)
		b.add_theme_color_override("font_color", UiUtil.COR_TEXTO)
	modelo.queue_free()
	for b in [botao_f1, botao_f2, botao_f3]:
		b.add_theme_font_size_override("font_size", 30)
		b.add_theme_color_override("font_color", UiUtil.COR_TITULO)
	botao_verificar.add_theme_font_size_override("font_size", 22)
	botao_verificar.text = "Verificar soma"
	botao_f1.text = FRACOES_DISPONIVEIS[0].label
	botao_f2.text = FRACOES_DISPONIVEIS[1].label
	botao_f3.text = FRACOES_DISPONIVEIS[2].label
	botao_f1.pressed.connect(_on_fracao_pressionada.bind(0))
	botao_f2.pressed.connect(_on_fracao_pressionada.bind(1))
	botao_f3.pressed.connect(_on_fracao_pressionada.bind(2))
	botao_verificar.pressed.connect(_verificar_resposta)
	botao_verificar.add_theme_font_override("font", UiUtil.FONTE_NEGRITO)
	label_equacao.add_theme_font_override("font", UiUtil.FONTE_NEGRITO)
	label_equacao.add_theme_font_size_override("font_size", 26)
	label_feedback.add_theme_font_size_override("font_size", 17)
	label_feedback.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	_montar_barra_soma()
	_montar_botoes_extras()
	_montar_sons()
	_montar_aviso_interacao()

	SignalBus.abrir_painel_puzzle.connect(_abrir_painel)
	SignalBus.neo_perto_painel.connect(_on_neo_perto)


# ---------- Montagem da interface ----------

func _montar_barra_soma() -> void:
	_label_soma = UiUtil.label("Soma atual: 0", 16, UiUtil.COR_BORDA)
	_barra_soma = ProgressBar.new()
	_barra_soma.min_value = 0.0
	_barra_soma.max_value = 1.0
	_barra_soma.step = 0.0
	_barra_soma.show_percentage = false
	_barra_soma.custom_minimum_size = Vector2(0, 22)
	var cheio := StyleBoxFlat.new()
	cheio.bg_color = Color(0.35, 0.95, 0.75)
	cheio.set_corner_radius_all(8)
	var vazio := StyleBoxFlat.new()
	vazio.bg_color = Color(0.1, 0.2, 0.18)
	vazio.set_corner_radius_all(8)
	_barra_soma.add_theme_stylebox_override("fill", cheio)
	_barra_soma.add_theme_stylebox_override("background", vazio)
	var pos := label_equacao.get_index() + 1
	vbox.add_child(_label_soma)
	vbox.move_child(_label_soma, pos)
	vbox.add_child(_barra_soma)
	vbox.move_child(_barra_soma, pos + 1)


func _montar_botoes_extras() -> void:
	var linha := HBoxContainer.new()
	linha.alignment = BoxContainer.ALIGNMENT_CENTER
	linha.add_theme_constant_override("separation", 12)
	_botao_desfazer = UiUtil.botao("Desfazer", 17, 130)
	_botao_limpar = UiUtil.botao("Limpar", 17, 120)
	_botao_dica = UiUtil.botao("Dica", 17, 110)
	_botao_fechar = UiUtil.botao("Fechar (Esc)", 17, 170)
	_botao_desfazer.pressed.connect(_on_desfazer)
	_botao_limpar.pressed.connect(_on_limpar)
	_botao_dica.pressed.connect(_on_dica)
	_botao_fechar.pressed.connect(_fechar_painel)
	for b in [_botao_desfazer, _botao_limpar, _botao_dica, _botao_fechar]:
		linha.add_child(b)
	vbox.add_child(linha)
	vbox.move_child(linha, botao_verificar.get_index() + 1)


func _montar_sons() -> void:
	_som_acerto = _criar_som("res://assets/audio/acerto.wav")
	_som_erro = _criar_som("res://assets/audio/erro.wav")
	_som_clique = _criar_som("res://assets/audio/clique.wav")


func _criar_som(caminho: String) -> AudioStreamPlayer:
	var p := AudioStreamPlayer.new()
	p.stream = load(caminho)
	p.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(p)
	return p


func _montar_aviso_interacao() -> void:
	# Indicação contextual no cenário: aparece quando o Neo chega perto.
	_aviso_e = UiUtil.label("[E] Usar painel", 18, UiUtil.COR_TITULO)
	_aviso_e.add_theme_font_override("font", UiUtil.FONTE_NEGRITO)
	_aviso_e.position = Vector2(-90, -125)
	_aviso_e.size = Vector2(140, 30)
	_aviso_e.visible = false
	add_child(_aviso_e)
	var t := create_tween().set_loops()
	t.tween_property(_aviso_e, "modulate:a", 0.45, 0.6)
	t.tween_property(_aviso_e, "modulate:a", 1.0, 0.6)


# ---------- Fluxo do painel ----------

func _on_neo_perto(perto: bool) -> void:
	_aviso_e.visible = perto and not _resolvido


func _abrir_painel() -> void:
	if _resolvido:
		return
	_resetar_slots()
	label_feedback.text = ""
	painel_ui.visible = true
	SignalBus.puzzle_aberto = true
	get_tree().paused = true
	_som_clique.play()
	botao_f1.call_deferred("grab_focus")


func _fechar_painel() -> void:
	painel_ui.visible = false
	SignalBus.puzzle_aberto = false
	get_tree().paused = false


func _unhandled_input(event: InputEvent) -> void:
	if painel_ui.visible and event.is_action_pressed("pausar") and not _resolvido:
		_fechar_painel()
		get_viewport().set_input_as_handled()


func _on_fracao_pressionada(indice: int) -> void:
	for i in range(_slots.size()):
		if _slots[i] == null:
			_slots[i] = FRACOES_DISPONIVEIS[indice]
			_som_clique.play()
			label_feedback.text = ""
			_atualizar_label_equacao()
			return
	label_feedback.text = "Os 3 espaços já estão cheios. Clique em Verificar ou Limpar."


func _on_desfazer() -> void:
	# Remove só a última fração escolhida.
	for i in range(_slots.size() - 1, -1, -1):
		if _slots[i] != null:
			_slots[i] = null
			_som_clique.play()
			label_feedback.text = ""
			_atualizar_label_equacao()
			return


func _on_limpar() -> void:
	_som_clique.play()
	_resetar_slots()
	label_feedback.text = ""


func _on_dica() -> void:
	_som_clique.play()
	label_feedback.text = DICAS[_dica_atual]
	_dica_atual = min(_dica_atual + 1, DICAS.size() - 1)


func _atualizar_label_equacao() -> void:
	var partes : Array = []
	for slot in _slots:
		partes.append(slot.label if slot != null else "[  ]")
	label_equacao.text = " + ".join(partes) + " = ?"
	# Barra de progresso: quanto da unidade a soma parcial já ocupa.
	var soma := _somar(_slots)
	var valor : float = float(soma.x) / float(soma.y)
	var t := _barra_soma.create_tween()
	t.tween_property(_barra_soma, "value", min(valor, 1.0), 0.25)
	if soma.x == 0:
		_label_soma.text = "Soma atual: 0 de 1 inteiro"
	else:
		_label_soma.text = "Soma atual: %d/%d  (%s)" % [soma.x, soma.y, _descrever(soma)]


func _descrever(f: Vector2i) -> String:
	if f.x == f.y:
		return "1 inteiro!"
	if f.x > f.y:
		return "passou de 1 inteiro"
	return "falta %d/%d" % [_reduzir(Vector2i(f.y - f.x, f.y)).x, _reduzir(Vector2i(f.y - f.x, f.y)).y]


func _somar(lista: Array) -> Vector2i:
	var num : int = 0
	var den : int = 1
	for slot in lista:
		if slot == null:
			continue
		num = num * slot.den + slot.num * den
		den = den * slot.den
	if num == 0:
		return Vector2i(0, 1)
	return _reduzir(Vector2i(num, den))


func _reduzir(f: Vector2i) -> Vector2i:
	var m := _mdc(abs(f.x), abs(f.y))
	return Vector2i(f.x / m, f.y / m)


func _verificar_resposta() -> void:
	for slot in _slots:
		if slot == null:
			label_feedback.text = "Preencha os 3 espaços antes de verificar."
			_som_erro.play()
			return
	var soma := _somar(_slots)
	if soma.x == SOMA_ALVO_NUM and soma.y == SOMA_ALVO_DEN:
		_on_puzzle_correto()
	else:
		_on_puzzle_errado(soma)


func _on_puzzle_correto() -> void:
	_resolvido = true
	_aviso_e.visible = false
	_som_acerto.play()
	label_feedback.add_theme_color_override("font_color", Color(0.45, 1.0, 0.6))
	label_feedback.text = "CORRETO! 2/4 + 1/4 + 1/4 = 4/4 = 1 inteiro.\nA ponte está se unindo!"
	label_equacao.text = "1/4 + 1/2 + 1/4 = 1"
	for b in [botao_f1, botao_f2, botao_f3, botao_verificar, _botao_desfazer, _botao_limpar, _botao_dica, _botao_fechar]:
		b.disabled = true
	await get_tree().create_timer(2.2, true).timeout
	_fechar_painel()
	SignalBus.puzzle_resolvido.emit()


func _on_puzzle_errado(soma: Vector2i) -> void:
	_som_erro.play()
	SignalBus.tentativas_erradas += 1
	SignalBus.resposta_errada.emit()
	var motivo := "ficou menor que 1" if soma.x < soma.y else "passou de 1"
	label_feedback.text = "Ainda não! A soma deu %d/%d e %s." % [soma.x, soma.y, motivo]
	_tremer_painel()
	await get_tree().create_timer(1.6, true).timeout
	if _resolvido or not painel_ui.visible:
		return
	_resetar_slots()
	label_feedback.text = DICAS[_dica_atual]
	_dica_atual = min(_dica_atual + 1, DICAS.size() - 1)


func _tremer_painel() -> void:
	var base := painel_ui.position
	var t := painel_ui.create_tween()
	for d in [12, -10, 8, -6, 0]:
		t.tween_property(painel_ui, "position:x", base.x + d, 0.04)


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
