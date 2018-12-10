%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "zoomjoystrong.tab.h"
  #include "zoomjoystrong.h"
  void white_space(char* lex);
%}

%option yylineno
%option noyywrap

%%

(END|end)		{return END;}
;			{return POINT;}
(LINE|line)		{return LINE;}
(CIRCLE|circle)		{return CIRCLE;}
(RECTANGLE|rectangle)	{return RECTANGLE;}
(SET_COLOR|set_color)	{return SET_COLOR;}
[0-9]+			{yylval.iVal = atoi(yytext); return INT;}
[0-9]+\.[0-9]+		{return FLOAT;}
-[0-9]			{printf("ERROR: Negative number on line %d\n", yylineno);}
[\n|\n| ]+		;
.			{printf("ERROR: Invalid syntax on line %d\n", yylineno);}
%%

