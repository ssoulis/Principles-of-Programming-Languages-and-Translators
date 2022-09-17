%{
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>
#include <string.h>
#include "y.tab.h"
void yyerror(char *); 
extern FILE *yyin;								
extern FILE *yyout;

%}

%define	api.value.type {char*}
%option noyywrap
%option yylineno
%x single_line_comment

%token T_CHAR
%token T_INTEGER
%token T_VARS
%token T_PROGRAM
%token T_FUNCTION
%token T_ENDFUNCTION
%token T_RETURN
%token T_STARTMAIN
%token T_ENDMAIN
%token T_WHILE
%token T_ENDWHILE
%token T_FOR
%token T_TO
%token T_STEP
%token T_ENDFOR
%token T_IF
%token T_THEN
%token T_ELSEIF
%token T_ELSE
%token T_ENDIF
%token T_AND
%token T_OR
%token T_SWITCH
%token T_CASE
%token T_DEFAULT
%token T_ENDSWITCH
%token T_PRINT
%token T_BREAK
%token T_STRUCT
%token T_ENDSTRUCT
%token T_TYPEDEF

%left	T_ADDOP 
%left	T_MULOP
%right	'^'

%%

STARTMAIN : body END subprograms;
body : declarations statements;
declarations : declarations type vars 
    | declarations RECORD fields ENDREC vars 
    | declarations DATA vars
    |%empty;
type : INTEGER | CHAR;
vars : vars COMMA undef_variable
    | undef_variable
undef_variable : ID LPAREN dims RPAREN 
    | ID 
dims | dims COMMA dim
    | dim ;
dim : ICONST | ID;
fields : fields field 
    | field ;
field : type vars 
    | RECORD fields ENDREC vars ;
vals : vals COMMA ID value_list
    | ID value_list;
value_list : DIVOP values DIVOP;
values : values COMMA value 
    |value ;
value : repeat MULOP ADDOP constant
    | repeat MULOP constant
    | ADDOP constant
    | constant;
repeat : ICONST 
    |%empty;
constant : ICONST | CCONST;
statements : statements labeled_statement
    | labeled_statement;
labeled_statement : labeled_statement 
    | statement ;
label : ICONST;
statement : simple_statement
    | compound_statement;
simple_statement : assignment
    | if_statement
    | while_statement
    |
    | subroutine_call 
    | io_statement 
    | CONTINUE
    | RETURN
    | STOP ;
assignment : variable ASSIGN expression
    | variable ASSIGN CHAR;
variable : variable COLON ID 
    | variable LPAREN expressions RPAREN
    | ID;
expressions : expression COMMA expression
    | expression;
expression : expression OROP expression 
    | expression ANDOP expression
    | expression RELOP expression
    | expression ADDOP expression
    | expression MULOP expression
    | expression DIVOP expression
    | expression POWEROP expression
    | NOTOP expression
    | ADDOP expression
    | variable
    | constant
    | LPAREN expression RPAREN;

%%
void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}									


int main ( int argc, char **argv  ) 
  {
  ++argv; --argc;
  if ( argc > 0 )
        yyin = fopen( argv[0], "r" );
  else
        yyin = stdin;
  yyout = fopen ( "outputtst", "w" );	
  yyparse ();	    
  return 0;
  }   
		



%%
int main(int argc, char* argv[]) {

    int token; 

    yyin = fopen(argv[1], "r");
                            

    if (yyin == NULL) {
        printf("%s: File not found\n", argv[1]);
        %token 1;
    }

    do { 
        token = yylex();
    } while (token != T_ENDMAIN);

    %token 0;
}


void my_print(int token_id){
    printf("Found token %s (%d) at line %d\n" , yytext , token_id , yylineno);
}

