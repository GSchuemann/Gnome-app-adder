#!/bin/bash
#Collecting infos via zenity

if ! NAME=$(zenity --entry --text "Name der im Menü angezeigt werden soll" --title "Bezeichnung"); then
  exit;
fi
echo "file name ok"
if ! EXEC=$(zenity --file-selection --title="Datei auswählen"); then
    exit;
fi
echo "exec ok"
if ! ICON=$(zenity --file-selection --title="Icon auswählen"); then
    exit;
fi
echo "icon ok"





#create desktop file and fill it up, open the software with MIME-TYPE
echo "creating .desktop file"
touch ~/$NAME.desktop 
echo "file created"
echo "[Desktop Entry]"                  >> ~/$NAME.desktop
echo "Name=$NAME"                       >> ~/$NAME.desktop
echo "Exec=xdg-open ${EXEC// /\\ }"     >> ~/$NAME.desktop
echo "Icon=${ICON// /\\ }"              >> ~/$NAME.desktop
echo "Terminal=false"                   >> ~/$NAME.desktop
echo "Type=Application"                 >> ~/$NAME.desktop
echo "file creation done"

#move file to ~/.local/share/applications and set the executable bit
chmod +x $HOME/$NAME.desktop
mv $HOME/$NAME.desktop $HOME/.local/share/applications
echo "file moved"

zenity --info --text "Alles erledigt!"

exit 1
