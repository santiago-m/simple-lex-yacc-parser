%{

#include <stdlib.h>
#include <stdio.h>
#include "structs.h"
 
VAR_DATA *head = (VAR_DATA *) NULL, *last = (VAR_DATA *) NULL;

ExpTree *expr_root = (ExpTree *) NULL, *expr_last = (ExpTree *) NULL;


/* Con esta función añadimos una variable a la lista de simbolos*/
void add_var(char *n, int v) {
  VAR_DATA *new_node;

  /* reserva memoria para la nueva variable */
  new_node = (VAR_DATA *) malloc (sizeof(VAR_DATA));
  if (new_node==NULL)
    printf( "No hay memoria disponible!\n");
  
  //printf("\nNueva Variable:\n");
  new_node->name = n;
  new_node->value = v;

  new_node->next = NULL;
 
  if (head==NULL) {
    //printf( "Primer Variable Declarada\n");
    head = new_node;
    last = new_node;
  }
  else {
    last->next = new_node;
    last = new_node;
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

/* Con esta función añadimos una variable a la lista de simbolos*/
ExpTree *add_leave(int v) {
  ExpTree *new_node;

  /* reserva memoria para la nueva variable */
  new_node = (ExpTree *) malloc (sizeof(ExpTree));
  if (new_node==NULL)
    printf( "No hay memoria disponible!\n");
  
  //printf("\nNueva Variable:\n");
  new_node->data = v;
  new_node->es_operador = false;
  new_node->hi = NULL;
  new_node->hd = NULL;

  return new_node;
}

ExpTree *add_node(ExpTree *hi, char op, ExpTree *hd) {
  ExpTree *new_node;

  /* reserva memoria para la nueva variable */
  new_node = (ExpTree *) malloc (sizeof(ExpTree));
  if (new_node==NULL)
    printf( "No hay memoria disponible!\n");
  
  new_node->data = op;
  new_node->es_operador = true;
  new_node->hi = hi;
  new_node->hd = hd;

  return new_node;
}

int eval(ExpTree *root) {

  if (root->hi == NULL && root->hd == NULL) {
    return root->data;
  }
  
  if ((char) root->data == '+') {
    return eval(root->hi) + eval(root->hd);
  }
  else if ((char) root->data == '*') {
   return eval(root->hi) * eval(root->hd); 
  }
}

void printTree(ExpTree *root) {
  if (root->hi == NULL && root->hd == NULL) {
    printf("%d", root->data);
  }
  
  if ((char) root->data == '+') {
    printf("(");
    printTree(root->hi);
    printf("+");
    printTree(root->hd);
    printf(")");
  }
  else if ((char) root->data == '*') {
    printf("(");
    printTree(root->hi);
    printf("*");
    printTree(root->hd);
    printf(")");
  }
}

%}
 
%union { int i; char *s; ExpTree *node; }
 
%token<i> INT
%token<s> ID
%token<s> VAR

%start prog

%type<node> expr
%type<node> def
 
%right '='
%left '+' 
%left '*'
 
%%
 
prog: def ';' prog       
    | expr ';'           { printTree($1);
                           printf("\n%s %d\n", "Resultado de la expresion:", eval($1));
                          }
    ;
  
expr: INT               { $$ = $1;
                          $$ = add_leave($1);

                           //printf("%s%d\n","Constante entera:",$1);
                        }
    | ID                { char *varname = $1;
                          VAR_DATA *searchResult = find_var(varname);
                          if (searchResult != NULL) {
                            $$ = add_leave(searchResult->value);
                          }
                          else {
                            //VARIABLE NO DECLARADA.
                            yyerror();
                            return -1;
                          }
                        }
    | expr '+' expr     { $$ = add_node($1, '+', $3);
                           //printf("%s,%d,%d,%d\n","Operador Suma\n",$1,$3,$1+$3);
                        }
    | expr '*' expr     { $$ = add_node($1, '*', $3);
                          // printf("%s,%d,%d,%d\n","Operador Producto\n",$1,$3,$1*$3);  
                        }
    | '(' expr ')'      { $$ =  $2; 
                        }
    ;

def: VAR ID '=' expr  { add_var($2, eval($4));
                        //list_vars();
                      }
    ;
%%