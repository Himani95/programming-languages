%{
#include<stdio.h>
#include<math.h>	//needed to call atof()
#include "calc.tab.h"
%}

digit ([0-9])
id [a-z][A-Z0-9]*

%%

"printID"	{return TOK_PRINTID;}
"printExp"	{return TOK_PRINTEXP;}
"main"		{return TOK_KEYWORD;}
"int"		{sscanf(yytext,"%d",yylval.keyif);
		return INTEGER;}
"float"		{yylval.fval=atof(yytext);
		sscanf(yytext,"%d",&yylval.fval);
		return FLOAT;}
"-"		{return TOK_SUB;}
"*"		{return TOK_MUL;}
";"		{return TOK_SEMICOLON;}
"{"		{return OPENCURLY;}
"}"		{return CLOSECURLY;}
"("		{return OPENROUND;}
")"		{return CLOSEROUND;}
"="		{return TOK_EQUAL;}

{digit}+ 	{sscanf(yytext,"%d",&yylval.ival);
		return TOK_NUM;
	}

{digit}+[.]{digit}*	{//yylval.fval=atof(yytext);
			sscanf(yytext,"%f",&yylval.fval);
		//	printf("FLOATING mode on");
			return TOK_FL;
	}
{digit}+"E"{digit}+     {
                        sscanf(yytext,"%f",&yylval.fval);
                       // printf("FLOATING mode on");
                        return TOK_FL;
        }

{digit}+[.]{digit}*"E"{digit}+     {
                        sscanf(yytext,"%f",&yylval.fval);
                        //printf("FLOATING mode on");
                        return TOK_FL;
        }


{id}+	{sscanf(yytext,"%s",&yylval.id);
	return TOK_ID;
	}

[\n]	{}
   
%%
