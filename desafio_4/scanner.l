/* Seção de Definições em C */
%{
#include <stdio.h>
#include <string.h>

/* Adriano Maia - Para integração com o Bison/Yacc, os tokens seriam definidos 
   em um arquivo de cabeçalho compartilhado (ex: y.tab.h). 
   Por enquanto, definimos aqui. */

typedef enum {
  T_KEYWORD = 258,
  T_ID = 259,
  T_INTEGER = 260,
  T_FLOAT = 261,
  T_OPERATOR = 262,
  T_SEPARATOR = 263,
  T_STRING = 264,
  T_EOF = 265,
  T_UNKNOWN = 266,
  T_ERROR_STRING = 267,
  T_CHAR = 268,
  T_ERROR_CHAR = 269
} TokenType;

/* yylval é a variável global usada pelo Flex e Bison para trocar 
   valores. Em um compilador real, isso seria uma 'union' para 
   suportar diferentes tipos de dados (inteiros, strings, etc.). */

int yylval;

/* Tabela de Símbolos (baseada em table.l) */
#define MAX_SYMBOLS 100
char *symbol_table[MAX_SYMBOLS];
int symbol_count = 0;

// Contador de linhas
int line_count = 1;

// Função para obter a posição de um identificador na tabela de símbolos
int get_symbol_position(const char *id) {
  for (int i = 0; i < symbol_count; i++) {
    if (strcmp(symbol_table[i], id) == 0) {
      return i;
    }
  }
  // Adiciona o novo identificador se não for encontrado e retorna a nova posição
  symbol_table[symbol_count] = strdup(id);
  return symbol_count++;
}
%}

/* Opções do Flex */
%option noyywrap

/* Definições de Expressões Regulares (apelidos) */
DIGITO         [0-9]
LETRA          [a-zA-Z_]
ID             {LETRA}({LETRA}|{DIGITO})*
INTEIRO        {DIGITO}+
FLOAT          {DIGITO}+\.{DIGITO}*
COMENTARIO_LINHA \/\/[^\n]*
COMENTARIO_BLOCO \/\*([^*]|\*+[^*/])*\*+\/

CARACTERE_CORRETO \'([^'\\\n]|\\.)\'
CARACTERE_ERRO \'([^'\\\n]|\\.)

STRING_CORRETA  \"[^\"\n]*\"
STRING_ERRO     \"[^\"\n]*

/* Seção de Regras */
%%
[ \t]+         { /* Ignorar espaços em branco e tabulações */ }
\n             { line_count++; }
{COMENTARIO_LINHA} { /* Ignora comentário de linha */ }
{COMENTARIO_BLOCO} { /* Ignora comentário de bloco */ }


"if"           { return T_KEYWORD; }
"else"         { return T_KEYWORD; }
"while"        { return T_KEYWORD; }
"int"          { return T_KEYWORD; }
"float"        { return T_KEYWORD; }
"return"       { return T_KEYWORD; }
"for"          { return T_KEYWORD; }
"void"         { return T_KEYWORD; }
"char"         { return T_KEYWORD; }

{INTEIRO}      { yylval = atoi(yytext); return T_INTEGER; }
{FLOAT}        { return T_FLOAT; }

{CARACTERE_CORRETO} { return T_CHAR; }
{CARACTERE_ERRO}    { 
                      printf("Erro Léxico na linha %d: Caractere não fechado (falta ') -> %s\n", line_count, yytext); 
                      return T_ERROR_CHAR;
                    }

{STRING_CORRETA} { return T_STRING; }
{STRING_ERRO}    { 
                    printf("Erro Léxico na linha %d: String não fechada -> %s\n", line_count, yytext); 
                    return T_ERROR_STRING; 
                 }

{ID}           { yylval = get_symbol_position(yytext); return T_ID; }

"=="           { return T_OPERATOR; }
"!="           { return T_OPERATOR; }
"<"            { return T_OPERATOR; }
">"            { return T_OPERATOR; }
"<="           { return T_OPERATOR; }
">="           { return T_OPERATOR; }
"++"           { return T_OPERATOR; }
"--"           { return T_OPERATOR; }

"+"            { return T_OPERATOR; }
"-"            { return T_OPERATOR; }
"*"            { return T_OPERATOR; }
"/"            { return T_OPERATOR; }
"="            { return T_OPERATOR; }

";"            { return T_SEPARATOR; }
","            { return T_SEPARATOR; }
"("            { return T_SEPARATOR; }
")"            { return T_SEPARATOR; }
"{"            { return T_SEPARATOR; }
"}"            { return T_SEPARATOR; }

.              { printf("Erro Léxico na linha %d: Caractere inesperado '%s'\n", line_count, yytext); return T_UNKNOWN; }

%%
/* Seção de Código do Usuário */

// Função main para testar o scanner de forma independente
int main(int argc, char **argv) {
  if (argc > 1) {
    FILE *file = fopen(argv[1], "r");
    if (file) {
      yyin = file;
    }
  }

  int token_id;
  while ((token_id = yylex())) {
    printf("Token: %d ", token_id);

    if (token_id == T_KEYWORD) {
      printf("(Keyword) | Lexema: %s\n", yytext);
    } else if (token_id == T_ID) {
      printf("(ID)      | Posição na tabela: %d, Lexema: %s\n", yylval, symbol_table[yylval]);
    } else if (token_id == T_INTEGER) {
      printf("(Integer) | Valor: %d\n", yylval);
    } else if (token_id == T_FLOAT) {
      printf("(Float)   | Lexema: %s\n", yytext);
    } else if (token_id == T_STRING) {
      printf("(String)  | Lexema: %s\n", yytext);
    } else if (token_id == T_OPERATOR) {
      printf("(Operator)| Lexema: %s\n", yytext);
    } else if (token_id == T_SEPARATOR) {
      printf("(Separator)| Lexema: %s\n", yytext);
    }
  }

  // Adicione este trecho para imprimir a tabela de símbolos
  printf("\n\n--- Tabela de Símbolos Final ---\n");
  printf("Posição | Identificador\n");
  printf("-----------------------------\n");
  for (int i = 0; i < symbol_count; i++) {
    printf("%-7d | %s\n", i, symbol_table[i]);
  }
  printf("-----------------------------\n\n");


  // Libera a memória alocada para a tabela de símbolos
  for (int i = 0; i < symbol_count; i++) {
      free(symbol_table[i]);
  }

  return 0;

}