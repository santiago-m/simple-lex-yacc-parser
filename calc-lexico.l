%{

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include "calc-sintaxis.tab.h"

%}

%option noyywrap
%option yylineno

letra [a-zA-z]
digito [0-9]
id letra(letra|digito)*

%%

var 		{
				printf("%s ",yytext);
        		return VAR;
			}

{digito}+   { 
				yylval.i = atoi(yytext);
                printf("%d ",atoi(yytext)); 
                return INT;
			}

{id}    	{ 
				yylval.s=(char *) malloc(sizeof(yytext)*yyleng);
				strcpy(yylval.s,yytext);
				printf("%s ",yytext);
				return ID;
			}

[+*;()=]    {
				printf("%s ",yytext);
				return *yytext;
			}

.|\n ; /* ignore all the rest */

%%

void yyerror(){
	printf("%s%d\n","-> ERROR Sintactico en la linea: ",yylineno);
}

int main(int argc,char *argv[]){
	++argv,--argc;
	if (argc > 0)
		yyin = fopen(argv[0],"r");
	else
		yyin = stdin;

	yyparse();

}
