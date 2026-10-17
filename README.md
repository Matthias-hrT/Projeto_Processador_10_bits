# Processador RISC de 10 bits em VHDL

Projeto desenvolvido para a disciplina de Circuitos Digitais, consistindo na implementação de uma arquitetura de processador de 10 bits descrita em VHDL e sintetizada para a FPGA Intel MAX10.

## Sobre o Projeto
O processador executa um conjunto de instruções customizadas de 10 bits, contemplando operações aritméticas, lógicas, manipulação de registradores, operações de memória (RAM interna) e interface visual com displays de 7 segmentos.

## Tecnologias e Ferramentas
* **Linguagem:** VHDL
* **Hardware:** FPGA Intel MAX10
* **Software de Síntese/Simulação:** Intel Quartus Prime

## Principais Funcionalidades
* **ULA (Unidade Lógica e Aritmética):** Operações de soma, subtração, multiplicação, divisão e cálculo de fatorial.
* **Operações Lógicas e Relacionais:** Comparações (maior, menor, igual, diferente).
* **Banco de Registradores e Memória RAM:** Instruções de `LOAD`, `STORE`, `MOVE` e acesso a um array de memória interna de 16 posições.
* **Interface de Saída:** Decodificação e multiplexação de sinais para exibição de estados e resultados em múltiplos displays de 7 segmentos.

## Vídeo do projeto
* https://youtu.be/NvNiQHr4BFE
