%{
  #include <stdio.h>

  int total_palavras = 0;
  int total_linhas = 0; 
  int total_caracteres = 0;
%}

%%
[a-zA-Z]+ { total_palavras++; total_caracteres += yyleng; }
\n { total_linhas++; }
. { total_caracteres++; }
%%

int main() {
  printf("--- Iniciando Analisador (Pressione Ctrl+D para sair) ---\n");
    
  yylex(); // Inicia a análise
  
  printf("\n--- Resultado Final ---");
  printf("\nTotal de Caracteres: %d", total_caracteres);
  printf("\nTotal de Palavras:   %d", total_palavras);
  printf("\nTotal de Linhas:     %d\n", total_linhas);
  
  return 0;
}

int yywrap() {
  return 1;
}