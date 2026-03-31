# 🔍 Analisador Léxico com Flex

Este projeto contém um analisador léxico desenvolvido em **Flex** (Fast Lexical Analyzer Generator) capaz de identificar e contar elementos em expressões matemáticas simples, como números inteiros, operadores e caracteres totais.

---

## 📋 Pré-requisitos

Para compilar e executar este projeto, você precisará de:
* **Flex** (Gerador de analisadores léxicos)
* **GCC** (Compilador C)

No Linux (Ubuntu/Debian), instale com:
```bash
sudo apt update && sudo apt install flex
```

## 🛠️ 1. Como Compilar e Executar

Siga exatamente estes comandos no seu terminal (Linux, macOS ou WSL no Windows):

### Passo 1: Gerar o arquivo C

O Flex lerá sua lógica e transformará em código C padrão.

```bash
flex analisador.l
```

### Passo 2: Compilar com o GCC

Agora compilamos o arquivo gerado (lex.yy.c) para criar o programa executável.

```bash
gcc lex.yy.c -o meu_analisador
```

### Passo 3: Executar

Agora é só rodar o programa:

```bash
./meu_analisador
```

## 📂 2. Como Testar

### Teste Manual (Via Teclado)

Após rodar o comando ```./meu_analisador```, digite uma conta, por exemplo: ```10 + 50 / 2```
Depois aperte Enter e, para ver o resultado final, pressione Ctrl + D.

### Teste Automático (Via Arquivo)

Se você tiver um arquivo chamado contas.txt, pode usá-lo como entrada:

```bash
./meu_analisador < contas.txt
```

## 📌 3. Explicação das Regras (Markdown Table)

Padrão (Regex) e o que ele faz?

```[0-9]+``` = Reconhece um ou mais dígitos em sequência como um único número.

```[-+*/]``` = Reconhece qualquer um dos quatro operadores matemáticos básicos.

```\n``` e ```[ \t]``` = Captura quebras de linha e espaços para contar como caracteres, mas não faz nada extra.

```.``` = O ponto é um coringa: captura qualquer símbolo que não caiu nas regras acima.