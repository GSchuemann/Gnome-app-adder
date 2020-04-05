#!/bin/bash
#Collecting infos via zenit
l
PROGRAM="xdg-open "
TERMINAL=false
if ! NAME=$(zenity --entry --text "Name der im Menü angezeigt werden soll" --title "Bezeichnung"); then
  exit;
fi
launch_application(){
					SLASHNUMBER=$(echo $EXEC  | grep -ho '/' | wc -w)
					((SLASHNUMBER++))
					PFADSLASH=""   #variablen initialisierung
    					PROGRAM="" && echo "found exec sh"
					APPNAME=./$(echo $EXEC | cut -d/ -f$(($SLASHNUMBER)))
					echo $APPNAME
					i=0
					((SLASHNUMBER--))
					while [ $i -lt $SLASHNUMBER ]
						 do   
							((i++))
							PFADSLASH=$PFADSLASH$i,
							echo $PFADSLASH
						 done
					PFADSLASH=$(echo $PFADSLASH | sed 's/,$//')
					echo $PFADSLASH
					PFAD=$(echo $EXEC | cut -d/ -f$PFADSLASH);
					echo $PFAD
					EXEC="/bin/bash -c \"cd $PFAD; $APPNAME\""			
					TERMINAL=true
					ICON=/usr/share/icons/Adwaita/scalable/mimetypes/application-x-executable-symbolic.svg
}
echo "file name ok"
if ! EXEC=$(zenity --file-selection --title="Datei auswählen"); then
    exit;
fi
echo "exec ok"
			MIME=$(xdg-mime query filetype "$EXEC")
			echo $MIME
				case "$MIME" in
					application/x-sharedlib)
					launch_application
					;;
					application/x-shellscript)
					launch_application
					;;
					audio/*) ICON=/usr/share/icons/Adwaita/scalable/mimetypes/audio-x-generic-symbolic.svg
					;;
					application/*) ICON=/usr/share/icons/Adwaita/scalable/mimetypes/application-x-executable-symbolic.svg
					;;
					image/*) ICON=/usr/share/icons/Adwaita/scalable/mimetypes/image-x-generic-symbolic.svg
					;;
					video/*) ICON=/usr/share/icons/Adwaita/scalable/mimetypes/video-x-generic-symbolic.svg
					;;

				esac			

ICON=$(zenity --file-selection --title="Icon auswählen")
	 then
		if [[ $ICON=="" ]]
			then
	 		echo "Kein Icon ausgewählt, default Skaliebares Icon wird benutzt (funktioniert nur unter GNOME!)"
		fi
#create desktop file and fill it up, open the software with MIME-TYPE
echo "creating .desktop file"
touch ~/$NAME.desktop 
echo "file created"
echo "[Desktop Entry]"                  >> ~/"$NAME".desktop
echo "Name=$NAME"                       >> ~/"$NAME".desktop
echo "Exec=$PROGRAM${EXEC}"      	>> ~/"$NAME".desktop
echo "Icon=${ICON// /\\ }"              >> ~/"$NAME".desktop
echo "Terminal=$TERMINAL"               >> ~/"$NAME".desktop
echo "Type=Application"                 >> ~/"$NAME".desktop
echo "file creation done"

#move file to ~/.local/share/applications and set the executable bit
chmod +x $HOME/"$NAME".desktop
mv $HOME/"$NAME".desktop $HOME/.local/share/applications
echo "file moved"

zenity --info --text "Alles erledigt!"

exit 1
