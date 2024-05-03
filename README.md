# Atividade-AWS-DOCKER

## Requisitos da atividade:
    - [x] Instalação e configuração do DOCKER ou CONTAINERD no host EC2.
      
    - [x] Ponto adicional para o trabalho: Utilize a instalação via script de Start Instance (user_data.sh).
      
    - [x] Efetuar implantar uma aplicação WordPress com contêiner de aplicação RDS banco de dados MySQL.
      
    - [x] Configuração da utilização do serviço EFS AWS para estáticos do container de aplicação WordPress.
      
    - [x] Configuração do serviço de Load Balancer AWS para aplicação WordPress.
  
## Pontos de atenção:
      - [x] Não utilize IP público para saída dos serviços WordPress (Evite publicar o serviço WordPress via IP público).
            
      - [x] Sugestão para o tráfego: Internet sair pelo LB (Load Balancer Classic).
            
      - [x] Pastas públicas e estáticas do WordPress sugestão de uso do EFS (Elastic File System).
            
      - [x] Fica a classificação de cada membro que usa Dockerfile ou Docker Compose.
            
      - [x] Necessário demonstrar a aplicação WordPress funcionando (tela de login).
            
  - [x] A aplicação WordPress precisa estar rodando na porta 80 ou 8080.
        
  - [x] Utilizar repositório git para versionamento.
        
  - [x] Criar documentação.
