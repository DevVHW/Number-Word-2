extends Node

signal abrir_painel_puzzle
signal puzzle_resolvido
signal resposta_errada
signal fase_concluida
signal fragmento_coletado
signal neo_perto_painel(perto: bool)
signal neo_caiu
signal ponte_montada

const TOTAL_FRAGMENTOS : int = 3

## Estado compartilhado entre as cenas
var fragmentos_coletados : int = 0
var tentativas_erradas   : int = 0
var tempo_fase           : float = 0.0
var puzzle_aberto        : bool = false
var fase_terminada       : bool = false


func reiniciar_estado() -> void:
	fragmentos_coletados = 0
	tentativas_erradas   = 0
	tempo_fase           = 0.0
	puzzle_aberto        = false
	fase_terminada       = false
