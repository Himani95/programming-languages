%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

void yyerror(char *s);
char symboltable[52];
int errcount=0,flag=0,i=0,j=0;
extern int yylineno;
char type[100];	//store IDs in this array for type checking
int size=0;
int state=0;
int addr,add,s;
int insert(char idname[], int idvalue, int idstate, float fidvalue);
void Modify(char upid[], int upvalue, float fupvalue);
int Search(char idsearch[]);
int get_value(char getid[]);
float get_fvalue(char getid[]);
//struct SymTab *p;		//pointer for symbol table
struct SymTab
{
char idname[100];
int idstate;
int idvalue;
float fidvalue;
//struct SymTab *next;
};
struct SymTab p[100];
//struct Symtab *first, *last;
//extern void malloc;
%}

%token TOK_NUM TOK_FL INTEGER FLOAT TOK_ID TOK_PRINTID TOK_PRINTEXP TOK_KEYWORD TOK_SUB TOK_SEMICOLON TOK_MUL TOK_PRINTLN OPENCURLY CLOSECURLY OPENROUND CLOSEROUND TOK_EQUAL

%union
{
int ival;
float fval;
char keyif[50];
char id[100];
};

%type <ival> expr TOK_NUM
%type <fval> expr1 TOK_FL
%type <id> TOK_ID
%type <keyif> INTEGER
%type <keyif> FLOAT

%left TOK_SUB
%left TOK_MUL

%%
prog: TOK_KEYWORD OPENROUND CLOSEROUND OPENCURLY vardefs stmts CLOSECURLY
;

vardefs:
       |vardef vardefs
;

vardef:
     INTEGER TOK_ID TOK_SEMICOLON	{insert($2, 0, 1, 0.0);}
     |FLOAT TOK_ID TOK_SEMICOLON	{insert($2, 0, 2, 0.0);}  
     
;

stmts:
     |expr_stmt stmts
;

expr_stmt: 
	 TOK_PRINTEXP expr TOK_SEMICOLON
	{printf("Value is %d",$2);}
        |TOK_PRINTID TOK_ID TOK_SEMICOLON
	{//printf("that's going to symbol table");
	int i;
	for(i=0;i<size;i++){
	if(strcmp(p[i].idname,$2)==0)
	{
		if(p[i].idstate==1)
			printf("Value is %d",get_value($2));
		else
			printf("Value is %f",get_fvalue($2));
		break;
	}
	}
	//int  value=get_value($2);
	//printf("Hey...value is %d",value);
		}
	|TOK_ID TOK_EQUAL expr TOK_SEMICOLON	{
						int exists=Search($1);
						if(exists==1)
						{
						for(i=0;i<size;i++){
						if(strcmp(p[i].idname,$1)==0){
						if(p[i].idstate==1){
						Modify($1, $3, 0.0);
						}
						else{
						yyerror("Type Error..");
						exit(1);
						}
						break;
						}
						}
						}
						else
						{
							yyerror("Identifier is used but not declared");
							exit(1);
						}
						}
        |TOK_PRINTEXP expr1 TOK_SEMICOLON
         {printf("Value is %f",$2);}

        |TOK_ID TOK_EQUAL expr1 TOK_SEMICOLON
        {//Search($1);
	//printf("Sweetie..you have %f",$3);
	 int exists=Search($1);
                                                if(exists==1)
                                                {

	for(i=0;i<size;i++){
	 if(strcmp(p[i].idname,$1)==0){
                                                if(p[i].idstate==2){
                                                Modify($1, 0, $3);
                                                }
                                                else{
                                                yyerror("Type Error..");
						exit(1);
                                                }
                                                break;
                                                }
                                                }
						 }
                                                else
                                                {
                                                        yyerror("Identifier is used but not declared");
                                                        exit(1);
                                                }

                                                }


;

expr: 
    expr TOK_SUB expr
	{$$=$1-$3;}
    |expr TOK_MUL expr
        {$$=$1*$3;}
    |TOK_NUM
	{//printf("Hey... you are in state 1");
     $$=$1;}
    |TOK_ID		 {//printf("Job of symbol table here..");
			 int value1=get_value($1);
			$$=value1;
			}
;

expr1:
     expr1 TOK_SUB expr1
	{$$=$1-$3;}
     |expr1 TOK_MUL expr1
     {$$=$1*$3;}
     |TOK_FL
      {//printf("Hey there...you are floating in state 2");
	$$=$1;}
     |TOK_ID	{//printf("Again symbol table's job..");
		 //insert($1,0,2);
		float value2=get_fvalue($1);
		$$=value2;
		}
     ;

%%

void yyerror(char *s){
printf("Parsing Error at line %d\n%s",yylineno,s);
errcount=1;
}

int main(){
extern FILE *yyin, **yyout;
//yylex();
//yyin=fopen("input.txt","r");
//yyout=fopen("write.txt","w");
yyparse();
char *t;		//char t[100];
if(errcount==0){
t=type;			
for(j=0;t[j];j++){	//Type checking
if(state==1)	printf("PERFECT INT-");
if(state==2)	printf("PERFECT FLOAT-");
printf("%s",symboltable[j]);
}
}
return 0;
}


//Display symbol table 
/*void display(){
int m;
printf("SYMBOL TABLE\nVariable name\ttype\tvalue\n");
for(int m=0;m<=count;m++)
printf("\n%s\t%s",varname[m],vartype[m],varvalue[m]);
}*/


//Insertion in symbol table
int insert(char id[], int value, int state,float fvalue)
{
int n;
n=Search(id);
if(n==0)
{
strcpy(p[size].idname,id);
if(state==1)
	p[size].idvalue=value;
else
	p[size].fidvalue=fvalue;
p[size].idstate=state;
size++;
//printf("Yay!Inserted Successfully.");
}
}

int Search(char idsearch[]){
int i, sf=0;
for(i=0;i<size;i++)
{
if(strcmp(p[i].idname,idsearch)==0)
{
//printf("Matched!!");
sf=1;
}
}
return sf;
}

void Modify(char upid[], int upvalue,float fupvalue){
s=Search(upid);
if(s==0)
printf("Not Found");
else{
for(i=0;i<size;i++){		
if(strcmp(p[i].idname,upid)==0)
{
if(p[i].idstate==1)
	p[i].idvalue=upvalue;
else
{
	printf("You have-%f",fupvalue);
	p[i].fidvalue=fupvalue;
}
}
}
}
//printf("Hurrah!Modified");
}

int get_value(char getid[]){
for(i=0;i<size;i++){
if(strcmp(p[i].idname,getid)==0)
return p[i].idvalue;
}
return 0;
}

float get_fvalue(char getid[]){
for(i=0;i<size;i++){
if(strcmp(p[i].idname,getid)==0)
return p[i].fidvalue;
}
return 0.0;
}
