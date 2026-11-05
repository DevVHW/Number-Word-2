# Numbers World 2 — Protótipo "Planície das Frações"

Jogo de plataforma 2D educativo, feito na **Godot Engine**, em que o jogador controla o personagem **Neo** e usa **soma de frações** para reconstruir uma ponte quebrada e chegar ao portal da próxima fase.

Esta versão é um **protótipo jogável com uma única fase**: a *Planície das Frações*.

> **Equipe:** [NOME DOS INTEGRANTES]
> **Disciplina / Atividade:** [NOME DA DISCIPLINA] — [NOME DA ATIVIDADE]
> **GDD (Game Design Document):** [COLE AQUI O LINK DO GDD OU O CAMINHO, ex.: `docs/GDD.pdf`]

---

## Sumário

1. [Requisitos](#1-requisitos)
2. [Baixar o projeto](#2-baixar-o-projeto)
3. [Instalação e configuração do ambiente](#3-instalação-e-configuração-do-ambiente)
4. [Como executar o jogo](#4-como-executar-o-jogo)
5. [Como jogar](#5-como-jogar)
6. [Objetivo, regras e progressão](#6-objetivo-regras-e-progressão)
7. [Passo a passo da fase (solução)](#7-passo-a-passo-da-fase-solução)
8. [Limitações conhecidas e o que ainda não foi implementado](#8-limitações-conhecidas-e-o-que-ainda-não-foi-implementado)
9. [Problemas comuns](#9-problemas-comuns)
10. [Estrutura do projeto](#10-estrutura-do-projeto)

---

## 1. Requisitos

| Item | Requisito |
|---|---|
| **Engine** | **Godot 4.6** (versão *Standard*, a que usa GDScript — **não** é necessária a versão ".NET / C#") |
| **Sistema operacional** | Windows 10 ou superior, macOS ou Linux (qualquer um que rode a Godot 4.6) |
| **Placa de vídeo** | Compatível com OpenGL 3.3 (o projeto usa o renderizador **GL Compatibility**, que roda até em computadores simples) |
| **Git** | Opcional, apenas se for clonar o repositório pelo terminal |
| **Teclado** | Necessário (o jogo é jogado com teclado e mouse) |
| **Outras dependências** | Nenhuma. Não há bibliotecas, plugins nem `npm`/`pip` para instalar. |

> O projeto foi criado na Godot 4.6. Versões anteriores (4.5 ou menos) podem recusar abrir o projeto ou exibir avisos. Use a **4.6** ou mais recente da série 4.x.

---

## 2. Baixar o projeto

**Opção A — Clonar com Git**

```bash
git clone [URL-DO-REPOSITORIO]
cd [NOME-DA-PASTA-DO-REPOSITORIO]
```

**Opção B — Baixar o ZIP (sem Git)**

1. Abra a página do repositório no GitHub.
2. Clique no botão verde **Code** → **Download ZIP**.
3. **Extraia** o ZIP em uma pasta de sua preferência (não abra o projeto de dentro do ZIP).

Ao final, você deve ter uma pasta contendo o arquivo **`project.godot`** na raiz, junto com as pastas `assets/`, `scenes/` e `scripts/`.

---

## 3. Instalação e configuração do ambiente

1. Acesse **https://godotengine.org/download** e baixe a **Godot 4.6 (Standard)** para o seu sistema operacional.
2. Instale/extraia:
   - **Windows:** extraia o `.zip` baixado; o executável `Godot_v4.6-stable_win64.exe` roda direto, sem instalador.
   - **macOS:** abra o `.dmg`/`.zip` e arraste o app **Godot** para a pasta Aplicativos (na primeira vez, pode ser preciso clicar com o botão direito → **Abrir**).
   - **Linux:** extraia o arquivo e execute o binário (se necessário: `chmod +x Godot_v4.6-stable_linux.x86_64`).
3. Nenhuma outra configuração é necessária. O projeto já define a resolução (1280×720), o renderizador e o mapa de teclas.

---

## 4. Como executar o jogo

O jogo é executado **pelo editor da Godot** (não há executável pré-compilado nesta versão).

### Pelo editor (recomendado)

1. Abra a Godot 4.6. Na tela do **Gerenciador de Projetos**, clique em **Importar** (*Import*).
2. Clique em **Procurar** (*Browse*) e selecione o arquivo **`project.godot`** da pasta do projeto. Clique em **Abrir** e depois em **Importar e Editar**.
3. Aguarde a primeira abertura: a Godot importa imagens e sons automaticamente (pode levar de alguns segundos a um minuto). É normal.
4. Com o projeto aberto, clique no botão **▶ Executar Projeto** (canto superior direito) ou aperte **F5**.
   - A cena principal (`scenes/PlanieDasFracoes.tscn`) já está configurada como cena inicial, então o jogo abre direto na fase.
5. Uma janela de 1280×720 será aberta com o jogo. Para fechar, feche a janela ou aperte **F8** no editor.

### Pelo terminal (opcional)

Dentro da pasta do projeto, com o executável da Godot acessível:

```bash
godot --path .
```

(Em Windows/macOS, substitua `godot` pelo caminho completo do executável baixado.)

---

## 5. Como jogar

### Iniciando a partida

Não há menu inicial: **a partida começa assim que o jogo abre**. Neo aparece na plataforma da esquerda, com a música de fundo tocando.

### Controles

| Tecla | Ação |
|---|---|
| **← / →** (setas) | Andar para a esquerda / direita |
| **Espaço** (ou **Enter**) | Pular (só funciona quando Neo está no chão) |
| **E** | Interagir com o painel de frações (precisa estar perto do painel) |
| **Mouse (clique esquerdo)** | Clicar nos botões do painel do puzzle (`1/4`, `1/2`, `Verificar`) e em **Jogar Novamente** |

> **Atenção:** o texto no topo da tela cita "A-D" para mover, mas nesta versão **apenas as setas ← →** movem o personagem.

### Tela do jogo (HUD)

- **Canto superior esquerdo:** lembrete dos controles.
- **Logo abaixo:** contador **"Fragmentos de Conhecimento: N"**, que aumenta a cada fragmento coletado.

---

## 6. Objetivo, regras e progressão

### Objetivo

Atravessar o abismo que separa as duas plataformas e chegar ao **portal "PRÓXIMA FASE"**. Para isso, o jogador deve **reconstruir a ponte de frações** resolvendo o puzzle do painel interativo.

### Regras básicas

- Neo se move e pula pelas plataformas. **Não há inimigos nem tempo limite.**
- No centro da fase há um **abismo**: se Neo cair, ele **volta ao ponto inicial** (plataforma esquerda). Não existe perda de vida nem "game over".
- O **painel interativo** fica na plataforma da esquerda. Ao apertar **E** perto dele, abre-se o puzzle e **o jogo pausa**.
- No puzzle há **3 slots** (`[ ] + [ ] + [ ] = ?`) e **3 botões de fração**: `1/4`, `1/2` e `1/4`.
  - Cada clique em um botão **preenche o próximo slot vazio** com aquela fração. (O mesmo botão pode ser clicado mais de uma vez.)
  - Ao clicar em **Verificar**, o jogo soma as três frações.
  - **A soma precisa ser exatamente 1 (um inteiro).**
- **Resposta errada:** aparece "Soma incorreta! Tente novamente.", os slots são limpos e surge a dica *"a soma deve ser igual a 1 inteiro"*. Pode tentar quantas vezes quiser.
- **Slots incompletos:** se clicar em *Verificar* sem preencher os 3 slots, aparece "Preencha todos os campos!".

### Condições de progressão e vitória

| Situação | O que acontece |
|---|---|
| Puzzle correto | Mensagem "CORRETO! A ponte se une!", o painel fecha, **os 3 pedaços da ponte se unem** (ficam amarelados) e **o portal aparece** na plataforma da direita |
| Neo entra no portal | **Vitória:** tela "Parabéns! Você resolveu o puzzle!" com o botão **Jogar Novamente** |
| Cair no abismo | Neo reaparece no início (sem punição adicional) |

### Fragmentos de Conhecimento (coletáveis)

Existem **3 fragmentos** flutuantes espalhados pela fase. Coletá-los (basta encostar) toca um som e aumenta o contador no HUD. **Nesta versão eles são opcionais**: não influenciam a vitória. Um deles está em um ponto alto (exige pulo) e outro fica na plataforma da direita (só alcançável depois de montar a ponte).

---

## 7. Passo a passo da fase (solução)

Para quem quiser testar rapidamente o fluxo completo:

1. Inicie o jogo e use **→** para andar para a direita pela plataforma da esquerda (opcional: pule e colete os fragmentos no caminho).
2. Pare **em frente ao painel** (aparelho de tela com símbolos, perto do centro-esquerda da plataforma) e aperte **E**.
3. No puzzle, clique nos botões de modo a preencher os slots com **1/4 + 1/2 + 1/4** (qualquer ordem serve, desde que haja um `1/2` e dois `1/4`).
4. Clique em **Verificar**. Aguarde cerca de 1,5 s: o painel fecha e a ponte se monta.
5. Atravesse a ponte andando para a direita e entre no **portal** na plataforma da direita.
6. A tela de parabéns aparece. Clique em **Jogar Novamente** para reiniciar a fase.

---

## 8. Limitações conhecidas e o que ainda não foi implementado

**Limitações da versão atual**

- Existe **apenas 1 fase** e **apenas 1 puzzle** (soma de `1/4 + 1/2 + 1/4 = 1`). O portal "Próxima Fase" leva direto à tela de parabéns, pois não há uma segunda fase.
- **Não há tutorial interno, menu inicial, menu de pausa, tela de opções ou configurações de volume.** As instruções estão apenas neste guia.
- **Não há botão para fechar o painel** do puzzle: depois de abri-lo, é necessário resolvê-lo para voltar a controlar o personagem.
- O puzzle **não tem botão para limpar um slot individual**; os slots só são limpos após uma resposta errada ou ao reabrir o painel.
- O texto do puzzle diz "na ordem correta", mas **qualquer ordem** das três frações corretas é aceita.
- O HUD menciona as teclas **A/D**, mas elas **não estão mapeadas**; só as setas funcionam.
- Não há **executável exportado**: é preciso ter a Godot 4.6 para jogar.
- Os **Fragmentos de Conhecimento** só contam pontos no HUD; ainda não têm função no jogo.
- **Sem sistema de vidas, pontuação final, salvamento de progresso ou controle por gamepad/toque** (não testado).
- Textos do jogo estão **sem acentuação**.

**Funcionalidades planejadas / ainda não implementadas**

- Novas fases e novos puzzles de frações (subtração, equivalência, comparação etc.).
- Menu principal, tutorial interno e opções de áudio.
- Inimigos / desafios adicionais.
- Uso real dos Fragmentos de Conhecimento (recompensas, dicas).
- Exportação de builds (Windows/Web) para jogar sem a engine.

> Ajustar esta lista conforme o GDD da equipe.

---

## 9. Problemas comuns

| Problema | Solução |
|---|---|
| A Godot avisa que o projeto foi criado em outra versão | Use a Godot **4.6**. Em versões anteriores o projeto pode não abrir corretamente. |
| Aparecem erros de arquivo/imagem não encontrado na primeira abertura | Aguarde a importação terminar (barra no canto inferior direito) e rode novamente. Se persistir, feche e reabra o projeto. |
| Não há som | Verifique o volume do computador. O áudio é tocado pela própria janela do jogo. |
| Neo não anda com A/D | Use as **setas ← →**. |
| Apertei **E** e nada aconteceu | Aproxime-se mais do painel: Neo precisa estar dentro da área dele. |
| O jogo "travou" depois de abrir o painel | É a pausa do puzzle; resolva-o para continuar (veja a seção 6). |
| Aviso no console sobre o barramento de áudio "SFX" | É um aviso inofensivo; o som do coletável toca normalmente no barramento padrão. |

---

## 10. Estrutura do projeto

```
.
├── project.godot            # Configuração da Godot (cena inicial, resolução, teclas)
├── icon.svg                 # Ícone do projeto
├── assets/
│   ├── audio/               # Música de fundo, pulo, passos e coleta (.wav)
│   ├── backgrounds/         # Fundo da Planície das Frações
│   └── sprites/             # Neo, painel, portal, ponte e fragmento
├── scenes/
│   ├── PlanieDasFracoes.tscn   # Cena principal (a fase jogável)
│   └── Fragmento.tscn          # Coletável "Fragmento de Conhecimento"
└── scripts/
    ├── neo_player.gd        # Movimento, pulo, animação e interação do Neo
    ├── painel_puzzle.gd     # Lógica do puzzle de frações
    ├── ponte.gd             # Animação de união da ponte
    ├── portal_fase.gd       # Portal e tela de vitória
    ├── fragmento.gd         # Coletável
    ├── hud.gd               # Contador de fragmentos
    ├── cena_principal.gd    # Configuração da cena e respawn no abismo
    └── signal_bus.gd        # Sinais globais (autoload "SignalBus")
```

---

## Créditos

- Equipe de desenvolvimento: [NOMES]
- Engine: [Godot Engine](https://godotengine.org/) 4.6
- Assets: [INDICAR ORIGEM DOS SPRITES, FUNDO E ÁUDIOS — próprios, gerados por IA, bancos gratuitos etc.]
