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
%