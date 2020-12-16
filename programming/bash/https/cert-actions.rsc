/certificate remove [ /certificate find ] 
/certificate import passphrase=""
/certificate set [ find where private-key ] name=https-ssl
/ip service set www-ssl certificate=https-ssl disabled=no

