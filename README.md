# Домашнее задание к занятию 22.2 «Вычислительные мощности. Балансировщики нагрузки» -  Падеев Василий  

### Подготовка к выполнению задания

1. Домашнее задание состоит из обязательной части, которую нужно выполнить на провайдере Yandex Cloud, и дополнительной части в AWS (выполняется по желанию).  
2. Все домашние задания в блоке 15 связаны друг с другом и в конце представляют пример законченной инфраструктуры.  
3. Все задания нужно выполнить с помощью Terraform. Результатом выполненного домашнего задания будет код в репозитории.  
4. Перед началом работы настройте доступ к облачным ресурсам из Terraform, используя материалы прошлых лекций и домашних заданий.  

---
## Задание 1. Yandex Cloud 

**Что нужно сделать**

### 1. Создать бакет Object Storage и разместить в нём файл с картинкой:  

 - Создать бакет в Object Storage с произвольным именем (например, _имя_студента_дата_).  
 - Положить в бакет файл с картинкой.  
 - Сделать файл доступным из интернета.  

 ### Решение:

В файле конфигурации [providers.tf](https://github.com/Vasiliy-Ser/load_balancers_22.2/blob/15ed581606149332da769c3fd54b0d77f7bbe037/src/providers.tf) сделал описание создания бакета, загрузку картинки с публичным доступом.  
 
### 2. Создать группу ВМ в public подсети фиксированного размера с шаблоном LAMP и веб-страницей, содержащей ссылку на картинку из бакета:   

 - Создать Instance Group с тремя ВМ и шаблоном LAMP. Для LAMP рекомендуется использовать `image_id = fd827b91d99psvq5fjit`.  
 - Для создания стартовой веб-страницы рекомендуется использовать раздел `user_data` в [meta_data](https://cloud.yandex.ru/docs/compute/concepts/vm-metadata).  
 - Разместить в стартовой веб-странице шаблонной ВМ ссылку на картинку из бакета.  
 - Настроить проверку состояния ВМ.  

  ### Решение:

  Создал группу из 3 ВМ без nat, описание в файле [main.tf](https://github.com/Vasiliy-Ser/load_balancers_22.2/blob/15ed581606149332da769c3fd54b0d77f7bbe037/src/main.tf), с параметрами:  
  - максимальным количеством инстансов которые могут быть одновременно недоступны = 2  
  - количеством одновременно создаваемых ресурсов = 1  
  - количеством ресурсов, которые можно удалить одновременно = 2  
  Входящий трафик разрешен по 22, 80, 443 портам, описание в [security.tf](https://github.com/Vasiliy-Ser/load_balancers_22.2/blob/15ed581606149332da769c3fd54b0d77f7bbe037/src/security.tf)  
  Команды создания стартовой веб-страницы указаны в [cloud-init.yml](https://github.com/Vasiliy-Ser/load_balancers_22.2/blob/15ed581606149332da769c3fd54b0d77f7bbe037/src/cloud-init.yml)   
   
### 3. Подключить группу к сетевому балансировщику:  

 - Создать сетевой балансировщик.  
 - Проверить работоспособность, удалив одну или несколько ВМ.  

  ### Решение:  

Создание сетевого балансировщика описал в [balancer.tf](https://github.com/Vasiliy-Ser/load_balancers_22.2/blob/15ed581606149332da769c3fd54b0d77f7bbe037/src/balancer.tf)  

![answer1](https://github.com/Vasiliy-Ser/load_balancers_22.2/blob/15ed581606149332da769c3fd54b0d77f7bbe037/png/1.png)   
![answer2](https://github.com/Vasiliy-Ser/load_balancers_22.2/blob/15ed581606149332da769c3fd54b0d77f7bbe037/png/2.png)   
![answer3](https://github.com/Vasiliy-Ser/load_balancers_22.2/blob/15ed581606149332da769c3fd54b0d77f7bbe037/png/3.png)   
Удалим 1 ВМ и проверим доступность:  
![answer4](https://github.com/Vasiliy-Ser/load_balancers_22.2/blob/15ed581606149332da769c3fd54b0d77f7bbe037/png/4.png)   
![answer5](https://github.com/Vasiliy-Ser/load_balancers_22.2/blob/15ed581606149332da769c3fd54b0d77f7bbe037/png/5.png)   
После удаления 3 ВМ сразу начинает создаваться новая ВМ:
![answer6](https://github.com/Vasiliy-Ser/load_balancers_22.2/blob/15ed581606149332da769c3fd54b0d77f7bbe037/png/6.png)   
По прошествии времени создаются все 3 ВМ   
![answer7](https://github.com/Vasiliy-Ser/load_balancers_22.2/blob/15ed581606149332da769c3fd54b0d77f7bbe037/png/7.png)
![answer8](https://github.com/Vasiliy-Ser/load_balancers_22.2/blob/15ed581606149332da769c3fd54b0d77f7bbe037/png/8.png)    
При остановке 2 ВМ, одна из них сразу повторно запускается:  
![answer9](https://github.com/Vasiliy-Ser/load_balancers_22.2/blob/15ed581606149332da769c3fd54b0d77f7bbe037/png/9.png)     

### 4. (дополнительно)* Создать Application Load Balancer с использованием Instance group и проверкой состояния.  

### Полезные документы:  

- [Compute instance group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance_group).  
- [Network Load Balancer](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/lb_network_load_balancer).  
- [Группа ВМ с сетевым балансировщиком](https://cloud.yandex.ru/docs/compute/operations/instance-groups/create-with-balancer).  

---
## Задание 2*. AWS (задание со звёздочкой)  

Это необязательное задание. Его выполнение не влияет на получение зачёта по домашней работе.

**Что нужно сделать**

Используя конфигурации, выполненные в домашнем задании из предыдущего занятия, добавить к Production like сети Autoscaling group из трёх EC2-инстансов с  автоматической установкой веб-сервера в private домен.  

1. Создать бакет S3 и разместить в нём файл с картинкой:  

 - Создать бакет в S3 с произвольным именем (например, _имя_студента_дата_).  
 - Положить в бакет файл с картинкой.  
 - Сделать доступным из интернета.  
2. Сделать Launch configurations с использованием bootstrap-скрипта с созданием веб-страницы, на которой будет ссылка на картинку в S3.   
3. Загрузить три ЕС2-инстанса и настроить LB с помощью Autoscaling Group.  

Resource Terraform:  

- [S3 bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)  
- [Launch Template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template).  
- [Autoscaling group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group).  
- [Launch configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration).  

Пример bootstrap-скрипта:  

```
#!/bin/bash
yum install httpd -y
service httpd start
chkconfig httpd on
cd /var/www/html
echo "<html><h1>My cool web-server</h1></html>" > index.html
```
### Правила приёма работы  

Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.  
Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.  
Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.  
