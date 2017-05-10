/* -*- mode: bison -*- */

/*
 *  The scanner definition for FFC.
 */

%{

#include <string>
#include "ffc.yy.hpp"

using namespace yy;

using std::shared_ptr;
using std::make_shared;
using std::string;

ASTParser::semantic_type yylval;

using namespace std;

string string_buf;
string operator_buf;

int curr_lineno = 1;
extern int verbose_flag;
extern "C" int yylex();

#include "tokens.hpp"
YYSTYPE yylval;

extern "C" int optind;

void handle_flags(int argc, char *argv[]);

FILE *fin;

#undef YY_INPUT
#define YY_INPUT(buf,result,max_size) \
    if ((result = fread((char *)buf, 1, max_size, fin)) < 0) { \
        YY_FATAL_ERROR("read() failed in lexer"); \
    }

extern void dump_token(int lineno, int token, YYSTYPE yylval);

int main(int argc, char** argv) {
    int token;

    while (optind < argc) {
        fin = fopen(argv[optind], "r");
        if (fin == NULL) {
            cerr << "Could not open input file " << argv[optind] << endl;
            exit(1);
        }

        curr_lineno = 1;

        //
        // Scan and print all tokens.
        //
        cout << "#name \"" << argv[optind] << "\"" << endl;
        while ((token = yylex()) != 0) {
            dump_token(curr_lineno, token, yylval);
        }
        fclose(fin);
        optind++;
    }
    exit(0);
}

using tok = ASTParser::token;
%}

%option noyywrap
%x IN_STRING

INT [1-9][0-9]*
FLOAT [0-9]+\.[0-9]+
ID [A-z_][A-z0-9_]*
OP [!~@#$%&^*-+\\/<>][!~@#$%&^*-+\\/<>=]*
%%

fnc        return tok::Fnc;
extern     return tok::Extern;
operator   return tok::OperatorKw;
include    return tok::Include;
type       return tok::Type;
ref        return tok::Ref;
val        return tok::Val;
implement  return tok::Implement;
for        return tok::For;
destructor return tok::Destructor;
if         return tok::If;
while      return tok::While;
else       return tok::Else;
ret        return tok::Ret;
generic    return tok::Generic;

{OP} {
    yylval.build(yytext);
    return tok::Operator;
}

= return Eq;
"(" return '(';
")" return ')';
";" return ';';
"," return ',';
"{" return '{';
"}" return '}';

<INITIAL>\" {
    BEGIN(IN_STRING);
}

<IN_STRING>\" {
    yylval.build(string_buf);
    BEGIN(INITIAL);
    return tok::Str;
 }

<IN_STRING>. string_buf += *yytext;

true {
    yylval.build(true);
    return tok::Bool;
}

false {
    yylval.build(false);
    return tok::Bool;
}

{ID} {
    yylval.build(yytext);
    return tok::Ident;
}

{FLOAT} {
    yylval.build(std::stof(yytext));
    return tok::Float;
}

{INT} {
    yylval.build(std::stoi(yytext));
    return tok::Int;
}


[ \t\f\r\v]+
\n curr_lineno++;

%%
