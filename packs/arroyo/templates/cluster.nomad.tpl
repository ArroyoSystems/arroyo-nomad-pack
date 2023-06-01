job "[[ .arroyo.job_name ]]" {
  [[ template "region" . ]]
  datacenters = [[ .arroyo.datacenters  | toJson ]]
  type = "service"

  group "compiler" {
    count = 1

    network {
      mode = "host"
      port "grpc" {}
      port "http" {}
    }

    service {
      name = "compiler-grpc"
      provider = "nomad"
      port = "grpc"
    }


    restart {
      attempts = 2
      interval = "30m"
      delay    = "15s"
      mode     = "fail"
    }

    task "server" {
      driver = "docker"

      env {
        S3_REGION = "[[ .arroyo.s3_region ]]"
        S3_BUCKET = "[[ .arroyo.s3_bucket ]]"

        [[- if not (eq .arroyo.aws_access_key_id nil)]]
        AWS_ACCESS_KEY_ID = "[[ .arroyo.aws_access_key_id ]]"
        [[- end ]]
        [[- if not (eq .arroyo.aws_access_secret_key nil)]]
        AWS_SECRET_ACCESS_KEY = "[[ .arroyo.aws_access_secret_key ]]"
        [[- end ]]
      }

      template {
        data = <<EOH
GRPC_PORT = "{{env "NOMAD_PORT_grpc"}}"
ADMIN_PORT = "{{env "NOMAD_PORT_http"}}"
EOH
        destination = "config.env"
        env = true
      }

      config {
        network_mode = "host"
        image = "ghcr.io/arroyosystems/arroyo-compiler:[[ .arroyo.image_tag ]]"
        ports = ["grpc", "http"]
      }

      resources {
        cpu    = [[ .arroyo.compiler_resources.cpu ]]
        memory = [[ .arroyo.compiler_resources.memory ]]
      }
    }
  }


  group "controller" {
    count = 1

    network {
      mode = "host"
      port "api-http" {}
      port "api-grpc" {}
      port "api-admin" {}

      port "controller-grpc" {}
      port "controller-admin" {}
    }

    service {
      name = "controller-grpc"
      provider = "nomad"
      port = "controller-grpc"
    }

    service {
      name = "api-http"
      provider = "nomad"
      port = "api-http"
    }

    service {
      name = "api-grpc"
      provider = "nomad"
      port = "api-grpc"
    }

    restart {
      attempts = 2
      interval = "30m"
      delay    = "15s"
      mode     = "fail"
    }

    task "server" {
      driver = "docker"

      env {
        DATABASE_NAME = "[[ .arroyo.postgres_db ]]"
        DATABASE_HOST = "[[ .arroyo.postgres_host ]]"
        DATABASE_PORT = "[[ .arroyo.postgres_port ]]"
        DATABASE_USER = "[[ .arroyo.postgres_user ]]"
        DATABASE_PASSWORD = "[[ .arroyo.postgres_password ]]"
        SCHEDULER = "nomad"

        S3_REGION = "[[ .arroyo.s3_region ]]"
        S3_BUCKET = "[[ .arroyo.s3_bucket ]]"

        PROM_ENDPOINT = "[[ .arroyo.prometheus_endpoint ]]"

        [[- if not (eq .arroyo.prometheus_auth "")]]
        PROM_AUTH = "[[ .arroyo.prometheus_auth ]]"
        [[- end ]]

        [[- if not (eq .arroyo.aws_access_key_id "")]]
        AWS_ACCESS_KEY_ID = "[[ .arroyo.aws_access_key_id ]]"
        [[- end ]]
        [[- if not (eq .arroyo.aws_access_secret_key "")]]
        AWS_SECRET_ACCESS_KEY = "[[ .arroyo.aws_access_secret_key ]]"
        [[- end ]]
      }

      template {
        data = <<EOH
API_ENDPOINT = "http://{{env "NOMAD_ADDR_api_grpc"}}"
CONTROLLER_ADDR = "http://{{env "NOMAD_ADDR_controller_grpc" }}"
API_HTTP_PORT = "{{env "NOMAD_PORT_api_http" }}"
API_GRPC_PORT = "{{env "NOMAD_PORT_api_grpc" }}"
API_ADMIN_PORT = "{{env "NOMAD_PORT_api_admin" }}"
CONTROLLER_GRPC_PORT = "{{env "NOMAD_PORT_controller_grpc" }}"
CONTROLLER_ADMIN_PORT = "{{env "NOMAD_PORT_controller_admin" }}"

{{ range nomadService "compiler-grpc" }}
REMOTE_COMPILER_ENDPOINT = "http://{{ .Address }}:{{ .Port }}"
{{ end }}
EOH
        destination = "config.env"
        env = true
      }

      config {
        network_mode = "host"
        image = "ghcr.io/arroyosystems/arroyo-services:[[ .arroyo.image_tag ]]"
        ports = ["api-http", "api-grpc", "api-admin", "controller-admin", "controller-grpc"]
      }

      resources {
        cpu    = [[ .arroyo.controller_resources.cpu ]]
        memory = [[ .arroyo.controller_resources.memory ]]
      }
    }
  }
}
