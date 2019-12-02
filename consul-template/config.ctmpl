---
Config:

  environment: {{ with node }}{{ index .Node.Meta "environment" }}{{ end }}

  cloud:
    region: {{ with node }}{{ index .Node.Meta "region" }}{{ end }}
    location_code: {{ with node }}{{ index .Node.Meta "location" }}{{ end }}
    release: {{ with node }}{{ index .Node.Meta "release_ver" }}{{ end }}
    instance-type: {{ with node }}{{ index .Node.Meta "instance_type" }}{{ end }}

  file-system:
    max-files: {{ with node }}{{ if in .Node.Meta.environment "dev" }}{{ key "myService/myComponent/envs/dev/fs.file-max" }}{{ end }}{{ end }}{{ with node }}{{ if in .Node.Meta.environment "stg" }}{{ key "myService/myComponent/envs/stg/fs.file-max" }}{{ end }}{{ end }}{{ with node }}{{ if in .Node.Meta.environment "prod" }}{{ key "myService/myComponent/envs/prod/fs.file-max" }}{{ end }}{{ end }}

  network:
    max_conns: {{ with node }}{{ if in .Node.Meta.environment "dev" }}{{ key "myService/myComponent/envs/dev/max_conns" }}{{ end }}{{ end }}{{ with node }}{{ if in .Node.Meta.environment "stg" }}{{ key "myService/myComponent/envs/stg/max_conns" }}{{ end }}{{ end }}{{ with node }}{{ if in .Node.Meta.environment "prod" }}{{ key "myService/myComponent/envs/prod/max_conns" }}{{ end }}{{ end }}

  login:
    username: admin
    password: {{ with node }}{{ if in .Node.Meta.environment "dev" }}{{ with secret "kv/myService/myComponent/envs/dev?version=1" }}{{ .Data.data.pass }}{{ end }}{{ end }}{{ end }}{{ with node }}{{ if in .Node.Meta.environment "stg" }}{{ with secret "kv/myService/myComponent/envs/stg?version=1" }}{{ .Data.data.pass }}{{ end }}{{ end }}{{ end }}{{ with node }}{{ if in .Node.Meta.environment "prod" }}{{ with secret "kv/myService/myComponent/envs/prod?version=1" }}{{ .Data.data.pass }}{{ end }}{{ end }}{{ end }}

