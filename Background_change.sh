#!/bin/bash

PID=$(pgrep gnome-session)
export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$PID/environ|cut -d= -f2-)

base_path="$HOME/bin/Background_change"
sh "$base_path/Generate_list.sh" > "$base_path/log"

max_pic=$(wc -l < "$base_path/list.list")
#line_nr=$(($(date +%s) % $max_pic))
line_nr=$(($RANDOM % $max_pic))
pic_url=$(sed -n "$line_nr,$line_nr p" "$base_path/list.list") 
curr_pic=$(gsettings get org.gnome.desktop.background picture-uri)
if [ $curr_pic = "'file://$base_path/Background1.jpg'" ]; then
	curr_pic="$base_path/Background2.jpg"
else
	curr_pic="$base_path/Background1.jpg"
fi
echo "Downloading..." >> "$base_path/log"
wget -q -t 50 -w 1 --output-document="$curr_pic" $pic_url
gsettings set org.gnome.desktop.background picture-uri "file://$curr_pic"
echo "Done!" >> "$base_path/log"	
	
#wget -t 50 -w 1 --output-document="$base_path/Background1.jpg" $pic_url
#mv -f "$base_path/tmp.jpg" "$base_path/Background.jpg"

#gsettings set org.gnome.desktop.background picture-options "center"
#gsettings set org.gnome.desktop.background picture-uri "file://$base_path/Background.jpg"
#gsettings set org.gnome.desktop.background picture-options "zoom"
exit 0