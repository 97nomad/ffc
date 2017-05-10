/* -*- mode: bison -*- */

%{
#include <string>
#include <memory>
%}

%require "2.3"
%debug
%defines
%skeleton "lalr1.cc"
%define "parser_class_name" { ASTParser }
%define api.value.type variant

%locations

%error-verbose

%token  EOL "end of line"
%token  <std::string> Str Ident
%token  <bool> Bool
%token  <float> Float
%token  <int> Int

%token Fnc Extern Operator Include Type Ref Val
                  Implement For Destructor If Else While Ret Generic

%start top_level

%%

top_level : Fnc
