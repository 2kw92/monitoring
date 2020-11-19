--Устанваливаем заббикс
rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm
yum clean all
yum install zabbix-server-pgsql zabbix-agent -y
yum-config-manager --enable rhel-server-rhscl-7-rpms
Отредактируйте файл /etc/yum.repos.d/zabbix.repo и включите репозиторий zabbix-frontend.
yum install centos-release-scl
yum install zabbix-web-pgsql-scl zabbix-apache-conf-scl -y
--Устанваливаем бд
https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
yum -y install epel-release yum-utils
yum-config-manager --enable pgdg12
yum install postgresql12-server postgresql12 -y
--Далее создаем кластер
/usr/pgsql-12/bin/initdb -D /var/lib/pgsql/12/data/
--Запускаем бд
/usr/pgsql-12/bin/pg_ctl -D /var/lib/pgsql/12/data/ start
--Создаем юзера
createuser --pwprompt zabbix
--Создаем бд
createdb -O zabbix zabbix
--От рута

zcat /usr/share/doc/zabbix-server-pgsql*/create.sql.gz | sudo -u zabbix psql zabbix

systemctl restart zabbix-server zabbix-agent httpd rh-php72-php-fpm
systemctl enable zabbix-server zabbix-agent httpd rh-php72-php-fpm
