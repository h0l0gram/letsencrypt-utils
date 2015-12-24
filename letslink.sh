#!/bin/bash

if [[ $# -lt 1 ]]
then
printf "Creates a directory structure for all domains found in the certificates in the archive. SAN certificates (aka multi-domains) are explicitly supported.\n";
printf "This script fixes https://github.com/letsencrypt/letsencrypt/issues/1260\n\n"
printf "Usage: letslink.sh <certs-archive> <symlink-location>\n\n"
printf "  certs-archive: path where the certificates can be found (e.g. /etc/letsencrypt/archive)\n\n"
printf "  symlink-location: path where the simlinks shall be created for each domain\n"
printf "\n\nExamples:\n  letslink.sh /etc/letsencrypt/archive /etc/letsencrypt/latest\n\n"

exit 1
fi

archive=$1
link=$2

certs=$(find $archive -name cert* -type f -printf "%-.22T+ %p\n" | sort | cut -f 2- -d ' ')

mkdir -p $link

for cert in $certs
do
    domains=$(openssl x509 -in $cert -text -noout | grep DNS | sed -e "s/DNS://g" -e "s/ //g")
    OIFS=$IFS
    IFS=','
    certFolder=$(dirname $cert)

    for domain in $domains
    do
        ln -sfn $certFolder $link/$domain
        #printf "$domain --> $certFolder\n"
    done
    IFS=$OIFS
done
