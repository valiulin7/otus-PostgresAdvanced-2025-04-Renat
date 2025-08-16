# Домашнее задание "Кластеры высокой доступности"

### Цель: научиться развертывать кластер PostgreSQL с высокой доступностью в облаке или локальной среде, используя подходящие инструменты и технологии;



##### Описание/Пошаговая инструкция выполнения домашнего задания:

🔧 **Вариант 1. Кластер своими руками**

Разверните высокодоступный кластер PostgreSQL вручную. Возможные технологии:

* Patroni + Etcd + HAProxy
* Pacemaker/Corosync/DRBD (для продвинутых)

Среда развертывания:

Можно использовать виртуальные машины в локальной сети (например, через VirtualBox, Proxmox)

![32a30f82ae9fc281b504e27916707f76.png](./32a30f82ae9fc281b504e27916707f76.png)

Три сервера объединенны в кластер Patroni

![b50dcf03e38be7314649885bd646f21d.png](./b50dcf03e38be7314649885bd646f21d.png)


![c9d810ec2e1cdc38877166a57cd4a72e.png](./c9d810ec2e1cdc38877166a57cd4a72e.png)

![97c7261fee153c45cbd6eeb745509861.png](./97c7261fee153c45cbd6eeb745509861.png)

![5055237a5e5ed3a26873ca38055ed6a8.png](./5055237a5e5ed3a26873ca38055ed6a8.png)

![ffd9b0d6f52bad787a556b99208a16e3.png](./ffd9b0d6f52bad787a556b99208a16e3.png)

Первоначально Keepalived указывает на HAProxy:

![21e3366316bd1c1481501d64aaa79d6d.png](./21e3366316bd1c1481501d64aaa79d6d.png)

При отказе узла pg01 происходит автоматический failover:

![d7722e600d587d30c5be573ccbfbe073.png](./d7722e600d587d30c5be573ccbfbe073.png)

![11c8c70a0f87baffb7dedb3eeacfff53.png](./11c8c70a0f87baffb7dedb3eeacfff53.png)

![c60631178d19974a27091c3126421eb4.png](./c60631178d19974a27091c3126421eb4.png)

Симитируем отказ всего кластера patroni:

![09e4b30f7de79fe01178d71a7aeb8bb8.png](./09e4b30f7de79fe01178d71a7aeb8bb8.png)
StandBy сервер переходит в режим master

![50e021f9b02ae8ae541aaff48ec813a7.png](./50e021f9b02ae8ae541aaff48ec813a7.png)

и VIP переходит на StandBy сервер

![e07fce18652dc7ef08849aab3d878a7d.png](./e07fce18652dc7ef08849aab3d878a7d.png)








