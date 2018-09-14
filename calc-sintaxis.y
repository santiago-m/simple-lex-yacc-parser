%{

#include <stdlib.h>
#include <stdio.h>

int vars[26];

%}
 
%union { int i; char *s; }
 
%token<i> INT
%token<s> ID
%token<i> VAR

%type<i> expr
%type<i> def
 
%left '+' 
%left '*'
%left '='
 
%%
 
prog: expr ';'          { printf("%s%d\n", "Resultado: ",$1); }
    | def ';'           
    ;
  
expr: INT               { $$ = $1; 
                          //printf("%s%d\n","Constante entera:",$1);
                        }
    | VAR               { $$ = vars[$1]; 
                          printf("%d%c\n", $1 + 'a', "° Variable Encontrada!");
                        }
    | expr '+' expr     { $$ = $1 + $3; 
                          // printf("%s,%d,%d,%d\n","Operador Suma\n",$1,$3,$1+$3);
                        }
    | expr '*' expr     { $$ = $1 * $3; 
                          // printf("%s,%d,%d,%d\n","Operador Producto\n",$1,$3,$1*$3);  
                        }
    | '(' expr ')'              { $$ =  $2; }
    ;

def: VAR '=' expr  { vars[$1] = $3; 
                          printf("%s%c = %d\n", "Variable Declarada: ", $1 + 'a', vars[$1]); }
%%


