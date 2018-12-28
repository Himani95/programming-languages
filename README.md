# programming-languages
The written code acts as a parser for C language. 
2.It accepts the defined grammar and outputs accordingly. 
3.The defined grammar takes into account subtract and multiply expressions, integer and float identifiers and outputs the value accordingly. 
4.At the same time, a symbol table is created when you declare either an int or float identifier for the first time and value 0 is passed for it. 
5.If it already exists in the symbol table then the previous value gets modified with this new assigned value to expression. 
6.The Modify function performs this task. 
7.If its declared but not used then the same is returned. 
8.The symbol table stores the identifiers name, value and datatype. 
9.Here, int is state=1 and float=state 2. 
10.So if a expression in float is entered the type checking mode will check if a float value has been assigned as result to the expression and similarly for integer type. 
11.When we try to retrieve the datatype from symbol table a state gets returned as either 1 or 2. 
12.The search function searches if the required identifier exists in the symbol table and if yes then it returns sf(search flag). 
13.The get_value and get_fvalue functions help return int and float values from symbol table respectively.    
