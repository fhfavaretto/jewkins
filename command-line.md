 
 executar como console:

 COMPILAR ARQUIVO DENTRO DA PASTA 
C:\TOTVS12\Protheus\Protheus\bin\appserver_desenv\appserver.exe -compile -files=C:\TOTVS12\Fontes -includes=C:\TOTVS12\Protheus\Protheus\includes -src=C:\FONTES\envmail.prw\cmdline -env=DESENV  -outreport=C:\TOTVS12\Log_compile

Gera Patch do fonte em questão
C:\TOTVS12\Protheus\Protheus\bin\appserver_desenv\appserver.exe -compile -genpatch -files=C:\TOTVS12\Fontes\envmail.prw -env=DESENV -patchtype=ptm -outgenpatch=C:\TOTVS12\Log_compile

