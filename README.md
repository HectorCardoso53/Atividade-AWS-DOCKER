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

   - [ ] Acesse o console AWS e entre no serviço `VPC` .
   - [ ] No menu lateral esquerdo, na seção `Virtual private cloud` selecione Your `VPCs` .
   - [ ] Dentro de `Your VPCs` clique no botão `Criar VPC` .
   - [ ] Altere as seguintes configurações:
      - [ ] Em Recursos para criar seleção `VPC e muito mais` .
      - [ ] Em Geração automática de name tag coloque o nome `"aws-docker-vpc"`.
      - [ ] Em Número de `Zonas de Disponibilidade selecionei 2` .
      - [ ] Em gateways `NAT selecionei In 1 AZ` .
      - [ ] Em VPC endpoints selecione `None` .
      - [ ]  Finalizar `Criar VPC.`


![image](https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/e391930b-1026-4895-a55d-f30a6e352c34)

 ### :globe_with_meridians: Etapas 2: Configuração dos Grupos de Segurança
 
- [ ] Acesse o console AWS e entrei no serviço EC2 .

- [ ] No menu lateral esquerdo, na seção Rede e Segurança , selecione Grupos de Segurança .

- [ ] Dentro de Grupos de segurança , clique no botão Criar grupo de segurança .

- [ ] Crie e configure os seguintes grupos de segurança usando uma VPC criada anteriormente:

   - [ ]  Grupo 1: Balanceador de carga – regras de entrada

  ![image](https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/cec91ffe-7935-4215-8d5d-bca3e22a424b)

   - [ ]  Grupo 2: Servidor Web EC2

  ![image](https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/7fe9e56f-ff9c-426d-a760-c25e81f13080)


   - [ ]  Grupo 3: EC2 Docker
         
  ![image](https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/6b78367d-8b10-41b5-8660-2c2a9fa5da6f)


   
   
