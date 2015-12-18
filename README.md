# letsencrypt

Utils for managing letsencrypt certificates and its infrastructure

- **letsrenew.sh**: Bash Shell script which reads the validity of a x509 certificate and if lower than a given threshold prints a message info/warning or returns boolean true for further processing (=renewal).



## Setup

- Clone the repo to your server. e.g `/opt/letsrenew`.
- Create a cron job that runs `letsrenew.sh` at a certain interval or start from bash

## Usage

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
  