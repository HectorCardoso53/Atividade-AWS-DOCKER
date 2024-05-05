<h1 align ="center">:computer: Atividade-AWS-DOCKER :writing_hand: </h1><br>



## :white_check_mark: Requisitos da atividade:

   <h1 align="center"> 
   <img src="https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/59742285-a826-46c3-b719-1f9a29db23a5" width="500" height="400" />
   </h1><br>

   :globe_with_meridians: Instalação e configuração do DOCKER ou CONTAINERD no host EC2.
      
   :globe_with_meridians: Ponto adicional para o trabalho: Utilize a instalação via script de Start Instance (user_data.sh).
      
   :globe_with_meridians: Efetuar implantar uma aplicação WordPress com contêiner de aplicação RDS banco de dados MySQL.
      
   :globe_with_meridians: Configuração da utilização do serviço EFS AWS para estáticos do container de aplicação WordPress.
      
   :globe_with_meridians: Configuração do serviço de Load Balancer AWS para aplicação WordPress.
  

  
## :white_check_mark: Pontos de atenção: 
> [!IMPORTANT]
> Key information users need to know to achieve their goal.

   :globe_with_meridians: Não utilize IP público para saída dos serviços WordPress (Evite publicar o serviço WordPress via IP público).
            
   :globe_with_meridians: Sugestão para o tráfego: Internet sair pelo LB (Load Balancer Classic).
            
   :globe_with_meridians: Pastas públicas e estáticas do WordPress sugestão de uso do EFS (Elastic File System).
            
   :globe_with_meridians: Fica a classificação de cada membro que usa Dockerfile ou Docker Compose.
            
   :globe_with_meridians: Necessário demonstrar a aplicação WordPress funcionando (tela de login).
            
   :globe_with_meridians: A aplicação WordPress precisa estar rodando na porta 80 ou 8080.
        
   :globe_with_meridians: Utilizar repositório git para versionamento.
        
   :globe_with_meridians: Criar documentação.


## :white_check_mark: Etapas da execução da Atividade: 



   ### :globe_with_meridians: Etapas 1: Criando VPC

   > [!NOTE]
> Informações úteis que os usuários devem saber, obsservar que estamos utilizando a configuração de forma automatica da VPC.

   - [x] Acesse o console AWS e entre no serviço `VPC` .
   - [x] No menu lateral esquerdo, na seção `Virtual private cloud` selecione Your `VPCs` .
   - [x] Dentro de `Your VPCs` clique no botão `Criar VPC` .
   - [x] Altere as seguintes configurações:
      - [x] Em Recursos para criar seleção `VPC e muito mais` .
      - [x] Em Geração automática de name tag coloque o nome `"aws-docker-vpc"`.
      - [x] Em Número de `Zonas de Disponibilidade selecionei 2` .
      - [x] Em gateways `NAT selecionei In 1 AZ` .
      - [x] Em VPC endpoints selecione `Nenhum` .
      - [x]  Finalizar `Criar VPC.`


![image](https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/7503bbd2-43f7-4d74-9f2f-251f4032d19d)


 ### :globe_with_meridians: Etapas 2: Configuração dos Grupos de Segurança
 
- [x] Acesse o console AWS e entrei no serviço `EC2` .

- [x] No menu lateral esquerdo, na seção `Rede e Segurança` , selecione `Grupos de Segurança` .

- [x] Dentro de Grupos de segurança , clique no botão `Criar grupo de segurança` .

- [x] Crie e configure os seguintes grupos de segurança usando a VPC criada anteriormente:

   - [x]  Grupo 1: Balanceador de carga – regras de entrada

> [!IMPORTANT]
> Este grupo está configurado para aceitar o tráfego HTTP na porta 80 de qualquer origem. Isso é comumente usado para distribuir o tráfego entre vários servidores web para garantir um melhor desempenho e confiabilidade do serviço.

 ![image](https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/2dd0b669-65d3-4598-b2ea-6894b73b176c)


   - [x]  Grupo 2: Servidor Web EC2
> [!IMPORTANT]
> Esse grupo esta configurado com a porta SSH (TCP/22) a partir do grupo de segurança "EC2 Docker": Permite acesso SSH apenas das instâncias associadas ao grupo de segurança "EC2 Docker".
Já a porta HTTP (TCP/80) a partir do balanceador de carga: Permite tráfego HTTP apenas do balanceador de carga especificado.

  ![image](https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/7fe9e56f-ff9c-426d-a760-c25e81f13080)


   - [x]  Grupo 3: EC2 Docker

> [!IMPORTANT]
> Este grupo configuração do grupo de segurança "EC2 Docker" permite acesso SSH (porta 22) apenas a partir do "Servidor Web EC2". Isso significa que apenas o servidor web EC2 especificado pode acessar a instância EC2 protegida por esse grupo de segurança através do protocolo SSH.
         
  ![image](https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/6b78367d-8b10-41b5-8660-2c2a9fa5da6f)

   - [x]  Grupo 4: RDS
> [!IMPORTANT]
> Este grupo permite que apenas as instâncias EC2 específicas, pertencentes ao grupo de segurança "Servidor Web EC2", se comuniquem com o banco de dados RDS MySQL ou Aurora através da porta 3306. 

![image](https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/5e2e1866-11e7-437f-b280-e994d4d8ffeb)

   - [x]  Grupo 5: EFS
> [!IMPORTANT]
> Essa configuração permite que apenas as instâncias EC2 específicas, pertencentes ao grupo de segurança "EC2 Web Server", acessem o sistema de arquivos distribuído (EFS) através do protocolo NFS na porta 2049.

![image](https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/303cdc7a-d51c-449a-8322-63a4ab248f10)


### :globe_with_meridians: Etapas 1: Criando EFS (ELASTIC FILE SYSTEM) 


   
   
