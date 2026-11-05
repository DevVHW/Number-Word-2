extends CanvasLayer

@onready var label_fragmentos : Label = $MarginContainer/VBox/LabelFragmentos

var _fragmentos : int = 0


func _ready() -> void:
	SignalBus.fragmento_coletado.connect(_on_fragmento_coletado)
	_atualizar_label()


func _on_fragmento_coletado() -> void:
	_fragmentos += 1
	_atualizar_label()


func _atualizar_label() -> void:
	label_fragmentos.text = "Fragmentos de Conhecimento: %d" % _fragmentos
