# letsencrypt-utils

Utils for managing letsencrypt certificates and its infrastructure

- **letsrenew.sh**: Bash Shell script which reads the remaining validity of a x509 certificate and if lower than a given threshold prints a message info/warning or returns boolean true for further processing (=renewal).
- **letslink.sh**: Bash Shell script which creates a directory structure (simlinks) for each domain found in the certificates of the certs archive. SAN certificates (aka multi-domains) are explicitly supported.

## Install

- Clone the repo to your server. e.g `/opt/letsrenew-utils`.

## letsrenew.sh
Bash Shell script which reads the remaining validity of a x509 certificate and if lower than a given threshold prints a message info/warning or returns boolean true for further processing (=renewal).

### Setup
- Create a cron job that runs `letsrenew.sh` at a certain interval or start from bash (see examples)

### Usage

    letsrenew.sh [-f <certFile>] [option]...
      certfile: certificate file that shall be analyzed
    Options:
      -i <days>: if certificate rest validity is lower than <days> a info message is printed
      -w <days>: if certificate rest validity is lower than <days> a warning message is printed
      -r <days>: if certificate rest validity is lower than <days> 0 is returned 1 otherwise
  
### Examples
    letsrenew.sh -f letsrenew.com.pem -i 1000
    letsrenew.sh -f letsrenew.com.pem -r 10 && <letsencrypt-update.sh>
    letsrenew.sh -f letsrenew.com.pem -r 10 && /opt/letsencrypt/letsencrypt-auto certonly --webroot -w /var/www/letsrenew.com/ -d letsrenew.com -d www.letsrenew.com --renew-by-default

## letslink.sh
Creates a directory structure (simlinks) for each domain found in the certificates of the certs archive. SAN certificates (aka multi-domains) are explicitly supported.
Quickfix for https://github.com/letsencrypt/letsencrypt/issues/1260

### Setup
- After calling letsrenew.sh, call the letslink.sh with the required parameters. This way, the "latest" folder is always up-to-date.
- If you have a letsencrypt-update.sh add `letslink.sh /etc/letsencrypt/archive /etc/letsencrypt/latest` at the end, before reloading apache/ngix etc.

### Examples
    letslink.sh /etc/letsencrypt/archive /etc/letsencrypt/latest
    

## Requirements
- Shell (bash compatible)
- OpenSSL (to read the existing certificates)

## Comments, Improvements, Ideas
Always welcome! Just drop a comment or raise an issue on https://github.com/h0l0gram/letsencrypt-utils. Thanks
