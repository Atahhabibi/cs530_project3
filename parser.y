%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

// Declare Flex buffer handling
typedef struct yy_buffer_state *YY_BUFFER_STATE;
extern YY_BUFFER_STATE yy_scan_string(const char *str);
extern void yy_delete_buffer(YY_BUFFER_STATE buffer);

extern int yylex(void);
int yyparse(void);
void yyerror(const char *s);
extern char* yytext;

bool parse_success = false;
char error_message[256] = "invalid statement";
%}

%union {
    char* str;
}

%token <str> ID
%token OP EQ SEMI
%left '+' '-' 
%left '*' '/' '%'

%%

program:
    | program statement
    ;

statement:
    assignment   { parse_success = true; }
    | expression { parse_success = true; }
    ;

assignment:
    ID EQ expression SEMI
    ;

expression:
    ID
    | expression OP expression
    | '(' expression ')'
    ;

%%

void yyerror(const char *s) {
    snprintf(error_message, sizeof(error_message), "invalid expression");
    parse_success = false;
}

int main(void) {
    FILE *fp = fopen("scanme.txt", "r");
    if (!fp) {
        perror("scanme.txt");
        return 1;
    }

    char line[1024];
    while (fgets(line, sizeof(line), fp)) {
        line[strcspn(line, "\n")] = 0;

        parse_success = false;
        strcpy(error_message, "invalid statement");

        YY_BUFFER_STATE buffer = yy_scan_string(line);
        yyparse();
        yy_delete_buffer(buffer);

        if (parse_success)
            printf("%-50s -- valid\n", line);
        else
            printf("%-50s -- invalid: %s\n", line, error_message);
    }

    fclose(fp);
    return 0;
}
