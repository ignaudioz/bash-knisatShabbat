#!/bin/sh


if [[ $(2>/dev/null stat -c "%w" shabbat.html | cut -c 9-10) != $(date +"%d") ]];
then
# curling shabbat times from a random site.
  curl -s "https://calendar.2net.co.il/parasha.aspx?hcity=%D7%91%D7%90%D7%A8%20%D7%A9%D7%91%D7%A2" > /tmp/shabbat/shabbat.html
fi

# parsing and grepping shabbat times.
hadlaka=$(cat /tmp/shabbat/shabbat.html | pup 'span#content_hadlaka'| 2>/dev/null grep -Eo '[0-9]{1,3}\:[0-9]{1,3}')
yetzia=$(cat /tmp/shabbat/shabbat.html | pup 'span#content_yetzia'| 2>/dev/null grep -Eo '[0-9]{1,3}\:[0-9]{1,3}')
rabeno=$(cat /tmp/shabbat/shabbat.html | pup 'span#content_rabenutam'| 2>/dev/null grep -Eo '[0-9]{1,3}\:[0-9]{1,3}')

# colors.
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
NC='\033[0;0m' # no color/ remove color effect.
BIWhite='\033[1;97m' 
# final echo.
echo -e "${GREEN}Knisat shabbat:${BIWhite}$hadlaka"
echo -e "${RED}Yetziat shabbat:${BIWhite}$yetzia"
echo -e "${ORANGE}Rabeno-tam:${BIWhite}$rabeno${NC}"
