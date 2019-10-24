Nonterminals
document
values value
section section_contents chars
list list_items.

Terminals
int fraction char word section_start whitespace section_end new_line '[' ']'.

Rootsymbol document.

document -> values : '$1'.

section -> section_start section_end : {'$1', []}.
section -> section_start section_contents section_end : {'$1', '$2'}.

section_contents -> section : ['$1'].
section_contents -> section section_contents : ['$1'|'$2'].
section_contents -> chars section_contents : ['$1'|'$2'].
section_contents -> word : ['$1'].

values -> value : ['$1'].
values -> value values : ['$1'] ++ '$2'.

value -> int : {int, unwrap('$1')}.
value -> fraction : {fraction, unwrap('$1')}.
value -> word : {word, unwrap('$1')}.
value -> char : {char, unwrap('$1')}.
value -> whitespace : {whitespace, unwrap('$1')}.
value -> section_start : {section_start, unwrap('$1')}.
value -> section_end : {section_end, unwrap('$1')}.
value -> new_line : {new_line, unwrap('$1')}.
value -> section : '$1'.


chars -> char chars : ['$1'|'$2'].
chars -> char : '$1'.


Erlang code.

unwrap({_,_,V}) -> V.
