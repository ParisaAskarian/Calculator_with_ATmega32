#include <mega32.h>
#include <stdio.h>
#include <lcd.h>
#include <delay.h>
#include <string.h>
#include <stdbool.h>
#asm
.equ __lcd_port=0x1B;PORTA
#endasm

//keypad charecters
unsigned char code[4][4] = {
    {7, 4, 1, 10}, //first column
    {8, 5, 2, 0}, //second column
    {9, 6, 3, 11}, //third column
    {12, 13, 14, 15}, //fourth column
    };

//keep the input expression from keypad
unsigned char exp[32];
int exp_size = 0;

//a stack for operands
int operands[32];
int top_operands = -1;
 
 //a stack operators   
unsigned char operators[32];
int top_operators = -1; 

//a stack for keep a multi digit number
//when the digits of number are finished, then push the full number in operands stack
int fix_operand[32];
int top_fix_oper = -1;

void test(void){
    
    //test number 1:
     //check the exp list was exacly the same as input from keypad;
    //int i;
    //lcd_clear(); 
    //lcd_gotoxy(0, 0);
    //for(i=0; i < exp_size; i++){
    //    lcd_putchar(exp[i]);
    //    delay_ms(30);
    //}
    
    //test number 2:
    // check the operands and operators stacks are be correct
    int i;    
    lcd_clear();
    lcd_gotoxy(0, 0);
    for(i=0; i < 2; i++){
        lcd_putchar(operands[i]);
        lcd_putchar(',');
        delay_ms(30);
    } 
    lcd_putchar(operators[top_operators]);
    delay_ms(30);
    
    //test number 3:
    //check that fix_operand stack was correct
    //lcd_clear();
    //lcd_gotoxy(0, 0);
    //lcd_putchar(fix_operand[top_fix_oper]);
    //delay_ms(30);

}

//scan the pushed key    
unsigned char scan_key(void){

    unsigned char i, data, NumKey, temp;
    
    temp = 0x70;
    NumKey = 0xFF;
    
    for(i = 0; i < 4; i++){
        PORTC = temp;
        delay_ms(5);
        
        data = PINC & 0x0F;
        
        if( data == 0x07) {NumKey = code[0][i]; break;}
        if( data == 0x0B) {NumKey = code[1][i]; break;}
        if( data == 0x0D) {NumKey = code[2][i]; break;}
        if( data == 0x0E) {NumKey = code[3][i]; break;}
        
        temp = ((temp >> 1)| 0x80)& 0xF0;
    }                                    
    
    return NumKey;
    
}   

//this function is for when the input expression is invalid 
void error(void){
    lcd_clear();
    lcd_gotoxy(5, 0);
    lcd_putsf("Invalid");
    lcd_gotoxy(3, 1);
    lcd_putsf("Expression");
    delay_ms(30);
    
    exp_size =0;
    top_operators = -1;
    top_operands = -1;
    top_fix_oper = -1;
    return;
}

//pop the top value in a stack
void pop(int *top){
    if( *top == -1){
        error();
        return;
    }                             
    else{
        (*top)--;
    }
    
}

//push a value at the top of stack
void push_operator(unsigned char stack[32], int *top, unsigned char value){
    if( *top == 31){
        error();
        return;
    }                            
    else{
        (*top)++;
        stack[*top] = value;
    }
}

void push_operand(int stack[32], int *top, int value){
    if( *top == 31){
        error();
        return;
    }                            
    else{
        (*top)++;
        stack[*top] = value;
    }
}

//just see the top value in stack
unsigned char peek_operator(unsigned char stack[32], int top){
    if( top == -1){
        error();
        return 255;
    }             
    
    return stack[top];
}

int peek_operand(int stack[32], int top){
    if( top == -1){
        error();
        return;
    }             
    
    return stack[top];
}

//making the multi digit number and push it at the top of operand stack
void read_and_push_fix_operand(void){
    
    int value;
    int number = 0;
    int mul = 1;
    
    //test();
    
    //moving on the stack and read on by on charecters and convert them to a digit
    while(top_fix_oper != -1){
        value = peek_operand(fix_operand, top_fix_oper);
        number = number +( (value - '0') * (mul));
        mul = mul * 10;
        pop(&top_fix_oper);       
    }  
    
    push_operand(operands, &top_operands, number);
    
}

//do the operators
// for example: if the operator is "+" , this function add two top operands stack values together 
//and return back the result into the operands stack
void caculate(int num1, int num2, unsigned char operator){
    int result;
    
    //test number 4:
    //check that num1 and num2 are correct
    //lcd_clear();
    //lcd_gotoxy(0, 0);
    //lcd_putchar(num1); 
    //delay_ms(30);
    //lcd_putchar(num2);
    //delay_ms(30); 
    //lcd_putchar(operator);
    //delay_ms(30);
    
    if(operator == '/'){ 
        
        if(num2 == 0){
            error();
            return;
        }
        
        result = num1 / num2;
                
    }
    else if( operator == '*'){
        result = num1 * num2;
    }            
    else if ( operator == '-'){
        result = num1 - num2;
    }
    else if ( operator == '+'){
        result = num1 + num2;
    } 
    
    push_operand(operands, &top_operands, result);
}

