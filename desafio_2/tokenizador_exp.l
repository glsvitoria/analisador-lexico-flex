%{
  #include <stdio.h>

  int total_num_inteiros = 0;
  int total_exp_matematicas = 0; 
%}

%%
[0-9]+\.[0-9]+
[0-9]+ { total_num_inteiros++; }
[-+*/] { total_exp_matematicas++; }
%%

int main() {
  printf("--- Iniciando Analisador (Pressione Ctrl+D para sair) ---\n");
    
  yylex(); // Inicia a análise
  
  printf("\n--- Resultado Final ---");
  printf("\nTotal de Números inteiros: %d", total_num_inteiros);
  printf("\nTotal de Expressões Matemáticas:   %d\n", total_exp_matematicas);
  
  return 0;
}

int yywrap() {
  return 1;
}