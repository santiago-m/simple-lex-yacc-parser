%{

#include <stdlib.h>
#include <stdio.h>

%}
 
%union { int i; char *s; }
 
%token<i> INT
%token<s> ID
%token<s> VAR

%type<i> expr
 
%left '+' 
%left '*'
%left '='
 
%%
 
prog: expr ';'          { printf("%s%d\n", "Resultado: ",$1); } 
    | def ';'           {}
    ;
  
expr: INT               { $$ = $1; 
                           printf("%s%d\n","Constante entera:",$1);
                        }
    | expr '+' expr     { $$ = $1 + $3; 
                          // printf("%s,%d,%d,%d\n","Operador Suma\n",$1,$3,$1+$3);
                        }
    | expr '*' expr     { $$ = $1 * $3; 
                          // printf("%s,%d,%d,%d\n","Operador Producto\n",$1,$3,$1*$3);  
                        }
    | '(' expr ')'              { $$ =  $2; }
    ;

def: VAR                { printf("%s%s\n", "Variable Declarada: ", &($1)[4]); }
 
%%


