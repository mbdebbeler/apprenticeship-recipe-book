Definitions.

FRACTION = [1-9][0-9]*\/[1-9][0-9]*
INT        = [0-9]+
SECTION_START = SERVESServes|INGREDIENTS|INSTRUCTIONS|WHY|BEFORE
SECTION_END  = (\n\n)
UPCASE_WORD = (<=\s|)[A-Z]+(=\s|)
WORD = (<=\s|)[a-zA-Z]+(=\s|)
BRACKET = [\[\]]
CHARACTER = [\"-\/\@\#\:\;\,\.\'{}\(\)\[\]&\|\*\!]
WHITESPACE = [\s\t\r]
NEW_LINE  = [\n]

Rules.

{INT}         : {token, {int,  TokenLine, list_to_integer(TokenChars)}}.
{FRACTION}         : {token, {fraction,  TokenLine, TokenChars}}.
{SECTION_START}         : {token, {section_start,  TokenLine, TokenChars}}.
{SECTION_END}         : {token, {section_end,  TokenLine, TokenChars}}.
{UPCASE_WORD} : {token, {upcase_word, TokenLine, TokenChars}}.
{WORD} : {token, {word, TokenLine, TokenChars}}.
{CHARACTER} : {token, {char, TokenLine, TokenChars}}.
{NEW_LINE}  : {token, {new_line, TokenLine, TokenChars}}.
{WHITESPACE} : {token, {whitespace, TokenLine, TokenChars}}.
{BRACKET} : {token, {list_to_atom(TokenChars), TokenLine, TokenChars} }.

Erlang code.
