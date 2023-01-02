#!/bin/bash

if [[ $# -lt 1 ]]
then
printf "Creates a directory for each domain found in the certificates of the certs archive and creates a symlink for the latest pem file (cert, fullchain, chain, privkey). SAN certificates (aka multi-domains) are explicitly supported.\n";
printf "This script fixes https://github.com/letsencrypt/letsencrypt/issues/1260\n\n"
printf "Usage: letslink.sh <certs-archive> <symlink-location>\n\n"
printf "  certs-archive: path where the certificates can be found (e.g. /etc/letsencrypt/archive)\n\n"
printf "  symlink-location: path where the simlinks shall be created for each domain\n"
printf "\n\nExamples:\n  letslink.sh /etc/letsencrypt/archive /etc/letsencrypt/latest\n\n"

exit 1
fi

archive=$1
link=$2

certs=$(find $archive -name "cert*" -type f -printf "%-.22T+ %p\n" | sort | cut -f 2- -d ' ')

mkdir -p $link

for cert in $certs
do
    domains=$(openssl x509 -in $cert -text -noout | grep DNS | sed -e "s/DNS://g" -e "s/ //g")
    #printf "$cert\n"
    certNo=$(echo "$cert" | grep -o "[0-9]\{1,\}.pem")
    OIFS=$IFS
    IFS=','
    certFolder=$(dirname $cert)

    for domain in $domains
    do
        domain=${domain/\*/_}
	linkDomain="$link/$domain"
	#printf "mkdir: $linkDomain\n"
        mkdir -p $linkDomain
	#printf "ln -sfn $certFolder/cert$certNo $linkDomain/cert.pem\n"
	ln -sfn $certFolder/cert$certNo $linkDomain/cert.pem
	ln -sfn $certFolder/chain$certNo $linkDomain/chain.pem
	ln -sfn $certFolder/fullchain$certNo $linkDomain/fullchain.pem
	ln -sfn $certFolder/privkey$certNo $linkDomain/privkey.pem
    done
    IFS=$OIFS
done
