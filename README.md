 Knisat Shabbat Script.
-------------------------
a random bash script to easily get the shabbat entry&amp;leaving info.

סקריפט רנדומלי על מנת לקבל את הכניסה והיציאה של השבת (כולל רבנו-תם) בצורה נוחה ויעילה, דרך שורת הפקודות.
***Shabbat times are calculated by Hazon-Shmaim method!
זמני כניסת השבת מחושבים על-פי שיטת החזון שמים!***
Configuration and running
-------------------------
Dependencies: [`pup`](https://github.com/ericchiang/pup "Pup's Repository"), `grep`, `stat`, `curl`, `cut`. Most probably are already present in your distribution.

You may place the script in your path, make the script executable (via `chmod +x`) and you are ready to go.


Basic Usage
-------------------------
First time running, asking ur city and saving it as prefrence.
```bash
~ λ shabbatTimes
1) Jerusalem	3) Haifa	5) other
2) Tel-aviv	4) Be\'er-Sheva	6) quit
Select your option[1-6]:1
Knisat shabbat:18:36
Yetziat shabbat:19:50
Rabenu-tam:20:25
````


Examples
-------------------------
#### Get Shabbat times of a city using arguments. (city name must be in hebrew)
```bash
~ λ shabbatTimes "אור יהודה"
Knisat shabbat:18:52
Yetziat shabbat:19:52
Rabenu-tam:20:26
```

#### Rest prefrence.
```bash
~ λ shabbatTimes -r
1) Jerusalem	3) Haifa	5) other
2) Tel-aviv	4) Be\'er-Sheva	6) quit
Select your option[1-6]:
```

Info
-----
* fetch site that was used - "calendar.2net.co.il"

***
