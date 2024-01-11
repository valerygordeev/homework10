# homework10
```
1. Устанавливаем необходимое ПО для отправки эл. сообщений.  	  
   Для этого в Vagrantfile в provision "shell" указываем необходимые команды:
      yum install mutt -y 
      И копируем файлы лога apache_logs.log и скрипта script.sh в директории /var/log/ и /root/ соответственно.
2. В том же разделе Vagrantfile'а создаем файл блокировки и даем ему разрешения:
      touch /var/lock/logs.lock  
      chmod 664 /var/lock/logs.lock  
3. В там же создаем задание в Cron и устанвливаем разрешения на файл задания:
      echo "00 * * * * /usr/bin/flock -w 0 /var/lock/logs.lock -c sh /root/script.sh" > /var/spool/cron/root
      chmod 600 /var/spool/cron/root  
4. В скрипте script.sh сохраняем в файлах start_date и end_date временной диапазон из apache_logs.log, предоставленного преподавателем:
      #Указываем обрабатываемый временной диапазон
      awk '{if (NR==1) print $4}' /var/log/apache_logs.log | grep -Eo "[0-9]{2}\/[A-Z][a-z]{2}\/[0-9]{4}.*" > start_date
      awk 'END { print substr($4,2,20) }' /var/log/apache_logs.log | grep -Eo "[0-9]{2}\/[A-Z][a-z]{2}\/[0-9]{4}.*" > end_date
5. Создаем выборки согласно ДЗ:
     #Список IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта
     awk '{ cnt[$1]++ } END { for(x in cnt) print x, " -- ", cnt[x] }' /var/log/apache_logs.log | sort -rnk3 > ListIPAdr.log
     #Список запрашиваемых URL (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта
     awk '{ cnt[$7]++ } END { for(x in cnt) print x, " -- ", cnt[x] }' /var/log/apache_logs.log  | sort -rnk3 > ListIURL.log
     #Ошибки веб-сервера/приложения c момента последнего запуска
     awk '$9>399 { cnt[$9]++ } END { for(x in cnt) print x, " -- ", cnt[x] }' /var/log/apache_logs.log | sort -rnk3 > ListErrors.log
     #Список всех кодов HTTP ответа с указанием их кол-ва с момента последнего запуска скрипта
     awk '{ cnt[$9]++ } END { for(x in cnt) print x, " -- ", cnt[x] }' /var/log/apache_logs.log  | sort -rnk3 > ListHTTPCode.log
   Сохраним данные в отдельных лог-файлах.
6. Отправим созданные вышего логи по эл.почте с помощью почтового клиента Mutt
 echo -e "Доброго дня\nВложения содержат файлы логов по ДЗ:\nСписок IP адресов (с наибольшим кол- вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта\nСписок запрашиваемых URL (с наибольшим кол-вом запросов) с     указанием кол-ва запросов c момента последнего запуска скрипта\nОшибки веб-сервера/приложения c момента последнего запуска\nСписок всех кодов   HTTP ответа с указанием их кол-ва с момента последнего запуска скрипта" | mutt -a ./ListIPAdr.log -a ./ListIURL.log -a ./ListErrors.log -a ./ListHTTPCode.log -s "Homework10" -- logs.report.send@yandex.ru
```
