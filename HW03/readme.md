# Домашнее задание "Настройка дисков для Постгреса"

### Цель:
- создавать дополнительный диск для уже существующей виртуальной машины, размечать его и делать на нем файловую систему
- переносить содержимое базы данных PostgreSQL на дополнительный диск
- переносить содержимое БД PostgreSQL между виртуальными машинами


* создайте виртуальную машину c Ubuntu 20.04 LTS (bionic) в GCE типа e2-medium в default VPC в любом регионе и зоне, например us-central1-a или ЯО/VirtualBox

  
![3785eeb06bb7fefaeb3504448bcc07a3.png](./3785eeb06bb7fefaeb3504448bcc07a3.png)

* поставьте на нее PostgreSQL 15 через sudo apt
    ![90ec8c778f880220596874d36882c22d.png](./90ec8c778f880220596874d36882c22d.png)

* проверьте что кластер запущен через sudo -u postgres pg_lsclusters

    ![9128a0bb7792bfd16c69136d0415c883.png](./9128a0bb7792bfd16c69136d0415c883.png)

* зайдите из под пользователя postgres в psql и сделайте произвольную таблицу с произвольным содержимым
  postgres=# create table test(c1 text);
  postgres=# insert into test values('1');
  \q

	![864da5c5e0d3764b71febef44ebc0ef7.png](./864da5c5e0d3764b71febef44ebc0ef7.png)
  
* остановите postgres например через sudo -u postgres pg_ctlcluster 15 main stop
    ![83ec81944b0dec08e2ada5ba61e72f38.png](./83ec81944b0dec08e2ada5ba61e72f38.png)

* создайте новый standard persistent диск GKE через Compute Engine -> Disks в том же регионе и зоне что GCE инстанс размером например 10GB - или аналог в другом облаке/виртуализации

	![a11d626f1d97a99b6ca32ce5cc082db3.png](./a11d626f1d97a99b6ca32ce5cc082db3.png)


* добавьте свеже-созданный диск к виртуальной машине - надо зайти в режим ее редактирования и дальше выбрать пункт attach existing disk
    ![716a130e8c3288f544e4096ec02d997e.png](./716a130e8c3288f544e4096ec02d997e.png)
  
* проинициализируйте диск согласно инструкции и подмонтировать файловую систему, только не забывайте менять имя диска на актуальное, в вашем случае это скорее всего будет /dev/sdb - [https://www.digitalocean.com/community/tutorials/how-to-partition-and-format-storage-devices-in-linux](https://www.digitalocean.com/community/tutorials/how-to-partition-and-format-storage-devices-in-linux "https://www.digitalocean.com/community/tutorials/how-to-partition-and-format-storage-devices-in-linux")

	![f41046d08c84cf86765a3d631d272f20.png](./f41046d08c84cf86765a3d631d272f20.png)
    ![e588869b9112756e0abbfedef2b8c6fb.png](./e588869b9112756e0abbfedef2b8c6fb.png)
    ![793ef47e686d73472fb8a23e5b07acce.png](./793ef47e686d73472fb8a23e5b07acce.png)
    ![2c72527a2d98eb40d9e3880b9a1584f9.png](./2c72527a2d98eb40d9e3880b9a1584f9.png)
* перезагрузите инстанс и убедитесь, что диск остается примонтированным (если не так смотрим в сторону fstab)
    ![6c0363fe0633da61bf5df00eb65548e3.png](./6c0363fe0633da61bf5df00eb65548e3.png)

* сделайте пользователя postgres владельцем /mnt/data - chown -R postgres:postgres /mnt/data/
* перенесите содержимое /var/lib/postgresql/15 в /mnt/data - mv /var/lib/postgresql/15 /mnt/data
* попытайтесь запустить кластер - sudo -u postgres pg_ctlcluster 15 main start
* напишите получилось или нет и почему
    ![f2455f1b7c24da6f45b51621131c606f.png](./f2455f1b7c24da6f45b51621131c606f.png)
**не получилось тк директорию переместили**

  
* задание: найти конфигурационный параметр в файлах раположенных в /etc/postgresql/14/main который надо поменять и поменяйте его

    ![64735da29a89d19487dc869eb8e11eeb.png](./64735da29a89d19487dc869eb8e11eeb.png)

  
* напишите что и почему поменяли
**поменял параметр data_directory = '/mnt/data/15/main' в файле /etc/postgresql/15/main/postgresql.conf тк в нем указывается путь к данным**

  
* попытайтесь запустить кластер - sudo -u postgres pg_ctlcluster 15 main start
    ![f71107c53fe32dcb99aa699bd6aefb2d.png](./f71107c53fe32dcb99aa699bd6aefb2d.png)

* напишите получилось или нет и почему
**получилось но лучше запустить как службу:**
	![f6acf0c76f2cfa3e593850b6ba3debf2.png](./f6acf0c76f2cfa3e593850b6ba3debf2.png)


* зайдите через через psql и проверьте содержимое ранее созданной таблицы
	![a8fd8a71c4cceedcf08d225f38e5c596.png](./a8fd8a71c4cceedcf08d225f38e5c596.png)

* задание со звездочкой \*: не удаляя существующий GCE инстанс/ЯО сделайте новый, поставьте на его PostgreSQL, удалите файлы с данными из /var/lib/postgresql, перемонтируйте внешний диск который сделали ранее от первой виртуальной машины ко второй и запустите PostgreSQL на второй машине так чтобы он работал с данными на внешнем диске, расскажите как вы это сделали и что в итоге получилось.

    ![d4eae54a7188e118172501da81233eab.png](./d4eae54a7188e118172501da81233eab.png)
**остановил сервис postgresql на сервере-источнике**

	![fc7cc52cb7212c773b00a39865ee9d03.png](./fc7cc52cb7212c773b00a39865ee9d03.png)
**добавил новый сервер**

	![2299a9381031992e7c5a6499b2530b2f.png](./2299a9381031992e7c5a6499b2530b2f.png)
**Установил PostgreSQL нужной версии**

	![d33d72e660e3ffc74aa271ff0d63ca69.png](./d33d72e660e3ffc74aa271ff0d63ca69.png)
**Проверил что сервис PostgreSQL запущен и нормально работает**


	![16a63162ba3e0c6e218b8e673cc4013d.png](./16a63162ba3e0c6e218b8e673cc4013d.png)
**Остановил сервис PostgreSQL и очистил его директорию с данными**


	![e2864171dcc0c2513356589dd573c2d5.png](./e2864171dcc0c2513356589dd573c2d5.png)
**Подключил диск к новому серверу**


	![abd7ac7a5267b1812112b21cdc6eda6e.png](./abd7ac7a5267b1812112b21cdc6eda6e.png)
**Примонтировал новый диск и изменил директорию данных на новый диск**

    
    ![809dd4909473442ddf096937cb58b6f4.png](./809dd4909473442ddf096937cb58b6f4.png)
**Запустил сервис PostgreSQL**


    ![f1964f9e48ccff6b39d2e1c5454035b2.png](./f1964f9e48ccff6b39d2e1c5454035b2.png)
  

**Проверил что PostgreSQL подцепил данные с старого сервера**
