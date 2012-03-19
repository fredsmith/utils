#! /bin/bash
# get your bitly api key from https://bitly.com/a/account.  Fill the API key in below along with your username
BITLY_APIKEY="yourapikey"
BITLY_USERNAME="yourbitlyusername"
# comment out the below, unless you also store your api key and username in an include file.
. ~/Documents/passwords.txt

while read URL; do
   SHORTURL=$(curl -s "http://api.bitly.com/v3/shorten?login=$BITLY_USERNAME&apiKey=$BITLY_APIKEY&format=txt&longUrl=$URL");
   TITLE=$(curl -s "https://api-ssl.bitly.com/v3/info?shortUrl=$SHORTURL&login=$BITLY_USERNAME&apiKey=$BITLY_APIKEY" |  sed -e 's/.*title": //' -e 's/, "short_url.*//');
   if [ "$TITLE" = "null" ]; then
   #   TITLE="Shortened:";
      TITLE=$(curl -s "$URL" | grep -i "<title>" | cut -f2 -d">" | sed 's|<title>||' | sed 's|</title||');
   fi

   echo $TITLE [$SHORTURL]   
done

