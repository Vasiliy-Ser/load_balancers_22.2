resource "yandex_compute_instance_group" "lamp_group" {
  name               = var.lamp-group
  service_account_id = var.account_id

  allocation_policy {
    zones           = [var.default_zone]
  }

  instance_template {
    platform_id     = var.platform_id_name
    resources {
      core_fraction = var.vm_params.core_fraction
      cores         = var.vm_params.cpu
      memory        = var.vm_params.ram
    }

    boot_disk {
      initialize_params {
        size = var.vm_params.disk_size
        image_id = var.vm_params.image_id
      }
    }

    network_interface {
      subnet_ids        = [yandex_vpc_subnet.public.id]
      security_group_ids = [yandex_vpc_security_group.nat-instance-sg.id]
    }

    scheduling_policy {
      preemptible =  var.vm_params.preemptible
    }

    metadata = {
      user-data          = data.template_file.cloudinit.rendered 
      serial-port-enable = 1
    }

  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  deploy_policy {
    max_unavailable = 2
    max_expansion   = 1
    max_creating    = 1
    max_deleting    = 2
  }

  health_check {
    tcp_options {
      port = 80
    }
  }

  load_balancer {
    target_group_name        = "target-group"
    target_group_description = "Целевая группа Network Load Balancer"
  }

}

data "template_file" "cloudinit" {
  template = file("/home/vm30/homework/22.2/terraform_2/cloud-init.yml")

  vars = {
    vms_ssh_root_key = join("\n", var.vms_ssh_root_key)
  }

}