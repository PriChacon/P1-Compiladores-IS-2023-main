//------------------paquetes importaciones
package src;
import java_cup.runtime.*;

%%

%public
%class Analizador
%implements sym

%unicode

%line
%column

%cup
%cupdebug

%{
  StringBuilder string = new StringBuilder();

  private Symbol symbol(int type) {
    return new Symbol(type, yyline+1, yycolumn+1);
  }

  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline+1, yycolumn+1, value);
  }

  %eofval{
    System.err.println("Error.");
  %eofval}

%}


//--------Expresiones Regulares
LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]

WhiteSpace = {LineTerminator} | [ \t\f]

Comment = {EndOfLineComment}  
EndOfLineComment = "@" {InputCharacter}* {LineTerminator}? 

numero = 0 | [1-9][0-9]*
identificador = [a-zA-Z_] [a-zA-Z0-9_]*
float    = [0-9]+ \. [0-9]*
simbolo = "!" | "@" | "#"  | "%" | "^" | "&" | "*" 
    | "(" | ")" | "-" | "_" | "+" | "=" | "[" | "]" | "{" 
    | "}" | ";" | ":" | "\'" | '\"' | "," | "." | "<" | ">" 
    | "?" | "/" | "|" | "\\"


string = \"(\\.|[^\"])*\"
char = \'[a-zA-Z]\' |\'[0-9]\'|\'{simbolo}\'
//------estados
%state COMMENTB
%%


<YYINITIAL>{
    "!"             {return symbol(REXC); }
    //"@"             {return symbol(ARROBA); }
    "#"             {return symbol(OR); }
    "$"             {return symbol(DOLLAR); }
    //"%"             {return symbol(PORCIENTO); }
    "^"             {return symbol(AND); }
    //"&"             {return symbol(AMPER); }
    "*"             {return symbol(MULT); }
    "("             {return symbol(LPAREN); }
    ")"             {return symbol(RPAREN); }
    "-"             {return symbol(MENOS); }
    //"_"             {return symbol(GUIONBAJO); }
    "+"             {return symbol(MAS); }
    "="             {return symbol(ASIG); }
    "["             {return symbol(LBRACKET); }
    "]"             {return symbol(RBRACKET); }
    "{"             {return symbol(LBRACE); }
    "}"             {return symbol(RBRACE); }
    //";"             {return symbol(SEMICOLON); }
    //":"             {return symbol(DOSPUNTOS); }
    //"\'"            {return symbol(COMILLASIM); }
    //"\""            {return symbol(COMILLADOB); }
    ","             {return symbol(COMA); }
    //"."             {return symbol(PUNTO); }
    "<"             {return symbol(MENOR); }
    ">"             {return symbol(MAYOR); }
    //"?"             {return symbol(RINTERRO); }
    "/"             {return symbol(DIV); }
    //"|"             {return symbol(PIPE); }
    //"\\"            {return symbol(SLASH); }
    "<="            {return symbol(MENORIGUAL); }
    ">="            {return symbol(MAYORIGUAL); }
    "=="            {return symbol(EQUAL); }
    "!="            {return symbol(NOTEQUAL); }
    "**"            {return symbol(POTENCIA); }
    "~"             {return symbol(MODULO); }
    "++"            {return symbol(INCREMENTO); }
    "--"            {return symbol(DECREMENTO); }
    "not"           {return symbol(NOT); }
    "int"           {return symbol(INT); }
    "float"         {return symbol(FLOAT); }
    "string"        {return symbol(STRING); }
    "char"          {return symbol(CHAR); }
    "array"         {return symbol(ARRAY); }
    "bool"          {return symbol(BOOL); }
    "main"          {return symbol(MAIN); }
    "true"          {return symbol(LITERAL_BOOL, true); }
    "false"         {return symbol(LITERAL_BOOL, false); }
    "if"            {return symbol(IF);  }
    "elif"          {return symbol(ELIF); }
    "else"          {return symbol(ELSE); }
    "while"         {return symbol(WHILE); }
    "do"            {return symbol(DO); }
    "for"           {return symbol(FOR); }
    "return"        {return symbol(RETURN); }
    "break"         {return symbol(BREAK); }
    "leer"          {return symbol(LEER); }
    "escribir"      {return symbol(ESCRIBIR); }

    "/_"            { yybegin(COMMENTB); }

    {numero}            {return symbol(LITERAL_INT, new Integer(Integer.parseInt(yytext()))); }
    {float}             {return symbol(LITERAL_FLOAT, new Float(yytext().substring(0,yylength()-1)));  }

    {identificador}     { return symbol(IDENTIFIER, yytext()); }
    {string}            {return symbol(LITERAL_STRING); }
    {char}              {return symbol(LITERAL_CHAR); }

    {Comment}           { /* ignore */ }

    {WhiteSpace}        { /* ignore */ }
}

<COMMENTB>{
  [^_]*      { }
  "_"+[^_/]* { }
  "_"+"/"    { yybegin(YYINITIAL); }
  .          { }
}


[^]                              { throw new RuntimeException("Illegal character \""+yytext()+
                                                              "\" at line "+yyline+", column "+yycolumn); }
<<EOF>>                          { return symbol(EOF); }