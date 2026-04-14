# workshop-db

Infraestrutura gerenciada do PostgreSQL do projeto `workshop`.

## Proposito

Este repositorio concentra o provisionamento e a configuracao base do banco
PostgreSQL em AWS. Ele nao contem migrations, seeds ou regra de negocio.

## Stack principal

- Terraform
- AWS
- PostgreSQL

## Estrategia de deploy

- `feature/* -> stag`: Pull Request com validacao Terraform e deploy em `staging`
- `stag -> prod`: Pull Request de promocao com deploy em `production`
- autenticacao AWS via OIDC, sem chaves estaticas no repositorio

## Documentacao local

- [docs/README.md](docs/README.md)

