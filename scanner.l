%{
#include "parser.tab.h"
%}

ID      [a-zA-Z][a-zA-Z0-9]*
OP      [+\-*/%]
EQ      =
SEMI    ;
WS      [ \t]+

%%

{ID}        { yylval.str = strdup(yytext); return ID; }
{OP}        { return OP; }
{EQ}        { return EQ; }
{SEMI}      { return SEMI; }
"("         { return '('; }
")"         { return ')'; }
{WS}        ;
\n          ;
.           { return yytext[0]; }

%%
