%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"

extern FILE* yyin;
extern FILE* yyout;
%}

%%
"VAR"		{}
"END_VAR"	{}
"END_REPEAT" {}

"INT"		{strcpy(yylval.data, "int"); return INT;}
"STRING"	{strcpy(yylval.data, "char*"); return STRING;}
"BOOL"		{strcpy(yylval.data, "bool"); return BOOL;}

"TRUE"		{strcpy(yylval.data, "true"); return TRUE;}
"FALSE"		{strcpy(yylval.data, "false"); return FALSE;}

"TO"		{strcpy(yylval.data, ""); return TO;}
"BY"		{strcpy(yylval.data, ""); return BY;}
"DO"		{strcpy(yylval.data, "{"); return DO;}

"IF"		{strcpy(yylval.data, "if"); return IF;}
"ELSE"		{strcpy(yylval.data, "else"); return ELSE;}
"ELSEIF"	{strcpy(yylval.data, "else if"); return ELSEIF;}
"END_IF"	{strcpy(yylval.data, "}"); return END_IF;}
"THEN"		{strcpy(yylval.data, "{");return THEN;}

"WHILE"		{strcpy(yylval.data, "while"); return WHILE;}
"END_WHILE"	{strcpy(yylval.data, "}");	return END_WHILE;}

"REPEAT"		{strcpy(yylval.data, "do"); return REPEAT;}
"UNTIL"		{strcpy(yylval.data, "while"); return UNTIL;}

"FOR"		{strcpy(yylval.data, "for"); return FOR;}
"END_FOR"	{strcpy(yylval.data, "}");	return END_FOR;}

":=" 		{strcpy(yylval.data, "=");  return ASSIGN;}
"=" 		{strcpy(yylval.data, "==");  return EQUAL;}

":"			{strcpy(yylval.data,yytext); return TYPE; }
";" 		{strcpy(yylval.data, ";\n"); return SEMICOLON; }

["+""-""*""/""\\""<"">""<="">=""'""\""] {strcpy(yylval.data, yytext); return SIGNS;}
[ \t\n\r]  	;

[0-9]+ 		{strcpy(yylval.data,yytext); 	   return NUMBERS; }
[a-zA-Z]+	{strcpy(yylval.data,yytext); 	   return LETTERS; }
. { fprintf(stderr, "Unrecognized character %c in input\n", *yytext); }
%%
int yywrap(){
	return 1;
}