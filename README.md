# Atividade-AWS-DOCKER

## Requisitos da atividade:
- [x] Instalação e configuração do DOCKER ou CONTAINERD no host EC2.
  
- Ponto adicional para o trabalho: Utilize a instalação via script de Start Instance (user_data.sh).
  
- Efetuar implantar uma aplicação WordPress com contêiner de aplicação RDS banco de dados MySQL.
  
- Configuração da utilização do serviço EFS AWS para estáticos do container de aplicação WordPress.
  
- Configuração do serviço de Load Balancer AWS para aplicação WordPress.
  
## Pontos de atenção:
  - Não utilize IP público para saída dos serviços WordPress (Evite publicar o serviço WordPress via IP público).
  - Sugestão para o tráfego: Internet sair pelo LB (Load Balancer Classic).
  - Pastas públicas e estáticas do WordPress sugestão de uso do EFS (Elastic File System).
  - Fica a classificação de cada membro que usa Dockerfile ou Docker Compose.
  - Necessário demonstrar a aplicação WordPress funcionando (tela de login).
  - A aplicação WordPress precisa estar rodando na porta 80 ou 8080.  
  - Utilizar repositório git para versionamento.
  - Criar documentação.
