%{
    #include <stdio.h>
    #include <stdlib.h>
    void yyerror(const char *msg);
    extern int currLine;
    extern int currPos;
    FILE *yyin;
%}

%union{
    int num_val;
    char* id_val;
}
%error-verbose
%start prog_start
%token FUNCTION BEGINPARAMS ENDPARAMS BEGINLOCALS ENDLOCALS BEGINBODY ENDBODY INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE FOR DO BEGINLOOP ENDLOOP CONTINUE READ WRITE TRUE FALSE SEMICOLON COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET ASSIGN RETURN
%token <id_val> IDENT
%token <num_val> NUMBER
%right ASSIGN
%left OR
%left AND
%right NOT
%left LT LTE GT GTE EQ NEQ
%left ADD SUB
%left MULT DIV MOD
%%

prog_start: function { printf("prog_start -> function\n");}
        ;

functions: /*empty*/{printf("functions -> epsilon\n");}
            | function functions {printf("functions -> function functions\n");}
        ;
function: FUNCTION ident SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS delcarations END_LOCALS BEGIN_BODY statements END_BODY
            {printf("function --> FUNCTION IDENT SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN BODY statements END_BODY");}
        ;
statements: /*empty*/ {printf("statements -> epsilon\n");}
            | statement SEMICOLON statements {printf("statements -> statement SEMICOLON statements\n");}
        ;
statement: var ASSIGN expression { printf("statement -> var ASSIGN expression\n");}
            | IF bool_exp THEN statements ENDIF {printf("statement -> IF bool_exp THEN statements ENDIF\n");}
            | IF bool_exp THEN statements ELSE statements ENDIF { printf("IF bool_exp THEN statements ELSE statements ENDIF\n");}
            | WHILE bool_exp BEGINLOOP statements ENDIF {printf("WHILE bool_exp BEGINLOOP statements ENDIF\n");}
            | DO BEGINLOOP statements ENDLOOP WHILE bool_exp {printf("DO BEGINLOOP statements ENDLOOP WHILE bool_exp\n");}
            | FOR vars ASSIGN NUMBER SEMICOLON bool_exp SEMICOLON vars ASSIGN expression BEGINLOOP statements ENDLOOP {printf("FOR vars ASSIGN NUMBER SEMICOLON bool_exp SEMICOLON vars ASSIGN expression BEGINLOOP statements ENDLOOP");}
            | READ vars { printf("statement -> READ vars\n");}
            | WRITE vars { printf("statements -> WRITE vars\n");}
            | CONTINUE { printf("statement -> CONTINUE\n");}
            | RETURN expression {printf("statement -> RETURN expression\n");}
        ;

multiplicative-expr: term {printf("term\n");}
                    | term MULT multiplicative-expr {printf("term MULT multiplicative-expr\n");}
                    | term DIV multiplicative-expr {printf("term DIV multiplicative-expr\n");} */still needs more*/

term: MINUS var {printf("MINUS var\n");}
    | MINUS NUMBER {printf("MINUS NUMBER\n");}
    | MINUS L_PAREN expression R_PAREN {printf("MINUS R_PAREN expression L_PAREN"\n);}
    | var {printf("var\n");}
    | NUMBER {printf("NUMBER\n");}
    | L_PAREN expression R_PAREN {printf("R_PAREN expression L_PAREN"\n);}
    | IDENT L_PAREN expression R_PAREN {printf("IDENT L_PAREN expression R_PAREN\n");}
    | IDENT L_PAREN expressions R_PAREN {printf("IDENT L_PAREN expressions R_PAREN\n");}
    ;

vars:   /*empty*/ {printf("statements -> epsilon\n");}
        |var COMMA vars {printf("vars -> var COMMA vars\n");}
        ;
var: IDENT {printf("IDENT\n");}
    | IDENT L_SQUARE_BRACKET expression R_SQUARE_BRACKET {printf("IDENT L_SQUARE_BRACKET expression R_SQUARE_BRACKET");}
    ;
%