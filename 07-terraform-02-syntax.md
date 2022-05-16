
# Домашнее задание к занятию "7.2. Облачные провайдеры и синтаксис Terraform."

<details>
<summary>Раскрыть</summary>

> Зачастую разбираться в новых инструментах гораздо интересней понимая то, как они работают изнутри.
Поэтому в рамках первого *необязательного* задания предлагается завести свою учетную запись в AWS (Amazon Web Services) или Yandex.Cloud.
Идеально будет познакомится с обоими облаками, потому что они отличаются.

</details>

## Задача 1 (вариант с AWS). Регистрация в aws и знакомство с основами (необязательно, но крайне желательно).

<details>
<summary>Раскрыть условие задачи</summary>

> Остальные задания можно будет выполнять и без этого аккаунта, но с ним можно будет увидеть полный цикл процессов.
>
> AWS предоставляет достаточно много бесплатных ресурсов в первых год после регистрации, подробно описано [здесь](https://aws.amazon.com/free/).
> 1. Создайте аккаут aws.
> 1. Установите c aws-cli https://aws.amazon.com/cli/.
> 1. Выполните первичную настройку aws-sli https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html.
> 1. Создайте IAM политику для терраформа c правами
     >     * AmazonEC2FullAccess
>     * AmazonS3FullAccess
>     * AmazonDynamoDBFullAccess
>     * AmazonRDSFullAccess
>     * CloudWatchFullAccess
>     * IAMFullAccess
> 1. Добавьте переменные окружения
     >     ```
>     export AWS_ACCESS_KEY_ID=(your access key id)
>     export AWS_SECRET_ACCESS_KEY=(your secret access key)
>     ```
> 1. Создайте, остановите и удалите ec2 инстанс (любой с пометкой `free tier`) через веб интерфейс.
>
> В виде результата задания приложите вывод команды `aws configure list`.

</details>

`Недоступна новая регистрация аккаунтов из РФ`

## Задача 1 (Вариант с Yandex.Cloud). Регистрация в ЯО и знакомство с основами (необязательно, но крайне желательно).

<details>
<summary>Раскрыть условие задачи</summary>

> 1. Подробная инструкция на русском языке содержится [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).
> 2. Обратите внимание на период бесплатного использования после регистрации аккаунта.
> 3. Используйте раздел "Подготовьте облако к работе" для регистрации аккаунта. Далее раздел "Настройте провайдер" для подготовки базового терраформ конфига.
> 4. Воспользуйтесь [инструкцией](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs) на сайте терраформа, что бы не указывать авторизационный токен в коде, а терраформ провайдер брал его из переменных окружений.

</details>

```shell
❯ yc config list
service-account-key:
  id: ajepfi3s98mfrgbkiqfb
  service_account_id: ajet5nq9jdt72jbvne8l
  created_at: "2022-04-24T11:53:42.889396274Z"
  key_algorithm: RSA_2048
  public_key: |
    -----BEGIN PUBLIC KEY-----
    СЕКРЕТНЫЙ ПУБЛИЧНЫЙ КЛЮЧ СЕРВИСНОГО АККАУНТА
    -----END PUBLIC KEY-----
  private_key: |
    -----BEGIN PRIVATE KEY-----
    СЕКРЕТНЫЙ ПРИВАТНЫЙ КЛЮЧ СЕРВИСНОГО АККАУНТА
    -----END PRIVATE KEY-----
cloud-id: b1gstis6eh7ondu9q0io
folder-id: b1guugseh3jmtmgukcs5
```

## Задача 2. Созданием aws ec2 или yandex_compute_instance через терраформ.

<details>
<summary>Раскрыть условие задачи</summary>

> 1. В каталоге `terraform` вашего основного репозитория, который был создан в начале курсе, создайте файл `main.tf` и `versions.tf`.
> 2. Зарегистрируйте провайдер
     >    1. для [aws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs). В файл `main.tf` добавьте блок `provider`, а в `versions.tf` блок `terraform` с вложенным блоком `required_providers`. Укажите любой выбранный вами регион внутри блока `provider`.
>    2. либо для [yandex.cloud](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs). Подробную инструкцию можно найти [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).
> 3. Внимание! В гит репозиторий нельзя пушить ваши личные ключи доступа к аккаунту. Поэтому в предыдущем задании мы указывали их в виде переменных окружения.
> 4. В файле `main.tf` воспользуйтесь блоком `data "aws_ami` для поиска ami образа последнего Ubuntu.
> 5. В файле `main.tf` создайте рессурс
     >    1. либо [ec2 instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance).
             >    Постарайтесь указать как можно больше параметров для его определения. Минимальный набор параметров указан в первом блоке `Example Usage`, но желательно, указать большее количество параметров.
>    2. либо [yandex_compute_image](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_image).
> 6. Также в случае использования aws:
     >    1. Добавьте data-блоки `aws_caller_identity` и `aws_region`.
>    2. В файл `outputs.tf` поместить блоки `output` с данными об используемых в данный момент:
        >        * AWS account ID,
>        * AWS user ID,
>        * AWS регион, который используется в данный момент,
>        * Приватный IP ec2 инстансы,
>        * Идентификатор подсети в которой создан инстанс.
> 7. Если вы выполнили первый пункт, то добейтесь того, что бы команда `terraform plan` выполнялась без ошибок.
>
>
> В качестве результата задания предоставьте:
> 1. Ответ на вопрос: при помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami?
> 1. Ссылку на репозиторий с исходной конфигурацией терраформа.

</details> 

### Если вы выполнили первый пункт, то добейтесь того, что бы команда `terraform plan` выполнялась без ошибок.

Аналога `aws_caller_identity` у провайдера Yandex нет, поэтому только адрес, ID подсети и зона.
```log
❯ terraform plan
var.OAUTH
  Enter a value: 123


Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.service01 will be created
  + resource "yandex_compute_instance" "service01" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "service01.netology.cloud"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa keykeykey= dmitriynenashev@MacBook-Pro-Dmitriy-2.local
            EOT
        }
      + name                      = "service01"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8ecai75lv8ce93p2ls"
              + name        = "root-service01"
              + size        = 20
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 20
          + cores         = 2
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = true
        }
    }

  # yandex_vpc_network.default will be created
  + resource "yandex_vpc_network" "default" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "net"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.default will be created
  + resource "yandex_vpc_subnet" "default" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.101.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 3 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + external_ip_address_service01_yandex_cloud = (known after apply)
  + internal_ip_address_service01_yandex_cloud = (known after apply)

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply"
now.
```

### При помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami?

Packer

### Ссылку на репозиторий с исходной конфигурацией терраформа.

[Cсылка на репозиторий](./terraform)