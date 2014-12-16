create_container_html(){
filename=$1
path=$2
echo "<html>" > $path
echo "<head>" >> $path
echo "<title>" >> $path
echo "Server mappings info" >> $path
echo "</title></head>" >> $path
echo "<body>" >> $path
echo "<table widht='100%' border='2'>" >> $path
echo "<th>" >> $path
echo "<tr>" >> $path
echo "<td> Server name </td><td> SSH Port </td><td> VNC Port </td><td> Web Server Port </td></tr></th>" >> $path
while read -r line
do
	echo "<tr>" >> $path
	echo "<td>" >> $path
	name=$line
	echo "$name" | cut -d " " -f1 >> $path
	echo "</td>" >> $path
	echo "<td>" >> $path
        echo "$name" | cut -d " " -f2 >> $path
        echo "</td>" >> $path
	echo "<td>" >> $path
        echo "$name" | cut -d " " -f3 >> $path
        echo "</td>" >> $path
	echo "<td>" >> $path
        echo "$name" | cut -d " " -f4 >> $path
        echo "</td>" >> $path
	echo "</tr>" >> $path
done < "$filename"
echo "</table>" >> $path
echo "</body>" >> $path
echo "</html>" >> $path
}

