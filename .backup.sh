#!/bin/bash
# Simple backup for dirs
# with ssmtp mails
# Enjoy!

TO="YO MAIL"
FROM="YOU FROM MAIL"
DATE=`date +%Y.%m.%d`
HOST=$(hostname -s)
SUBJ="Backup $HOST $DATE"

#DIRS
BACKUP="/etc /var/www"

#BACKUP DIR
DIR="/home/.backup"
if ! [[ -d $DIR ]]; then
 mkdir $DIR
 chmod a+r $DIR
fi

find $DIR/ -name $HOST"-*" -mtime +6 -exec rm -f {} \;
FILE=$DIR/$HOST-$DATE".tar.bz2"
MAIL=$DIR/"~"$DATE".mail"

echo "To: "$TO >> $MAIL
echo "From: "$FROM >> $MAIL
echo "Subject: "$SUBJ >> $MAIL
echo "" >> $MAIL
echo "$DATE" >> $MAIL
echo "Hellow "$TO"!" >> $MAIL
echo "" >> $MAIL

tar -cjf $FILE $BACKUP 
if [ -f $FILE ]; then
  chgrp sudo $FILE
  chmod u=rw,g=rw $FILE  
  echo "Backup ["$BACKUP"] is ok!" >> $MAIL
else
  echo "Backup ["$BACKUP"] error!" >> $MAIL
fi

echo "File: $FILE" >> $MAIL
echo "" >> $MAIL
echo "Good Bye!" >> $MAIL

/usr/sbin/ssmtp $TO < $MAIL
rm -f $MAIL

exit 0