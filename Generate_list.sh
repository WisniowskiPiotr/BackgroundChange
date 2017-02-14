#!/bin/bash
base_path="$HOME/bin/Background_change"
keywords_file="$base_path/keywords.conf"
tmp_files="$base_path/tmp"
list="$base_path/list.list"

time_diffrence=$((7*24*60*60))

if [ ! -f $keywords_file ]; then
    echo "Keyword file non-existens: $keywords_file"
    exit 1
fi

if [ -f $list ] && [ $(stat -c %Y $list) -ge $(stat -c %Y $keywords_file) ] && [ $(($(date +%s)-$(stat -c %Y $list))) -le $time_diffrence ]; then 
	echo "no need to update list. Continuing..."
	exit 0
fi

rm -f $list
mkdir $tmp_files
while IFS='' read -r line; do
	line=$(echo $line | sed 's/ /+/g' ) 
	page_search="https://wall.alphacoders.com/search.php?search=$line"
	wget -nv --output-document="$tmp_files/$line.tmp" $page_search  
	grep -i '<img src="https://images[0-9]*.alphacoders.com' "$tmp_files/$line.tmp" | tr '"' '\n' | grep 'https' | sed 's/thumb-[0-9]*-//g' >> $list
	
done < $keywords_file
rm -f -r $tmp_files

exit 0
