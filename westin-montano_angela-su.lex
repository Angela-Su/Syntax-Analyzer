/*Westin Montano & Angela Su worked together on the following code*/

%{
    int num_lines = 1, num_columns = 1; 
%}

DIGIT   [0-9]
E_ID_2  [a-zA-Z][a-zA-Z0-9_]*[_]
ID      [a-zA-Z][a-zA-Z0-9_]*
CHAR    [a-zA-Z]
E_ID_1  [0-9_][a-zA-Z0-9_]*


%%
{DIGIT}+        printf("NUMBER %s\n", yytext);

{E_ID_2}        {printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n",
                 num_lines, num_columns, yytext); exit(-1);}

{E_ID_1}        {printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter\n",
                 num_lines, num_columns, yytext); exit(-1);}

function        printf("FUNCTION\n"); num_columns += yyleng;
beginparams     printf("BEGINPARAMS\n"); num_columns += yyleng;
endparams       printf("ENDPARAMS\n"); num_columns += yyleng;
beginlocals     printf("BEGINLOCALS\n"); num_columns += yyleng;
endlocals       printf("ENDLOCALS\n"); num_columns += yyleng;
beginbody       printf("BEGINBODY\n"); num_columns += yyleng;
endbody         printf("ENDBODY\n"); num_columns += yyleng;
integer         printf("INTEGER\n"); num_columns += yyleng;
array           printf("ARRAY\n"); num_columns += yyleng;
enum            printf("ENUM\n"); num_columns += yyleng;
of              printf("OF\n"); num_columns += yyleng;
if              printf("IF\n"); num_columns += yyleng;
then            printf("THEN\n"); num_columns += yyleng;
endif           printf("ENDIF\n"); num_columns += yyleng;
else            printf("ELSE\n"); num_columns += yyleng;
while           printf("WHILE\n"); num_columns += yyleng;
do              printf("DO\n"); num_columns += yyleng;
for             printf("FOR\n"); num_columns += yyleng;
beginloop       printf("BEGINLOOP\n"); num_columns += yyleng;
endloop         printf("ENDLOOP\n"); num_columns += yyleng;
continue        printf("CONTINUE\n"); num_columns += yyleng;
read            printf("READ\n"); num_columns += yyleng;
write           printf("WRITE\n"); num_columns += yyleng;
and             printf("AND\n"); num_columns += yyleng;
or              printf("OR\n"); num_columns += yyleng;
not             printf("NOT\n"); num_columns += yyleng;
true            printf("TRUE\n"); num_columns += yyleng;
false           printf("FALSE\n"); num_columns += yyleng;
return          printf("RETURN\n"); num_columns += yyleng;

"-"             {return SUB; num_columns += yyleng;} 
"+"             {return ADD; num_columns += yyleng;}
"*"             {return MULT; num_columns += yyleng;}
"/"             {return DIV; num_columns += yyleng;}
"%"             {return MOD; num_columns += yyleng;}

"=="             {return EQ; num_columns += yyleng;}
"<>"            {return NEQ; num_columns += yyleng;}
"<"             {return LT; num_columns += yyleng;}
">"             {return GT; num_columns += yyleng;}
"<="            {return LTE; num_columns += yyleng;}
">="            {return GTE; num_columns += yyleng;}

{ID}            {printf("IDENT %s\n", yytext); num_columns+=yyleng;} /* Not sure what to do here !!!!!!!!!!!!!!!!*/

";"             {return SEMICOLON; num_columns += yyleng;
":"             {return COLON; num_columns += yyleng;}
","             {return COMMA; num_columns += yyleng;}
"("             {return L_PAREN; num_columns += yyleng;}
")"             {return R_PAREN; num_columns += yyleng;}
"["             {return L_SQUARE_BRACKET;num_columns+=yyleng;}
"]"             {return R_SQUARE_BRACKET;num_columns+=yyleng;}
":="            {return ASSIGN;num_columns+=yyleng;}
[ ]             num_columns++;
\t              num_columns+=4;
\n           {num_lines++; num_columns = 1;}
"##"[^\n]*"\n"  num_lines++; num_columns = 1;
<<EOF>>         exit(0);

.               {printf("Error at line $d, column %d: unrecognized symbol \"%s\"\n", num_lines, num_columns, yytext); exit(-1);}


/*            
%%
int main(int argc, char **argv){
    ++argv, --argc;


    if(argc > 0){
        yyin = fopen(argv[0], "r");
    }
    else{
        yyin = stdin;
    }
    yylex();
}
*/