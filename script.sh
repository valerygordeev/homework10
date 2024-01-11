#!/bin/bash
  
#Указываем обрабатываемый временной диапазон
awk '{if (NR==1) print $4}' ./apache_logs.log | grep -Eo "[0-9]{2}\/[A-Z][a-z]{2}\/[0-9]{4}.*" > ./start_date
awk 'END { print substr($4,2,20) }' ./apache_logs.log | grep -Eo "[0-9]{2}\/[A-Z][a-z]{2}\/[0-9]{4}.*" > ./end_date

#start_date="17/May/2015:00:00:00" 
#end_date="19/May/2015:00:00:00" 
#awk -vDate="17/May/2015:00:00:00" -vDate2="19/May/2015:00:00:00" '{ if (substr($4,2,11) > Date && substr($4,2,11) < Date2) print $0 }' /var/log/apache_logs.log | uniq > tmp.log

#Список IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта
awk '{ cnt[$1]++ } END { for(x in cnt) print x, " -- ", cnt[x] }' ./apache_logs.log | sort -rnk3 > ./ListIPAdr.log
#Список запрашиваемых URL (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта
awk '{ cnt[$7]++ } END { for(x in cnt) print x, " -- ", cnt[x] }' ./apache_logs.log  | sort -rnk3 > ./ListIURL.log
#Ошибки веб-сервера/приложения c момента последнего запуска
awk '$9>399 { cnt[$9]++ } END { for(x in cnt) print x, " -- ", cnt[x] }' ./apache_logs.log | sort -rnk3 > ./ListErrors.log
#Список всех кодов HTTP ответа с указанием их кол-ва с момента последнего запуска скрипта
awk '{ cnt[$9]++ } END { for(x in cnt) print x, " -- ", cnt[x] }' ./apache_logs.log  | sort -rnk3 > ./ListHTTPCode.log

echo -e "Доброго дня\nВложения содержат файлы логов за период $(cat ./start_date) - $(cat ./end_date):\nСписок IP адресов (с наибольшим кол- вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта\nСписок запрашиваемых URL (с наибольшим кол-вом запросов) с     указанием кол-ва запросов c момента последнего запуска скрипта\nОшибки веб-сервера/приложения c момента последнего запуска\nСписок всех кодов   HTTP ответа с указанием их кол-ва с момента последнего запуска скрипта" | mutt -a /root/ListIPAdr.log -a /root/ListIURL.log -a /root/ListErrors.log -a /root/ListHTTPCode.log -s "Homework10" -- logs.report.send@yandex.ru

for FILE in *; do if [[ $FILE != "script.sh" ]]; then rm -rf $FILE; fi; done
