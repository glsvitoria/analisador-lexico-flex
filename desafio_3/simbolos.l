%{
#include <stdio.h>
#include <string.h>

#define MAX_IDS 100
#define MAX_LEN 50

char tabela_simbolos[MAX_IDS][MAX_LEN];
int proximo_indice = 0;

int buscar_ou_inserir(char *id) {
  for (int i = 0; i < proximo_indice; i++) {
    if (strcmp(tabela_simbolos[i], id) == 0) {
      return i;
    }
  }

  if (proximo_indice < MAX_IDS) {
    strcpy(tabela_simbolos[proximo_indice], id);
    return proximo_indice++;
  }

  return -1;
}
%}

ID  [a-zA-Z][a-zA-Z0-9]*

%%
{ID}  { 
        int idx = buscar_ou_inserir(yytext);
        printf("ID: %-10s | Índice: %d\n", yytext, idx);
      }

[ \t\n]+ { /* Ignora espaços, tabs e quebras de linha */ }
.        { /* Ignora outros caracteres como símbolos matemáticos */ }
%%

int main() {
  printf("--- Tabela de Símbolos Iniciada (Ctrl+D para encerrar) ---\n");

  yylex();
    
  printf("\n--- Estado Final da Tabela ---\n");
  for(int i = 0; i < proximo_indice; i++) {
      printf("[%d] -> %s\n", i, tabela_simbolos[i]);
  }

  return 0;
}

int yywrap() {
  return 1;
}