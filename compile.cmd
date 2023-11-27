flex L.l
bison -d Y.y
gcc lex.yy.c y.tab.c -o translator
translator.exe