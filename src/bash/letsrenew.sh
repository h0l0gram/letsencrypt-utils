#!/bin/bash

if [[ $# == 0 ]]
then 
printf "Usage: letsrenew.sh [-f <certFile>] [option]...\n\n"
printf "  certfile: certificate file that shall be analyzed\n\n"
printf "Options:\n"
printf "  -i <days>: if certificate rest validity is lower than <days> a info message is printed\n"
printf "  -w <days>: if certificate rest validity is lower than <days> a warning message is printed\n"
printf "  -r <days>: if certificate rest validity is lower than <days> 0 is returned 1 otherwise\n"
printf "\n\nExamples:\n"
printf "  letsrenew.sh -f letsrenew.com.pem -r 10 && <letsencrypt-update.sh>\n"
printf "  letsrenew.sh -f letsrenew.com.pem -r 10 && /opt/letsencrypt/letsencrypt-auto certonly --webroot -w /var/www/letsrenew.com/ -d letsrenew.com -d www.letsrenew.com --renew-by-default\n"

exit 1
fi

while [[ $# > 1 ]]
do
key="$1"

case $key in
    -f)
    certFile="$2"
    shift # past argument
    ;;
    -r|--searchpath)
    certRenewalThreshold="$2"
    shift # past argument
    ;;
    -i)
    certInfoThreshold="$2"
    shift # past argument
    ;;
    -w)
    certWarningThreshold="$2"
    shift # past argument
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done


if [ ! -f "$certFile" ]
then
  printf "%-60s %-30s\n" "$certFile" "does not exist"
  exit 1
fi

certSubject=$(openssl x509 -in "$certFile" -noout -subject | cut -d= -f 3) 
certEnd=$(date --date="$(openssl x509 -in "$certFile" -enddate -noout | cut -d= -f 2)")
ms=$(($(date -ud "$certEnd" +%s)-$(date -u +%s)))
daysLeft=$(($ms/60/60/24))

if [ -n "$certWarningThreshold" ] && [ $daysLeft -lt $certWarningThreshold ]
then
 echo "WARNING: $certFile $certSubject: $daysLeft days left!"
fi

if [ -n "$certInfoThreshold" ] && [ $daysLeft -lt $certInfoThreshold ]
then
 printf "%-60s %-30s %-s\n" "$certFile" "$certSubject:" "$daysLeft days left."
fi

if [ -n "$certRenewalThreshold" ] && [ $daysLeft -lt $certRenewalThreshold ]
then
 echo "$certFile $certSubject: $daysLeft days left. Renewal required."
 exit 0
fi

exit 1
