# Containerized Applicatication Development Tools

## About this repo

Find more updated version on [Github](https://github.com/kgfathur/container-apps-dev-tools.git)

## Todo

- [ ] Build script
  - [x] centralized build script
  - [x] build-env variable validation and check
  - [x] Multiple image tagging
  - [x] Multiple and optional push image to registry
  - [x] Allowlist & Denylist image to be built
  - [ ] Build only specific images/versionss
  - [x] Add build command options: no-cache, progress, etc
- [ ] Build environment variable
  - [x] ignore comment strings (#...)
  - [x] overwrite build environemt variable for spesific context sub directory
  - [ ] Dynamic environment variable
- [ ] Sample template testing/deploy
  - [ ] Docker compose
  - [ ] Docker swarm
  - [ ] Kubernetes
  - [ ] OpenShift/OKD
- [ ] CI/CD Integrations
  - [ ] Secret Scanning
  - [ ] Dockerfile scan
  - [ ] Software Bill of Materials (SBOM)
  - [ ] Software Composition Analysis (SCA)
  - [ ] Dynamic Application Security Testing (DAST)
  - [ ] Container image signing

## Containers images:

- [ ] [nginx](nginx): Rootless and unprivileged nginx container image
  - [ ] [ubi-8](nginx/ubi-8)
  - [ ] [ubi-9](nginx/ubi-9)
  - [ ] [rocky-8](nginx/rocky-8)
  - [ ] [rocky-8](nginx/rocky-9)
  - [x] [ubuntu-20.04](nginx/ubuntu-20.04)
  - [x] [ubuntu-22.04](nginx/ubuntu-22.04)
- [ ] [nodejs](nodejs): Rootless and unprivileged nginx container image
  - [ ] [ubi-8](nodejs/ubi-8)
  - [ ] [ubi-9](nodejs/ubi-9)
  - [ ] [rocky-8](nodejs/rocky-8)
  - [ ] [rocky-8](nodejs/rocky-9)
  - [ ] [ubuntu-20.04](nodejs/ubuntu-20.04)
  - [x] [ubuntu-22.04](nodejs/ubuntu-22.04)
- [ ] [php-fpm](php-fpm): Rootless and unprivileged php-fpm with nginx container image
  - [ ] [ubi-8](php-fpm/ubi-8)
  - [ ] [ubi-9](php-fpm/ubi-9)
  - [ ] [rocky-8](php-fpm/rocky-8)
  - [ ] [rocky-8](php-fpm/rocky-9)
  - [x] [ubuntu-20.04](php-fpm/ubuntu-20.04)
  - [x] [ubuntu-22.04](php-fpm/ubuntu-22.04)
- [ ] [laravel](laravel): Rootless and unprivileged laravel with nginx and php-fpm container image
  - [ ] [ubi-8](laravel/ubi-8)
  - [ ] [ubi-9](laravel/ubi-9)
  - [ ] [rocky-8](laravel/rocky-8)
  - [ ] [rocky-8](laravel/rocky-9)
  - [ ] [ubuntu-20.04](laravel/ubuntu-20.04)
  - [ ] [ubuntu-22.04](laravel/ubuntu-22.04)
