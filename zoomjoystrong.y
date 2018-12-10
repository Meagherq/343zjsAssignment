/***************************************************
*ZoomJoyStrong Assignment for CIS343
*Inputs a text file containing grammar to be parsed
*into an image.
*@Author Quinn Meagher
*@Author Brent Thompson
*version Fall 2018
***************************************************/
%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "zoomjoystrong.h"
  
  #define FALSE 0
  #define TRUE 1

  void yyerror(const char* err);
  void getLine(int x1, int y1, int x2, int y2);
  void getPoint(int x, int y);
  void getCircle(int x, int y, int radius);
  void getRectangle(int x, int y, int width, int height);
  void getColor(int c1, int c2, int c3);
  int getX(int x);
  int getY(int y);
  extern int yylex();
  extern FILE* yyin;
%}
%union
{
  int iVal;
  float fVal;
}
%token END
%token END_STATEMENT
%token POINT
%token LINE
%token CIRCLE
%token RECTANGLE
%token SET_COLOR
%token <iVal> INT
%token <fVal> FLOAT
%%
program: statement_list end
       ;
statement_list: statement
	      | statement statement_list
	      ;
statement: line
	 | point
	 | circle
	 | rectangle
	 | set_color
	 ;

line: LINE INT INT INT INT END_STATEMENT		{getLine($2, $3, $4, $5);}
    ;
point: POINT INT INT END_STATEMENT			{getPoint($2, $3);}
     ;
circle: CIRCLE INT INT INT END_STATEMENT		{getCircle($2, $3, $4);}
      ;
rectangle: RECTANGLE INT INT INT INT END_STATEMENT	{getRectangle($2, $3, $4, $5);}
	 ;
set_color: SET_COLOR INT INT INT END_STATEMENT		{getColor($2, $3, $4);}
	 ;
end: END						{return 0;}
   ;
%%
/****************************************************
*The main function makes sure the file exists and
*then parses all of the grammar functions until the
*functions have all been called then waits for input.
*****************************************************/
int main(int argc, char** argv){
  if(argc != 2){
	yyerror("./zjs <filename>");
	return 1;
  }
  yyin = fopen(argv[1], "r");
  if(!yyin){
	fclose(yyin);
	yyerror("Error opening file");
	return 1;
  }
  setup();
  yyparse();
  printf("Press any key to exit");
  getc(stdin);
  finish();
  return 0;
}
void yyerror(const char* err){
  fprintf(stderr, "Error: %s\n", err);
}
/*******************************************
*Verifies line input and draws proper lines.
*If out of bounds it returns an error.
*******************************************/
void getLine(int x1, int y1, int x2, int y2){
  int invalid  = 0;
int xs[2] = {x1, x2};
int ys[2] = {y1, y2};
for(int i = 0; i < 2; ++i){
  if(!getX(xs[i]) || !getY(ys[i])){
	invalid = 1;
  }
}

  if(!invalid){
    line(x1, y1, x2, y2);
  }
  else{
    yyerror("Out of bounds input\n");
  }
}
/**********************************************
*Verifies point input and draws a proper point.
*If out of bounds it returns an error.
**********************************************/
void getPoint(int x, int y){
  if(getX(x) && getY(y)){
    point(x, y);
  }
  else{
    yyerror("Out of bounds input\n");
  }
}
/***********************************************
*Verfies circle input and draws a proper circle.
*If out of bounds it returns an error.
***********************************************/
void getCircle(int x, int y, int radius){
  if(getX(x) && getY(y) && getY(radius)){
    circle(x, y, radius);
  }
  else{
    yyerror("Out of bounds input\n");
  }
}
/******************************************************
*Verifies rectangle input and draws a proper rectangle.
*If out of bounds if returns an error.
******************************************************/
void getRectangle(int x, int y, int width, int height){
  if(getX(x) && getY(y)){
    if(getX(x + width) && getY(y + height)){
      rectangle(x, y, width, height);
    }
    else{
     yyerror("Rectangle out of bounds");
    }
  }
  else{
   yyerror("Out of bounds input\n");
  }
}
/*****************************************************
*Verifies that the grammar gives a color within range.
*If color out of acceptable range it returns an error.
*****************************************************/
void getColor(int c1, int c2, int c3){
  int invalid = 0;
  int colors[3] = {c1, c2, c3};
  for(int i = 0; i < 3; ++i){
    if(!(colors[i] >= 0 && colors[i] <= 255)){
      invalid = 1;
    }
  }
  if(!invalid){
    set_color(c1, c2, c3);
  }
  else{
    yyerror("Invalid color");
  }
}
/******************************
*Verifies the x input is valid.
*If valid returns true.
*If invalid returns false.
******************************/
int getX(int x){
  if(x < 0 || x > WIDTH){
    return FALSE;
  }
  return TRUE;
}
/******************************
*Verifies the y input is valid.
*If valid return true.
*If invalid return false.
******************************/
int getY(int y){
  if(y < 0 || y > HEIGHT){
    return FALSE;
  }
  return TRUE;
}
