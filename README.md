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

Existem 5 arquivos de teste na raiz do repositório, pode usá-lo como entrada:

```bash
./meu_analisador < ../arquivo_teste.txt
```

## 📂 3. Desafios no Repositório

### 3.1. Contador de Texto (contador.l)
Um analisador básico para estatísticas de texto.

O que faz: Conta a quantidade total de palavras, linhas e caracteres.

Padrão: Palavras são reconhecidas como sequências de letras [a-zA-Z]+.

### 3.2. Tokenizador de Expressões (tokenizador_exp.l)
Focado em identificar componentes de fórmulas matemáticas.

O que faz: Distingue números inteiros de operadores aritméticos.

Diferencial: Possui suporte a números decimais (float) para evitar contagens erradas em pontos flutuantes.

### 3.3. Tabela de Símbolos (simbolos.l)
Introdução ao gerenciamento de identificadores únicos.

O que faz: Reconhece nomes de variáveis (IDs). Se um ID já foi visto, ele retorna o índice existente; se for novo, ele o insere na tabela.

Regra de ID: Começa obrigatoriamente com letra, seguido de letras ou números.

### 3.4. Scanner Completo (scanner.l)
O nível mais avançado, simulando o front-end de um compilador real para linguagens como C ou Java.

Recursos:

Keywords: if, else, while, int, etc.

Comentários: Suporte a comentários de linha (//) e bloco (/* ... */).

Validação de Literais: Detecta se strings ("...") ou caracteres ('...') foram abertos mas não fechados, reportando o erro e a linha exata.

Tabela de Símbolos Dinâmica: Gerencia identificadores usando strdup e desalocação de memória.

Para fechar com chave de ouro a documentação do seu repositório, o Desafio 5 deve destacar justamente essa evolução técnica: a Tokenização Granular (quando deixamos de usar categorias genéricas e passamos a dar um nome único para cada símbolo).

Aqui está o trecho para você adicionar ao seu README.md:

### 3.5. Scanner com Tokenização Granular (scanner_v2.l)
Este desafio eleva o nível de precisão do analisador léxico, preparando-o para a integração com um Analisador Sintático (Parser).

O que faz: Substitui as categorias genéricas (como T_KEYWORD ou T_OPERATOR) por tokens específicos para cada símbolo da linguagem.

Diferenciais Técnicos:

Tokens Específicos: Implementação de tokens individuais como T_IF, T_OP_SOMA, T_PONTO_VIRGULA, entre outros.

Precedência de Padrões: Lógica de ordenação nas regras do Flex para garantir que operadores compostos (ex: ==) sejam reconhecidos antes de operadores simples (ex: =).

Saída Detalhada: Função main reformulada com switch-case para gerar um log de depuração preciso, identificando cada lexema por sua função gramatical exata.

Robustez: Separação clara entre tipos de dados (Keywords como int) e literais (como T_INTEGER), evitando conflitos de nomes na enumeração.