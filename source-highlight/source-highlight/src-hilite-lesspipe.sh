#! /bin/bash

for source in "$@"; do
    case $source in
	*ChangeLog|*changelog) 
        source-highlight --failsafe -f esc --lang-def=changelog.lang --style-file=esc.style --line-number -i "$source" ;;
	*Makefile|*makefile) 
        source-highlight --failsafe -f esc --lang-def=makefile.lang --style-file=esc.style --line-number -i "$source" ;;
        *) source-highlight --failsafe --infer-lang -f esc --style-file=esc.style --line-number -i "$source" ;;
    esac
done
