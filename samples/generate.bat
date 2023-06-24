set SCRIPT_ROOT=%~dp0


asciidoctor-pdf --theme %SCRIPT_ROOT%stylesheets/requirement-theme.yml -r asciidoctor-diagram -r %SCRIPT_ROOT%..\lib\asciidoctor-requirements.rb -a toc -a linkcss -a stylesheet=./stylesheets/requirement-style.css  %SCRIPT_ROOT%sample.adoc --trace
::asciidoctor -r asciidoctor-diagram -r %SCRIPT_ROOT%..\lib\asciidoctor-requirements.rb -a toc -a stylesdir=E:\asciidoctor-requirements\samples\stylesheets -a stylesheet=requirement-style.css -a copycss %SCRIPT_ROOT%sample.adoc --trace
::asciidoctor-pdf -r %SCRIPT_ROOT%..\lib\asciidoctor-requirements.rb %SCRIPT_ROOT%sample.adoc --trace
