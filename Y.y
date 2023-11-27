%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "y.tab.h"

extern FILE* yyin;
extern FILE* yyout;

int yylex();

char* toLowerString(const char* str) {
    char* result = strdup(str);
    int len = strlen(result);
    
    for (int i = 0; i < len; ++i) {
        result[i] = tolower(result[i]);
    }
    
    return result;
}

%}

%union {
    char data[20];
    char code[1000];
}

%token <data> LETTERS INT BOOL TYPE SEMICOLON ASSIGN SIGNS NUMBERS TRUE FALSE EQUAL IF END_IF THEN ELSE 
%token <data> FOR TO BY END_FOR WHILE END_WHILE REPEAT UNTIL DO ELSEIF STRING
%token  VAR END_VAR END_REPEAT
%type <code> COMMANDS COMMAND DECLAR START TYPES_LOGIC DECLARATION EXP BOOLS_LOGIC IF_LOGIC CYCLE_LOGIC
%start START

%%

START:
    COMMANDS { fprintf(yyout, "%s", $1);}

COMMANDS:
    COMMAND {strcpy($$, $1);}
    | COMMANDS COMMAND {strcpy($$, $1); strcat($$, $2);}

COMMAND:
    DECLARATION {strcpy($$, $1); }
    | IF_LOGIC {strcpy($$, $1);}
    | CYCLE_LOGIC {strcpy($$, $1);}
    | SEMICOLON {strcpy($$, $1);}

DECLARATION:
    DECLAR {strcpy($$, $1);}
    | DECLARATION DECLAR {strcpy($$, $1); strcat($$, $2);}

DECLAR:
    LETTERS TYPE TYPES_LOGIC { 
        printf("%s %s %s\n", $1, $2, $3);
        strcpy($$, $3); strcat($$, " "); strcat($$, $1);
    }
    | LETTERS ASSIGN EXP SIGNS EXP {
        printf("%s %s %s %s %s\n", $1, $2, $3, $4, $5);
        strcpy($$, $1); strcat($$, $2); strcat($$, $3); strcat($$, $4); strcat($$, $5);
    }
    | LETTERS ASSIGN BOOLS_LOGIC {
        printf("%s %s %s\n", $1, $2, $3);
        strcpy($$, $1); strcat($$, $2); strcat($$, $3);
    }
    | EXP EQUAL EXP {
        printf("%s %s %s\n", $1, $2, $3);
        strcpy($$, $1); strcat($$, $2); strcat($$, $3); 
    }
    | EXP SIGNS EXP {
        printf("%s %s %s\n", $1, $2, $3);
        strcpy($$, $1); strcat($$, $2); strcat($$, $3);
    }
    | LETTERS ASSIGN EXP {
        strcpy($$, $1); strcat($$, $2); strcat($$, $3);
    }

IF_LOGIC:
    IF DECLARATION THEN { 
        strcpy($$, $1); strcat($$, " ("); strcat($$, $2); strcat($$, ") "); strcat($$, $3); strcat($$, "\n");
    }
    | ELSE { strcpy($$, "} "); strcat($$, $1); strcat($$, " {\n"); }
    | ELSEIF DECLAR { strcpy($$, "} "); strcat($$, $1); strcat($$, " "); strcat($$, $2); strcat($$, " {\n"); }
    | END_IF {strcpy($$, $1); strcat($$, "\n");}

CYCLE_LOGIC:
    FOR LETTERS ASSIGN NUMBERS TO NUMBERS BY NUMBERS DO {
        printf("%s %s %s %s %s %s %s %s %s\n", $1, $2, $3, $4, $5, $6, $7, $8, $9);
        strcpy($$, $1); strcat($$, " ("); 
        strcat($$, $2); strcat($$, $3); strcat($$, $4); strcat($$, "; ");
        strcat($$, $2); strcat($$, "<"); strcat($$, $6); strcat($$, "; ");
        strcat($$, $2); strcat($$, "="); strcat($$, $2); strcat($$, "+"); strcat($$, $8); strcat($$, ";");
        strcat($$, ") "); strcat($$, $9); strcat($$, "\n");
    }
    | WHILE DECLAR DO {
        strcpy($$, $1); strcat($$, " ("); strcat($$, $2); strcat($$, ") "); strcat($$, $3); strcat($$, "\n");  
    }
    | REPEAT {strcpy($$, $1); strcat($$, " {\n");}
    | UNTIL DECLAR {strcpy($$, "} "); strcat($$, $1); strcat($$, " ("); strcat($$, $2); strcat($$, ");\n");}
    | END_FOR {strcpy($$, $1); strcat($$, "\n");}
    | END_WHILE {strcpy($$, $1); strcat($$, "\n");}

EXP:
    LETTERS {strcpy($$, $1);}
    | NUMBERS {strcpy($$, $1);}

BOOLS_LOGIC:
    TRUE {strcpy($$, $1);}
    | FALSE {strcpy($$, $1);}

TYPES_LOGIC:
    INT {strcpy($$, $1);}
    | BOOL {strcpy($$, $1);}
    | STRING {strcpy($$, $1);}
    
%%

void yyerror (const char *s) {
   fprintf (stderr, "%s\n", s);
 }

int main() {
    yyin = fopen("text.txt", "r");
    yyout = fopen("output.txt", "w");

    if (!yyin || !yyout) {
        printf ("Error opening files\n");
        return 1;
    }

    fprintf(yyout, "#include<iostream>\n\nint main() {\n");

    do {
        yyparse();
    } while (!feof(yyin));
    fprintf(yyout, "return 0;\n}");

    fclose(yyin);
    fclose(yyout);

    return 0;
}
