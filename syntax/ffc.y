/* -*- mode: bison; -*- */

%{

#include <iostream>

%}

%union {
    Program program;
}

%type <program> program

%%

program : definitions { @$ = @1; }
;

%%
