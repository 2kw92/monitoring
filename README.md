# monitoring

Для выполнения дз были проделаны следующие шаги:      
Установка репы zabbix:        
```rpm -Uvh https://repo.zabbix.com/zabbix/5.0/rhel/7/x86_64/zabbix-release-5.0-1.el7.noarch.rpm```      
     
Установка Zabbix сервера и агента:          
```yum install zabbix-server-pgsql zabbix-agent```      
      
Установка Zabbix веб-интерфейса:       
```yum-config-manager --enable rhel-server-rhscl-7-rpms```      
      
Редактируем файл /etc/yum.repos.d/zabbix.repo и включаем репозиторий zabbix-frontend       
```
[zabbix-frontend]
...
enabled=1
...
```      
       
Устанавливаем пакеты веб-интерфейса:       
```yum install centos-release-scl```
        
```yum install zabbix-web-pgsql-scl zabbix-apache-conf-scl -y```
      
Далее нам необходимо развернуть БД. Я выбрал postgres:        
```
https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
yum -y install epel-release yum-utils
yum-config-manager --enable pgdg12
yum install postgresql12-server postgresql12 -y
```      
      
Далее создаем кластер от имени postgres проделываем:       
```/usr/pgsql-12/bin/initdb -D /var/lib/pgsql/12/data/```       
      
Запускаем бд:        
```/usr/pgsql-12/bin/pg_ctl -D /var/lib/pgsql/12/data/ start```             
      
Создаем юзера:      
```createuser --pwprompt zabbix```      
      
Создаем бд:       
```createdb -O zabbix zabbix```      
      
Далее от имени root импортируем начальную схему и данные:     
```zcat /usr/share/doc/zabbix-server-pgsql*/create.sql.gz | sudo -u zabbix psql zabbix```      
      
Настриваем бд. Для этого редактируем файл /etc/zabbix/zabbix_server.conf       
```DBPassword=zabbix```      
      
Настраиваем PHP для веб-интерфейса.Файл /etc/opt/rh/rh-php72/php-fpm.d/zabbix.conf, раскомментируем        
строку и укажем свой часовой пояс:       
```php_value[date.timezone] = Europe/Moscow```      
      
Далее заходим в веб-интерфейс. Для виртуалки приложенной к дз это:      
```http://192.168.11.101/zabbix/```
          
И производим настройки. После этого настраиваем дашборды в разделе screen.      