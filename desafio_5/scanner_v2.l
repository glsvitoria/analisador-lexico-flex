%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/* Definição da Enumeração TokenType 
   Cada símbolo possui seu próprio ID único para facilitar a futura análise sintática.
*/
typedef enum {
    T_EOF = 0,
    T_UNKNOWN = 266,
    T_ERROR_STRING = 267,
    T_ERROR_CHAR = 269,

    // Identificadores e Literais
    T_ID = 259,
    T_INTEGER = 260,
    T_FLOAT_LITERAL = 261, 
    T_STRING = 264,
    T_CHAR_LITERAL = 268,

    // Palavras-Chave (Keywords)
    T_IF = 270,
    T_ELSE = 271,
    T_WHILE = 272,
    T_INT = 273,
    T_FLOAT = 274,
    T_RETURN = 275,
    T_FOR = 276,
    T_VOID = 277,
    T_CHAR = 278,

    // Operadores
    T_OP_SOMA = 300,        // +
    T_OP_SUB = 301,         // -
    T_OP_MULT = 302,        // *
    T_OP_DIV = 303,         // /
    T_OP_ATRIB = 304,       // =
    T_OP_IGUAL = 305,       // ==
    T_OP_DIFERENTE = 306,   // !=
    T_OP_MENOR = 307,       // <
    T_OP_MAIOR = 308,       // >
    T_OP_MENOR_IGUAL = 309, // <=
    T_OP_MAIOR_IGUAL = 310, // >=
    T_OP_INC = 311,         // ++
    T_OP_DEC = 312,         // --

    // Separadores
    T_PV = 400,             // ;
    T_VIRGULA = 401,        // ,
    T_PAREN_ESQ = 402,      // (
    T_PAREN_DIR = 403,      // )
    T_CHAVE_ESQ = 404,      // {
    T_CHAVE_DIR = 405       // }
} TokenType;

int yylval;

#define MAX_SYMBOLS 100
char *symbol_table[MAX_SYMBOLS];
int symbol_count = 0;
int line_count = 1;

int get_symbol_position(const char *id) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i], id) == 0) return i;
    }
    if (symbol_count < MAX_SYMBOLS) {
        symbol_table[symbol_count] = strdup(id);
        return symbol_count++;
    }
    return -1;
}
%}

%option noyywrap

/* Definições de Expressões Regulares */
DIGITO           [0-9]
LETRA            [a-zA-Z_]
ID               {LETRA}({LETRA}|{DIGITO})*
INTEIRO          {DIGITO}+
FLOAT            {DIGITO}+\.{DIGITO}*
COMENTARIO_LINHA \/\/[^\n]*
COMENTARIO_BLOCO \/\*([^*]|\*+[^*/])*\*+\/

CARACTERE_CORRETO \'([^'\\\n]|\\.)\'
CARACTERE_ERRO     \'([^'\\\n]|\\.)

STRING_CORRETA   \"[^\"\n]*\"
STRING_ERRO      \"[^\"\n]*

%%
[ \t]+             { /* Ignorar espaços e tabs */ }
\n                 { line_count++; }
{COMENTARIO_LINHA} { /* Ignora */ }
{COMENTARIO_BLOCO} { /* Ignora */ }

    /* Palavras-chave */
"if"               { return T_IF; }
"else"             { return T_ELSE; }
"while"            { return T_WHILE; }
"int"              { return T_INT; }
"float"            { return T_FLOAT; }
"return"           { return T_RETURN; }
"for"              { return T_FOR; }
"void"             { return T_VOID; }
"char"             { return T_CHAR; }

    /* Literais e Identificadores */
{INTEIRO}          { yylval = atoi(yytext); return T_INTEGER; }
{FLOAT}            { return T_FLOAT_LITERAL; }
{CARACTERE_CORRETO} { return T_CHAR_LITERAL; }
{CARACTERE_ERRO}   { 
                        printf("Erro Léxico na linha %d: Caractere não fechado -> %s\n", line_count, yytext); 
                        return T_ERROR_CHAR; 
                   }
{STRING_CORRETA}   { return T_STRING; }
{STRING_ERRO}      { 
                        printf("Erro Léxico na linha %d: String não fechada -> %s\n", line_count, yytext); 
                        return T_ERROR_STRING; 
                   }
{ID}               { yylval = get_symbol_position(yytext); return T_ID; }

    /* Operadores Compostos (Devem vir antes dos simples) */
"=="               { return T_OP_IGUAL; }
"!="               { return T_OP_DIFERENTE; }
"<="               { return T_OP_MENOR_IGUAL; }
">="               { return T_OP_MAIOR_IGUAL; }
"++"               { return T_OP_INC; }
"--"               { return T_OP_DEC; }

    /* Operadores Simples */
"<"                { return T_OP_MENOR; }
">"                { return T_OP_MAIOR; }
"+"                { return T_OP_SOMA; }
"-"                { return T_OP_SUB; }
"*"                { return T_OP_MULT; }
"/"                { return T_OP_DIV; }
"="                { return T_OP_ATRIB; }

    /* Separadores */
";"                { return T_PV; }
","                { return T_VIRGULA; }
"("                { return T_PAREN_ESQ; }
")"                { return T_PAREN_DIR; }
"{"                { return T_CHAVE_ESQ; }
"}"                { return T_CHAVE_DIR; }

    /* Erro genérico */
.                  { printf("Erro Léxico na linha %d: Caractere inesperado '%s'\n", line_count, yytext); return T_UNKNOWN; }

%%

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (file) yyin = file;
    }

    int token_id;
    while ((token_id = yylex())) {
        printf("Token: %3d | ", token_id);

        switch (token_id) {
            case T_ID:
                printf("(ID)             | Posição: %d, Lexema: %s\n", yylval, symbol_table[yylval]);
                break;
            case T_INTEGER:
                printf("(Integer)        | Valor: %d\n", yylval);
                break;
            case T_FLOAT_LITERAL:
                printf("(Float Literal)  | Lexema: %s\n", yytext);
                break;
            case T_STRING:
                printf("(String)         | Lexema: %s\n", yytext);
                break;
            case T_CHAR_LITERAL:
                printf("(Char Literal)   | Lexema: %s\n", yytext);
                break;
            case T_IF: case T_ELSE: case T_WHILE: case T_FOR:
            case T_INT: case T_FLOAT: case T_CHAR: case T_VOID: case T_RETURN:
                printf("(Keyword)        | Lexema: %s\n", yytext);
                break;
            case T_OP_SOMA: case T_OP_SUB: case T_OP_MULT: case T_OP_DIV:
            case T_OP_ATRIB: case T_OP_IGUAL: case T_OP_DIFERENTE:
            case T_OP_MENOR: case T_OP_MAIOR: case T_OP_MENOR_IGUAL: 
            case T_OP_MAIOR_IGUAL: case T_OP_INC: case T_OP_DEC:
                printf("(Operator)       | Lexema: %s\n", yytext);
                break;
            case T_PV: case T_VIRGULA:
            case T_PAREN_ESQ: case T_PAREN_DIR:
            case T_CHAVE_ESQ: case T_CHAVE_DIR:
                printf("(Separator)      | Lexema: %s\n", yytext);
                break;
            default:
                printf("(Erro/Outro)     | Lexema: %s\n", yytext);
        }
    }

    printf("\n--- Tabela de Simbolos Final ---\n");
    for (int i = 0; i < symbol_count; i++) {
        printf("[%d] -> %s\n", i, symbol_table[i]);
        free(symbol_table[i]);
    }

    return 0;
}