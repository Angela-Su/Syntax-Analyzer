%{
    #include <stdio.h>
    #include <stdlib.h>
    void yyerror(const char *msg);
    extern int num_lines;
    extern int num_columns;
    FILE *yyin;
%}

%union{
    int num_val;
    char* id_val;
}
%error-verbose
%start prog_start
%token FUNCTION BEGINPARAMS ENDPARAMS BEGINLOCALS ENDLOCALS BEGINBODY ENDBODY INTEGER ARRAY ENUM OF IF THEN ENDIF ELSE WHILE FOR DO BEGINLOOP ENDLOOP CONTINUE READ WRITE TRUE FALSE SEMICOLON COLON COMMA L_PAREN R_PAREN L_SQUARE_BRACKET R_SQUARE_BRACKET ASSIGN RETURN
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

prog_start: functions { printf("prog_start -> functions\n");}
        ;

functions: /*empty*/{printf("functions -> epsilon\n");}
            | function functions {printf("functions -> function functions\n");}
        ;
function: FUNCTION IDENT SEMICOLON BEGINPARAMS declarations ENDPARAMS BEGINLOCALS declarations ENDLOCALS BEGINBODY statements ENDBODY
            {printf("function --> FUNCTION IDENT SEMICOLON BEGINPARAMS declarations ENDPARAMS BEGINLOCALS declarations ENDLOCALS BEGIN BODY statements ENDBODY");}
        ;

declarations: /*empty*/{printf("declarations -> epsilon\n");}
            | declaration SEMICOLON declarations {printf("declarations -> declaration SEMICOLON declarations\n");}
            ;

declaration:        IDENT COLON INTEGER {printf("declaration -> IDENT COLON INTEGER\n");}
            | IDENT COMMA IDENT COLON INTEGER {printf("declaration -> IDENT COMMA IDENT COLON INTEGER\n");}
            | IDENT COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER {printf("declaration -> IDENT COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER\n");}
            | IDENT COMMA IDENT COLON L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER {printf("declaration -> IDENT COMMA IDENT COLON L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER\n");}        
        ;
        
statements: /*empty*/ {printf("statements -> epsilon\n");}
            | statement SEMICOLON statements {printf("statements -> statement SEMICOLON statements\n");}
        ;
        
statement: var ASSIGN expression { printf("statement -> var ASSIGN expression\n");}
            | IF bool_expr THEN statements ENDIF {printf("statement -> IF bool_expr THEN statements ENDIF\n");}
            | IF  bool_expr THEN statements ELSE statements ENDIF { printf("statement -> IF bool_expr THEN statements ELSE statements ENDIF\n");}
            | WHILE bool_expr BEGINLOOP statements ENDIF {printf("statement -> WHILE bool_expr BEGINLOOP statements ENDIF\n");}
            | DO BEGINLOOP statements ENDLOOP WHILE bool_expr {printf("statement -> DO BEGINLOOP statements ENDLOOP WHILE bool_expr\n");}
            | FOR vars ASSIGN NUMBER SEMICOLON bool_expr SEMICOLON vars ASSIGN expression BEGINLOOP statements ENDLOOP {printf("statement -> FOR vars ASSIGN NUMBER SEMICOLON bool_expr SEMICOLON vars ASSIGN expression BEGINLOOP statements ENDLOOP");}
            | READ vars { printf("statement -> READ vars\n");}
            | WRITE vars { printf("statement -> WRITE vars\n");}
            | CONTINUE { printf("statement -> CONTINUE\n");}
            | RETURN expression {printf("statement -> RETURN expression\n");}
        ;
        
bool_expr:         L_PAREN relation_and_expr R_PAREN{printf("relation_and_expr -> relation_expr\n");}
            | L_PAREN relation_and_expr OR bool_expr R_PAREN {printf("relation_and_expr -> relation_expr OR bool_expr\n");}
            ;

relation_and_expr:  relation_expr {printf("relation_and_expr -> relation_expr\n");}
            | relation_expr AND relation_expr {printf("relation_and_expr -> relation_expr AND relation_and_expr\n");}
            ;
relation_expr:      expression comp expression {printf("relation_expr -> expression comp expression\n");}
            | NOT expression comp expression {printf("relation_expr -> NOT expression comp expression\n");}
            | TRUE {printf("relation_expr -> TRUE\n");}
            | NOT TRUE {printf("relation_expr -> NOT TRUE\n");}
            | FALSE {printf("relation_expr -> FALSE\n");}
            | NOT FALSE {printf("relation_expr -> NOT FALSE\n");}
            | L_PAREN bool_expr R_PAREN {printf("relation_expr -> L_PAREN bool_expr R_PAREN\n");}
            | NOT L_PAREN bool_expr R_PAREN {printf("relation_expr -> NOT L_PAREN bool_expr R_PAREN\n");}
            ;
comp: EQ {printf("comp -> EQ\n");}
    | NEQ {printf("comp -> NEQ\n");}
    | LT {printf("comp -> LT\n");}
    | GT {printf("comp -> GT\n");}
    | LTE {printf("comp -> LTE\n");}
    | GTE {printf("comp -> GTE\n");}
    
expressions: expression COMMA expressions {printf("expressions -> expression COMMA expressions\n");}
            | expression {printf("expressions-> expression\n");}
            ;
expression: multiplicative-expr {printf("expression -> multiplicative-expr\n");}
            | multiplicative-expr ADD multiplicative-expr {printf("expression -> multiplicative-expr ADD multiplicative-expr\n");}
            | multiplicative-expr SUB multiplicative-expr {printf("expression -> multiplicative-expr SUB multiplicative-expr\n");}
            ;
multiplicative-expr: term {printf("multiplicative-expr -> term\n");}
                    | term MULT multiplicative-expr {printf("multiplicative-expr -> term MULT multiplicative-expr\n");}
                    | term DIV multiplicative-expr {printf("multiplicative-expr -> term DIV multiplicative-expr\n");}
                    | term MOD multiplicative-expr {printf("multiplicative-expr -> term MOD multiplicative-expr\n");}
                    ;
term: SUB var {printf("term -> SUB var\n");}
    | SUB NUMBER {printf("term -> SUB NUMBER\n");}
    | SUB L_PAREN expression R_PAREN {printf("term -> SUB R_PAREN expression L_PAREN\n");}
    | var {printf("term -> var\n");}
    | NUMBER {printf("term -> NUMBER\n");}
    | L_PAREN expression R_PAREN {printf("term -> R_PAREN expression L_PAREN\n");}
    /*| IDENT L_PAREN expression R_PAREN {printf("term -> IDENT L_PAREN expression R_PAREN\n");} Dont think this is needed*/
    | IDENT L_PAREN expressions R_PAREN {printf("term -> IDENT L_PAREN expressions R_PAREN\n");}
    ;
vars:  var {printf("vars -> var\n");}
        |var COMMA vars {printf("vars -> var COMMA vars\n");}
        ;
var: IDENT {printf("IDENT\n");}
    | IDENT L_SQUARE_BRACKET expression R_SQUARE_BRACKET {printf("IDENT L_SQUARE_BRACKET expression R_SQUARE_BRACKET");}
    ;
    
%%
int main(int argc, char ** argv) {
    if(argc > 1) {
        yyin = fopen(argv[1], "r");
        if(yyin == NULL){
            printf("syntax: %s filename", argv[0]);
        }
    }
    yyparse();
    return 0;
}
void yyerror(const char *msg) {
    printf("Error: Line %d, position %d: %s \n", num_lines, num_columns, msg);
}
