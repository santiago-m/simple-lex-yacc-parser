%{

#include <stdlib.h>
#include <stdio.h>

int vars[26];

%}
 
%union { int i; char *s; }
 
%token<i> INT
%token<s> ID
%token<s> VAR

%start prog

%type<i> expr
%type<i> def
 
%left '='
%left '+' 
%left '*'
 
%%
 
prog: def ';' prog       
    | expr ';'           { printf("%s %d\n", "Resultado de la expresion:", $1); }
    ;
  
expr: INT               { $$ = $1; 
                           //printf("%s%d\n","Constante entera:",$1);
                        }
    | ID                { //Aca deberia buscarse el valor de la variable y asignarselo a $$
                        }
    | expr '+' expr     { $$ = $1 + $3; 
                           //printf("%s,%d,%d,%d\n","Operador Suma\n",$1,$3,$1+$3);
                        }
    | expr '*' expr     { $$ = $1 * $3; 
                          // printf("%s,%d,%d,%d\n","Operador Producto\n",$1,$3,$1*$3);  
                        }
    | '(' expr ')'      { $$ =  $2; 
                        }
    ;

def: VAR ID '=' expr  { printf("%s %s = %d\n", "Variable Declarada:", $2, $4);
                      }
    ;
%%


