# Arroyo Nomad Pack

This pack deploys an [Arroyo](https://github.com/ArroyoSystems/arroyo) cluster.

See the [docs](http://doc.arroyo.dev/deployment/nomad) for details on how to use this pack.

## Variables

The pack is configurable via a number of variables. At minimum, you must configure the postgres database and s3 bucket
to use.

- `job_name` (string) - The name of Nomad job for the Arroyo cluster
- `region` (string) - The region where jobs will be deployed
- `datacenters` (list(string)) - A list of datacenters in the region which are eligible for task placement
- `prometheus_endpoint` (string) - Endpoint for prometheus with protocol, required for job metrics (for example
  `http://prometheus.service:9090`)
- `prometheus_auth` (string) - Basic authentication for prometheus if required
- `postgres_host` (string) - Host of your postgres database
- `postgres_port` (number) - Port of your postgres database
- `postgres_db` (string) - Name of your postgres database
- `postgres_user` (string) - User of your postgres database
- `postgres_password` (string) - Password of your postgres database
- `s3_region` (string) - S3 bucket to store checkpoints and pipeline artifacts
- `s3_bucket` (string) - S3 bucket to store checkpoints and pipeline artifacts
- `nomad_api` (string) - Nomad API endpoint with protocol (for example `http://nomad.service:4646`)
- `compiler_resources` (object) - Set the CPU and memory to use for the compiler; at least 2 GB of memory is required
- `controller_resources` (object) - The resources for the controller and API
