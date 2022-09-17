%{


%}

%%

STARTMAIN : body END subprograms
body : declarations statements
declarations : declarations type vars 
    | declarations RECORD fields ENDREC vars 
    | declarations DATA vars
    |%empty
type : INTEGER | CHAR
vars : vars COMMA undef_variable
    | undef_variable
undef_variable : ID LPAREN dims RPAREN 
    | ID 
dims | dims COMMA dim
    | dim 
dim : ICONST | ID
fields : fields field 
    | field 
field : type vars 
    | RECORD fields ENDREC vars 
vals : vals COMMA ID value_list
    | ID value_list
value_list : DIVOP values DIVOP
values : values COMMA value 
    |value 
value : repeat MULOP ADDOP constant
    | repeat MULOP constant
    | ADDOP constant
    | constant
repeat : ICONST 
    |%empty
constant : ICONST | CCONST
statements : statements labeled_statement
    | labeled_statement
labeled_statement : labeled_statement 
    | statement 
label : ICONST
statement : simple_statement
    | compound_statement
simple_statement : assignment
    | if_statement
    | while_statement
    |
    | subroutine_call 
    | io_statement 
    | CONTINUE
    | RETURN
    | STOP 
assignment : variable ASSIGN expression
    | variable ASSIGN CHAR
variable : variable COLON ID 
    | variable LPAREN expressions RPAREN
    | ID
expressions : expression COMMA expression
    | expression
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
    | LPAREN expression RPAREN





%%
