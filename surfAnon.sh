#!/bin/bash
#process to check whether browseris running,returning an exit status
check_process() {
  echo "$ts: checking $1"
  [ "$1" = "" ]  && return 0
  [ `pgrep -n $1` ] && return 1 || return 0
}
#receive input from user on preffered browser
read -p "Enter preffered browser name: " p
 
#array to receive varied inputs

firefox=(firefox mozilla firefox-esr Firefox Mozilla)
brave=(brave brave-browser Brave Brave-browser Brave-Browser)
chromium=(chromium chromium-browser Chromium Chromium-browser Chromium-Browser)

a=0
while [ $a -lt 5 ];do
  if [ $p = ${firefox[$a]} ]; then 
    browser=firefox-esr
    elif [ $p =  ${brave[$a]} ];then
    browser=brave-browser
    elif [ $p =  ${chromium[$a]} ];then 
    browser=chromium
  fi
    a=`expr $a + 1`
done
    BrowserPATH=$(whereis $browser|awk '{printf "%s\n",$2}')
if [ ! -f ${BrowserPATH}  ]; then
    read -p "Apparently your preferred browser isn't installed. Install? :" userAnswer
  if [ $userAnswer == "y" ]; then
    for package in $browser tor proxychains ;do 
      dpkg -s "$package" > /dev/null 2>&1 && echo "$package is installed" ||
        if ping -c 5 -q -W 4 google.com > /dev/null 2>&1 ;then
          echo "Downloading Packages" && if ["$EUID" -ne 0 ] ;then 
            sudo apt-get install $package -y;
          else
            apt-get install $package -y
        fi
          exit
      else
      echo "My guy, hauna net"
      fi
    done
      else
        echo "just use tor-browser"
  fi
  
fi

# timestamp
ts=`date +%T`
echo "$ts: begin checking at $BrowserPATH.."
check_process "$browser"
[ $? -eq 0 ] && echo "$ts: not running, restarting..."  && service tor start && `proxychains $BrowserPATH https://www.duckduckgo.com -i > /dev/null 2>&1` && service tor stop
