#!/bin/bash
echo "Predavani instrukci programu ulozto-downloader..."
echo "Po automatickem zavreni tohoto okna je stahovani dokonceno."
echo
cd ~/.config/stahovac
sleep 2s
source ~/.config/stahovac/directory.txt
source ~/.config/stahovac/captcha.txt
source ~/.config/stahovac/parts.txt
source ~/.config/stahovac/url.txt
ulozto-downloader $captcha --parts $parts --output $dir "$url"
