sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install -y bind9 bind9utils bind9-doc
sudo cat <<EOF >/etc/bind/named.conf.local
zone "rpz.local" {
  type master;
  file "/etc/bind/zones/db.rpz.local";
  allow-query { localhost; };
};
EOF
sudo cat <<EOF >/etc/bind/named.conf.options
acl "clouddns" {
  35.199.192.0/19;
};

options {
  directory "/var/cache/bind/";

  recursion yes;
  allow-recursion { clouddns; };
  listen-on { 10.0.0.2; };
  allow-transfer { none; };
  querylog yes;
  dnssec-validation no;
  
  response-policy { zone "rpz.local"; };

  forwarders {
    1.1.1.1;
  };
};
EOF
sudo mkdir -p /etc/bind/zones
sudo cat <<EOF >/etc/bind/zones/db.rpz.local
\$TTL    86400
@       IN      SOA     localhost. root.localhost. (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                          86400 )       ; Negative Cache TTL
;
@       IN      NS      localhost.
;
; Records to filter
*.example.com             CNAME         .
example.com               CNAME         .
*.instagram.com           CNAME         .
instagram.com             CNAME         .
*.facebook.com            A             10.0.0.2
facebook.com              A             10.0.0.2
EOF
sudo named-checkconf
sudo systemctl restart bind9
sudo apt-get install nginx -y
sudo cat <<EOF >/var/www/html/index.nginx-debian.html
<html>
  <head>
    <title>BLOCKED BY DNS FILTER</title>
  </head>
  <body>
    <h1>THIS IS BLOCKED BY CUSTOM DNS FILTER</h1>
  </body>
</html>
EOF
