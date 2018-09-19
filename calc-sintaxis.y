%{

#include <stdlib.h>
#include <stdio.h>

typedef struct $ {
  char *name;
  int value;
  struct $ *next;
}VAR_DATA;
 
VAR_DATA *head = (VAR_DATA *) NULL, *last = (VAR_DATA *) NULL;

typedef struct $ {
  char *data;
  struct $ *hi;
  struct $ *hm;
  struct $ *hd;
}ExpTree;

ExpTree *expr_root = (ExpTree *) NULL, *expr_current = (ExpTree *) NULL;


/* Con esta función añadimos una variable a la lista de simbolos*/
void add_var(char *n, int v) {
  VAR_DATA *nuevo;

  /* reserva memoria para la nueva variable */
  nuevo = (VAR_DATA *) malloc (sizeof(VAR_DATA));
  if (nuevo==NULL)
    printf( "No hay memoria disponible!\n");
  
  //printf("\nNueva Variable:\n");
  nuevo->name = n;
  nuevo->value = v;

  nuevo->next = NULL;
 
  if (head==NULL) {
    //printf( "Primer Variable Declarada\n");
    head = nuevo;
    last = nuevo;
  }
  else {
    last->next = nuevo;
    last = nuevo;
  }
}
 
void list_vars() {
  VAR_DATA *auxiliar; /* lo usamos para recorrer la lista */
  int i;

  i = 0;
  auxiliar = head;
  printf("\nLista de Variables:\n");
  while (auxiliar!=NULL) {
    printf( "name: %s, value: %d\n",
      auxiliar->name,auxiliar->value);
    
    auxiliar = auxiliar->next;
    i++;
  }
  if (i == 0)
    printf( "\nLa lista está vacía!!\n" );
}

VAR_DATA *find_var(char *varname) {
  VAR_DATA *auxiliar; /* lo usamos para recorrer la lista */
  auxiliar = head;

  while (auxiliar != NULL) {
    if (strcmp(auxiliar->name, varname) == 0) {
      return auxiliar;
    }
    auxiliar = auxiliar -> next;
  }
  return auxiliar;
}

%}
 
%union { int i; char *s; }
 
%token<i> INT
%token<s> ID
%token<s> VAR

%start prog

%type<i> expr
%type<i> def
 
%right '='
%left '+' 
%left '*'
 
%%
 
prog: def ';' prog       
    | expr ';'           { printf("%s %d\n", "Resultado de la expresion:", $1); }
    ;
  
expr: INT               { $$ = $1; 
                           //printf("%s%d\n","Constante entera:",$1);
                        }
    | ID                { char *varname = $1;
                          VAR_DATA *searchResult = find_var(varname);
                          if (searchResult != NULL) {
                            $$ = searchResult->value;
                          }
                          else {
                            //VARIABLE NO DECLARADA.
                            yyerror();
                            return -1;
                          }
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

def: VAR ID '=' expr  { add_var($2, $4);
                        //list_vars();
                      }
    ;
%%