//when the expression is over and program pushed all charecters in stacks,
//program must start moving on operators and operands stack,
// for any operator, pick up two operands and caxulathe result
void finall_caculation(void){
    int num1;
    int num2;
    unsigned char operator;
    
    while(top_operators != -1){
        
         operator = peek_operator(operators, top_operators);
         pop(&top_operators);
         
         if(top_operands < 1){
            error();
            return;
        }
            
         num2 = peek_operand(operands, top_operands);
         pop(&top_operands); 
            
         num1 = peek_operand(operands, top_operands);
         pop(&top_operands);
            
         caculate(num1, num2, operator);
    }
    if(top_operands > 0 || top_operands == -1){
         error();
         return ;
                 
    }
    
}

//this function give the operators a value,
//then program can compare them:
// the value of "-" and "+" is 1
// the value of "*" and "/" is 2
int value(unsigned char operator){
    int val;
    
    if(operator == '-' || operator == '+'){
        val = 1;
    }
    else{
        val = 2;
    }           
    
    return val;
}

// this function is the brain of the program:
// moving in expression and push the operators in operators stack,
// and push the operands in operands stack.
// if the value of the top operator in operators stack,
// is bigger than / equal the value of the current operator in
// expression, first calculate the top operator in stack,
// then push the current operator.
void caculate_exp(void){
    int i; 
    
    unsigned char charecter;
    unsigned char charecterInStack;
    
    int num1;
    int num2;
    
    bool expect_operand = true;
    
    char valid_operators[] = "-+/*";
    
    if( exp_size == 0){
        error();
        return;
    }
    
    for(i=0; i< exp_size ; i++){  
    
        //test();
    
        charecter = exp[i];
        
        if(strchr(valid_operators, charecter) != NULL  ){
        
            if(expect_operand == true){
                error();
                return;
            }
        
            read_and_push_fix_operand();
            
            if(top_operators == -1){
                push_operator(operators, &top_operators, charecter);

            }
            else{
                
                while (top_operators != -1){
                    
                    charecterInStack = peek_operator(operators, top_operators);
                    
                    if(value(charecter)> value(charecterInStack)){
                        break;
                    }
                
                    if(top_operands < 1){
                        error();
                        return;
                    
                    }
                
                    num2 = peek_operand(operands, top_operands);
                    pop(&top_operands); 

                    num1 = peek_operand(operands, top_operands);
                    pop(&top_operands);

                    caculate(num1, num2, charecterInStack); 
                    pop(&top_operators);
                       
                }

                push_operator(operators,&top_operators,charecter);
                
                expect_operand = true;  
            }
        }
        else{ 
           
            push_operand(fix_operand, &top_fix_oper,charecter);   
            
            expect_operand = false;
            
            //test();
        
        } 
               
    }
    
    if(top_fix_oper != -1){
        read_and_push_fix_operand();
    }
    
    if( top_operators != -1 && top_operands >= 1 ){
    
        //test();
    
        finall_caculation();
        return ;
    }
    else{
        error();
        return;
    }
   
}

//show the expression on LCD and when click on "=" key,
// show the result of the expression .
void show_on_lcd(void){
    unsigned char Key;
    int result;
    char result_string[10];

    DDRC = 0xF0;
    PORTC = 0x0F; 
    
    DDRA = 0xFF;
    PORTA = 0x00;
    
    lcd_init(16);
    lcd_clear(); 
    lcd_gotoxy(0,0);
    
    while(1){
        Key = scan_key();
        
        if (Key != 0xFF){
        
            if( Key < 10){
                lcd_putchar(Key + '0');
                exp[exp_size] = Key + '0';
                exp_size++;
                
            }
            else if( Key == 10){
                lcd_clear();
                
                exp_size = 0;

                top_operators = -1;
                top_operands = -1;
                top_fix_oper = -1;
            }
            else if( Key == 11){
            
                //test();
            
                lcd_clear();
                lcd_gotoxy(0,0);
                caculate_exp();
                result = peek_operand(operands, top_operands);
                
                sprintf(result_string, "%d", result);
                lcd_puts(result_string);
                delay_ms(100);
                
                exp_size = 0;
                top_operators = -1;
                top_operands = -1;
                top_fix_oper = -1;
                
            }
            else if (Key == 12){
                lcd_putchar('/');
                exp[exp_size] = '/';
                exp_size++; 
                
            }
            else if (Key == 13){
                lcd_putchar('*');
                exp[exp_size] = '*';
                exp_size++;
                
            }
            else if (Key == 14){
                lcd_putchar('-');
                exp[exp_size] = '-';
                exp_size++;
                
            }
            else if (Key == 15){
                lcd_putchar('+');
                exp[exp_size] = '+';
                exp_size++;
            }
            
            delay_ms(30);
            
            while(scan_key() != 0xFF){
                delay_ms(20);
            } 
            
            
        }           
    }
}

void main( void){
    show_on_lcd();    
}