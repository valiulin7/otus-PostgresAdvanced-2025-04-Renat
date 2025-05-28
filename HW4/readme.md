# Домашнее задание "Высокая доступность: развертывание Patroni
"

### Цель:
- развернуть отказоустойчивый кластер PostgreSQL с Patroni;



* Создайте 3 виртуальные машины для etcd и 3 виртуальные машины для Patroni.

Так как создаю виртуалки на ноутбуке то в целях экономии развернул etcd на тех серверах что и PostgreSQL:
![0bdbe04950d0b8e41e814ca53b03244c.png](./0bdbe04950d0b8e41e814ca53b03244c.png)

![20d888aac1088d4e4636dfc4efbff004.png](./20d888aac1088d4e4636dfc4efbff004.png)

* Разверните HA-кластер PostgreSQL с использованием Patroni.

![8c3b6ce1016d4aa8f5710834e2c6cb89.png](./8c3b6ce1016d4aa8f5710834e2c6cb89.png)

![0c6a021782499c5f5ebfcbb426a6acff.png](./0c6a021782499c5f5ebfcbb426a6acff.png)

![6fc77fefe19dae69aa0393e81ed61668.png](./6fc77fefe19dae69aa0393e81ed61668.png)


* Настройте HAProxy для балансировки нагрузки.

![27678f8cf5ca7fd5e37a68313ecf9743.png](./27678f8cf5ca7fd5e37a68313ecf9743.png)

![5f70b189c8b2ee38328af13517c7ce05.png](./5f70b189c8b2ee38328af13517c7ce05.png)

* Проверьте отказоустойчивость кластера, имитируя сбой на одном из узлов.
![d7ddcba3a2e7630266d3add0908682dc.png](./d7ddcba3a2e7630266d3add0908682dc.png)

* Дополнительно: Настройте бэкапы с использованием WAL-G или pg_probackup.

![dd21a8aa26480a15f2b584e1064ed543.png](./dd21a8aa26480a15f2b584e1064ed543.png)

![35bf94ef8550fdbff731fcbbc733885e.png](./35bf94ef8550fdbff731fcbbc733885e.png)

![9b1f6e534908e8b490b89994cda58ce3.png](./9b1f6e534908e8b490b89994cda58ce3.png)

![83ff39a798d7a855089c15dfe2cb58ef.png](./83ff39a798d7a855089c15dfe2cb58ef.png)




