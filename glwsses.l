%{
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>
#include <string.h>
#include "tokens.h"

void my_print(int token_id);

%}


%option noyywrap
%option yylineno
%x single_line_comment

DIGIT      [0-9]
LETTER     [a-zA-Z]
ALPHANUM   [{LETTER}|{DIGIT}]

%%

"CHAR"                       {my_print(T_CHAR); return T_CHAR;}
"INTEGER"                    {my_print(T_INTEGER);  return T_INTEGER;}
"VARS"                       {my_print(T_VARS); return T_VARS;}
"PROGRAM"                    {my_print(T_PROGRAM); return T_PROGRAM;}
"FUNCTION"                   {my_print(T_FUNCTION); return T_FUNCTION;}
"END_FUNCTION"               {my_print(T_ENDFUNCTION); return T_ENDFUNCTION;}
"RETURN"                     {my_print(T_RETURN); return T_RETURN;}
"STARTMAIN"                  {my_print(T_STARTMAIN); return T_STARTMAIN;}
"ENDMAIN"                    {my_print(T_ENDMAIN); return T_ENDMAIN;}
"WHILE"                      {my_print(T_WHILE); return T_WHILE;}
"ENDWHILE"                   {my_print(T_ENDWHILE); return T_ENDWHILE;}
"FOR"                        {my_print(T_FOR); return T_FOR;}
"TO"                         {my_print(T_TO); return T_TO;}
"STEP"                       {my_print(T_STEP); return T_STEP;}
"ENDFOR"                     {my_print(T_ENDFOR); return T_ENDFOR;}
"IF"                         {my_print(T_IF); return T_IF;}
"THEN"                       {my_print(T_THEN); return T_THEN;}
"ELSEIF"                     {my_print(T_ELSEIF); return T_ELSEIF;}
"ELSE"                       {my_print(T_ELSE); return T_ELSE;}
"ENDIF"                      {my_print(T_ENDIF); return T_ENDIF;}
"AND"                        {my_print(T_AND); return T_AND;}
"OR"                         {my_print(T_OR); return T_OR;}
"SWITCH"                     {my_print(T_SWITCH); return T_SWITCH;}
"CASE"                       {my_print(T_CASE); return T_CASE;}
"DEFAULT"                    {my_print(T_DEFAULT); return T_DEFAULT;}
"ENDSWITCH"                  {my_print(T_ENDSWITCH); return T_ENDSWITCH;}
"PRINT"                      {my_print(T_PRINT); return T_PRINT;}
"BREAK"                      {my_print(T_BREAK); return T_BREAK;}
"STRUCT"                     {my_print(T_STRUCT); return T_STRUCT;}
"ENDSTRUCT"                  {my_print(T_ENDSTRUCT); return T_ENDSTRUCT;}
"TYPEDEF"                    {my_print(T_TYPEDEF); return T_TYPEDEF;}



{DIGIT}                      {my_print(T_INTEGER); return T_INTEGER;}

.                            {printf("Unrecognised character at line %d!\n", yylineno);}
<<EOF>>                      { return 0;}




"OR"                         {my_print(T_OROP); return T_OROP;}
"AND"                        {my_print(T_ANDOP); return T_ANDOP;}


"=="                         {my_print(T_EQUOP); return T_EQUOP;}
"!="                         {my_print(T_EQUOP); return T_EQUOP;}
"+"                          {my_print(T_ADDOP); return T_ADDOP;}
"-"                          {my_print(T_ADDOP); return T_ADDOP;}
"*"                          {my_print(T_MULOP); return T_MULOP;}
"/"                          {my_print(T_MULOP); return T_MULOP;}
"!"                          {my_print(T_NOTOP); return T_NOTOP;}
">"                          {my_print(T_RELOP); return T_RELOP;}
">="                         {my_print(T_RELOP); return T_RELOP;}
"<"                          {my_print(T_RELOP); return T_RELOP;}
"<="                         {my_print(T_RELOP); return T_RELOP;}


"("                          {my_print(T_LPAREN); return T_LPAREN;}
")"                          {my_print(T_RPAREN); return T_RPAREN;}
";"                          {my_print(T_SEMI); return T_SEMI;}
","                          {my_print(T_COMMA); return T_COMMA;}
"="                          {my_print(T_ASSIGN); return T_ASSIGN;}
"["                          {my_print(T_LBRACK); return T_LBRACK;}
"]"                          {my_print(T_RBRACK); return T_RBRACK;}
"%"                          {my_print(T_COMMENT); return T_COMMENT;}



\'[a-zA-Z0-9]\'              {my_print(T_CCONST); return T_CCONST;}
\'[!@#$%^&*()]\'             {my_print(T_CCONST); return T_CCONST;}



'[^\]|\\[nbtrv]'             {my_print(T_CCONST); return T_CCONST;}





[ \t]                        {     }
[\n]                         {     }
[\r\n]                       {     }






"%"                             {printf("Comment found\n"); BEGIN(single_line_comment);} 
<single_line_comment>(\n|\r\n)  {BEGIN(INITIAL; printf("Comment ended\n"););}
<single_line_comment>.          {  }
 






%%

int main(int argc, char* argv[]) {

    int token; 

    yyin = fopen(argv[1], "r");
                            

    if (yyin == NULL) {
        printf("%s: File not found\n", argv[1]);
        return 1;
    }

    do { 
        token = yylex();
    } while (token != T_ENDMAIN);

    return 0;
}


void my_print(int token_id){
    printf("Found token %s (%d) at line %d\n" , yytext , token_id , yylineno);
}

