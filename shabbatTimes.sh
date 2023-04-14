#!/bin/sh

#City name.
city=""
#City type.
cityOPT=""
#Cities database url.
cityURL="https://raw.githubusercontent.com/ignaudioz/bash-knisatShabbat/main/etc/cities.txt"
# URL
url="https://calendar.2net.co.il/parasha.aspx"
#Config location
conf=$XDG_CONFIG_HOME/shabbatTimes/shabbatTimes.txt

while getopts hr option
do 
    case "${option}"
        in
        h)
        echo "Use -r in order to remove default city. e.g shabbatTimes.sh -r"
        exit
        ;;
        r)
         2>/dev/null rm -r $conf 
        ;;
    esac
done

checkCity () {
  #Curling cities database.
  curl --silent --output /tmp/shabbat/etc/cities.txt $cityURL --create-dirs
  # if the city is found in the database, change city value and end the function;
  # otherwise inform the user of the following and end the program.
  grep -q "$1" "/tmp/shabbat/etc/cities.txt" && city="$1" && return;
  echo "The city you entered cannot be located in the current database! try again!"
  printf "In order to see a list of all the countries check out the following link: \n $cityURL"
  exit
}

if [[ ! -e $conf ]]; then
  PS3="Select your option[1-6]:"
  select opt in Jerusalem Tel-aviv Haifa Be\'er-Sheva other quit; do
    case $opt in
      Jerusalem)
        city="ירושלים"
        cityOPT="Jerusalem"
        break
        ;;
      Tel-aviv)
        city="תל אביב"
        cityOPT="TelAviv"
        break
        ;;
      Haifa)
        city="חיפה"
        cityOPT="Haifa"
        break
       ;;
      Be\'er-Sheva)
        city="באר שבע"
        cityOPT="BeerSheva"
        break
        ;;
      other)
        read -p "Enter the city's name(hebrew):" temp
        checkCity "$temp"
        cityOPT="Other"
        break;
        ;;
      quit)
        break
        ;;
      *) 
        echo "Invalid city $REPLY"
        ;;
    esac
  done
  [ ! -d "$XDG_CONFIG_HOME/shabbatTimes" ] && mkdir "$XDG_CONFIG_HOME/shabbatTimes"
  echo "$city;$cityOPT" > $conf
else
  city=$(cat $conf | awk -F";" '{ print $1}') 
  cityOPT=$(cat $conf | awk -F";" '{ print $2}') 
fi



# curling shabbat times from a random site.
# if Shabbat file doesn't exists curl it.
# Appending city(hebrew)'s name to the url to get current shabbat times using
# curl's urlencode (--data-urlencode)
if [ ! -e "/tmp/shabbat/shabbat_$cityOPT.html" ]; then
  curl --silent --output /tmp/shabbat/shabbat_$cityOPT.html $url --data-urlencode "city=$city" --create-dirs
# if Shabbat file creation-date doesn't equal to current-date, update the file.
elif [ "$(2>/dev/null stat -c "%w" /tmp/shabbat/shabbat_$cityOPT.html | cut -c 9-10)" -ne "$(date +"%d")" ]; then
  curl --silent --output /tmp/shabbat/shabbat_$cityOPT.html $url --data-urlencode "city=$city" --create-dirs
fi

# parsing and grepping shabbat times.
hadlaka=$(cat /tmp/shabbat/shabbat_$cityOPT.html | pup 'span#content_hadlaka'| 2>/dev/null grep -Eo '[0-9]{1,3}\:[0-9]{1,3}')
yetzia=$(cat /tmp/shabbat/shabbat_$cityOPT.html | pup 'span#content_yetzia'| 2>/dev/null grep -Eo '[0-9]{1,3}\:[0-9]{1,3}')
rabeno=$(cat /tmp/shabbat/shabbat_$cityOPT.html | pup 'span#content_rabenutam'| 2>/dev/null grep -Eo '[0-9]{1,3}\:[0-9]{1,3}')

# colors.
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
NC='\033[0;0m' # no color/ remove color effect.
BIWhite='\033[1;97m' 

# final echo.
echo -e "${GREEN}Knisat shabbat:${BIWhite}$hadlaka"
echo -e "${RED}Yetziat shabbat:${BIWhite}$yetzia"
echo -e "${ORANGE}Rabenu-tam:${BIWhite}$rabeno${NC}"
