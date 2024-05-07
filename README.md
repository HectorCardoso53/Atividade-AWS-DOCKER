<h1 align ="center">:computer: Atividade-AWS-DOCKER- UFOPA :writing_hand: </h1><br>



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

<h1 align ="center"> Topologia do Grupo de Segurança </h1><br>

![Apresentação mídia kit blogueira delicado rosa](https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/4464b253-5222-4a1f-b17b-f06aeb9c653d)


 ### :globe_with_meridians: Etapas 2: Configuração dos Grupos de Segurança
 
- [x] Acesse o console AWS e entrei no serviço `EC2` .

- [x] No menu lateral esquerdo, na seção `Rede e Segurança` , selecione `Grupos de Segurança` .

- [x] Dentro de Grupos de segurança , clique no botão `Criar grupo de segurança` .

- [x] Crie e configure os seguintes grupos de segurança usando a VPC criada anteriormente:

   - [x]  Grupo 1: Balanceador de carga 

> [!IMPORTANT]
> Este grupo está configurado para aceitar o tráfego HTTP na porta 80 de qualquer origem. Isso é usado para distribuir o tráfego entre vários servidores web e garantir um melhor desempenho e confiabilidade do serviço.

 ![image](https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/2dd0b669-65d3-4598-b2ea-6894b73b176c)


   - [x]  Grupo 2: Servidor Web EC2
> [!IMPORTANT]
> Esse grupo esta configurado com a porta SSH (TCP/22) a partir do grupo de segurança "EC2 Docker": Permite acesso SSH apenas das instâncias associadas ao grupo de segurança "EC2 Docker".
Já a porta HTTP (TCP/80) a partir do balanceador de carga: Permite tráfego HTTP apenas do balanceador de carga especificado.

  ![image](https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/7fe9e56f-ff9c-426d-a760-c25e81f13080)


   - [x]  Grupo 3: EC2 Docker

> [!IMPORTANT]
> A configuração do grupo de segurança "EC2 Docker" permite acesso SSH (porta 22) apenas a partir do "Servidor Web EC2". Isso significa que apenas o servidor web EC2 especificado pode acessar a instância EC2 protegida por esse grupo de segurança através do protocolo SSH.
         
  ![image](https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/6b78367d-8b10-41b5-8660-2c2a9fa5da6f)

   - [x]  Grupo 4: RDS
> [!IMPORTANT]
> Este grupo permite que apenas as instâncias EC2 específicas, pertencentes ao grupo de segurança "Servidor Web EC2", se comuniquem com o banco de dados RDS MySQL ou Aurora através da porta 3306. 

![image](https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/5e2e1866-11e7-437f-b280-e994d4d8ffeb)

   - [x]  Grupo 5: EFS
> [!IMPORTANT]
> Essa configuração permite que apenas as instâncias EC2 específicas, pertencentes ao grupo de segurança "EC2 Web Server", acessem o sistema de arquivos distribuído (EFS) através do protocolo NFS na porta 2049.

![image](https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/303cdc7a-d51c-449a-8322-63a4ab248f10)


### :globe_with_meridians: Etapas 3: Criando EFS (ELASTIC FILE SYSTEM) 
- [x] Passo 1:
   - [x] Procure por `EFS` na Amazon AWS o serviço de arquivos de NFS escalável da AWS.
   - [x] Na Página de EFS clique em `Criar sistema de arquivos`.

<h1 align="center">      
   <img src="https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/bae165f9-342f-4e3e-987b-cf407e8e4a99" />
</h1><br>

- [x] Passo 2:
   - [x] No campo nome digite `EFS-DOCKER`.
   - [x] Clique em `Personalizar`.

<h1 align="center">      
   <img src="https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/8d4e2d5e-05d6-430a-a1bd-43d590c69761" />
</h1><br>

- [x] Passo 3:
   - [x] No campo Virtual Private Cloud (VPC) selecione a `VPC` que foi criada anteriormente.
   - [x] No campo Subnet ID selecione as `subnets privadas` de cada AZ.
   - [x] No campo `grupo de segurança` selecionei o grupo `EFS` que foi criado anteriormente.
   - [x] Cliquei em `Próximo`.

<h1 align="center">      
   <img src="https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/76b1de6e-d5a6-4346-bf9a-b38b2cf637f2" />
</h1><br>

- [x] Passo 4:
   - [x] Política do sistema de arquivos:
      - [x] Cliquei em Próximo.
- [x] Passo 5
   - [x] Revisar e criar:
      - [x] Revise e clique em Criar para finalizar.


 ### :globe_with_meridians: Etapas 4: Criando o Relational Database Service(RDS):
- [x] Passo 1: 
   - [x] Acesse o console AWS e entre no serviço de `RDS`.
   - [x] Na página de RDS clique em `Criar Banco de Dados`.

![image](https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/29e4e88a-0a98-4910-b306-d1c37086448e)


- [x] Passo 2:
   - [x] Selecione Modo de `Criação Padrão`. 
   - [x] Na seção Opções de mecanismo selecione `MySQL`.

   <h1 align="center"> 
   <img src="https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/c002b261-609a-4628-abc8-c0e9ef1c149b" width="500" height="400" />
   </h1><br>
  
- [x] Passo 3:
   - [x] Na seção modelos selecione `Nível Gratuito`.
      <h1 align="center"> 
   <img src="https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/71938304-3e7e-4d68-a8c1-8f1957ca92f3"/>
   </h1><br>

- [x] Passo 4:
      
> [!NOTE]
> Crie tanto o identificar, Usuário e senha iguais para que fique mais fácil a configuração do seu WordPress posteriomente.
   - [x] Na `seção Configurações(RDS)` adicione um `Identificar`, `Usuário`, `senha` para o RDS  e depois prossiga.
   <h1 align="center"> 
   <img src="https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/ed7e5cb3-d583-4f0d-a3c3-cdb7c7ff0d0f"/>
   </h1><br>


- [x] Passo 5:
   - [x] Em `Armazenamento` determine o tamanho do armazenamento do `DB`.

   <h1 align="center"> 
   <img src="https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/0f30b98e-3b76-4768-9748-26913dfc2b49"/>
   </h1><br>

- [x] Passo 6:
   - [x] Selecione a `VPC` criada anteriomente.
   - [x] Habilite o acesso público.
   - [x] Selecione o grupo de segurança `RDS`.

   <h1 align="center"> 
   <img src="https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/ac6239e8-c5f1-4bd4-87ae-68b830c8395e"/>
   </h1><br>

- [x] Passo 7:
   - [x] Na seção `Configuração Adicional`, no campo `Nome do banco de dados inicial` coloque o nome `wordpress`.
     
   <h1 align="center"> 
   <img src="https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/97a728d4-d8df-4653-9a21-f3475ba4a627"/>
   </h1><br>
- [x] Passo 8:
   - [x] Revise e clique em `Criar Banco de Dados` para finalizar.

 ### :globe_with_meridians: Etapas 5: Criando o Classic Load Balancer:
 - [x] Passo 1:
     - [x] Acesse o console `AWS` e entre no serviço `EC2`.
     - [x] No menu lateral esquerdo, na seção de Load Balancing selecionei `Load Balancers`.
     - [x] Dentro de Load Balancers cliquei no botão `Criar load balancer`.

   <h1 align="center"> 
   <img src="https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/156e82b4-3a68-4e5f-8cc5-d8193fa8144e"/>
   </h1><br>
   

- [x] Passo 2:
     - [x] Em `Tipos de load balancer` cliquei em `Classic Load Balancer` e depois em `Criar`.

<h1 align="center"> 
   <img src="https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/dd6c1740-b589-4155-84cb-4fb493872601"/>
   </h1><br>

- [x] Passo 3:
     - [x] No campo Nome do load balancer digitei `LoadBalancer`.
     - [x] Na seção `Mapeamento de rede` , no campo VPC selecionei a `VPC` criada anteriormente.
     - [x] No campo `Mapeamento` selecione as duas AZ's e suas respectivas `subnets públicas`.
     - [x] No campo de `Grupo de segurança` selecione o grupo `Load Balancer` que foi criado anteriormente.
     - [x] Na seção `Verificações de integridade`, no campo `Caminho de ping` adicione o caminho `"/wp-admin/install.php"`.


<h1 align="center"> 
   <img src="https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/0fcf0eb6-6ad8-499f-9fa6-b9cc35161f9a"/>
   </h1><br>

- [x] Passo 4:
   - [x] Cliquei em Criar load balancer para finalizar.
     

### :globe_with_meridians: Etapas 6: Gerando Par de Chave:
- [x] Passo 1:
   - [x] Acesse o console `AWS` e entrei no serviço `EC2`.
   - [x] No menu lateral esquerdo, na seção de `Redes e Segurança` selecionei `Pares de chave`.
   - [x] Dentro de `Par de Chave` clique no botão Criar `Par de Chave`.
   - [x] No campo Nome digite `"HectorSSH"`.
   - [x] No campo `Tipo de par de chave` selecione `RSA`.
   - [x] No campo `Formato de arquivo de chave privada` selecionei `.pem`.
   - [x] Cliquei no botão `Criar Par de chave`.
   - [x] Salvei o arquivo `.pem`.

 <h1 align="center"> 
   <img src="https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/68a80969-5147-4dd8-821d-e8183e31c074"/>
   </h1><br>


### :globe_with_meridians: Etapas 7: Criando modelo de execução:
- [x] Passo 1:
   - [x] Acesse o console AWS e entrei no serviço EC2.
   - [x] No menu lateral esquerdo, na seção `Instâncias` selecione `Modelo de execução`.
   - [x] Dentro de `Modelo de Execução` clique no botão Criar `Modelo de Execução`.
     
     <h1 align="center"> 
      <img src="https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/4b443d42-e557-4fb5-838e-ef1c6a472cab"/>
     </h1><br>
     
- [x] Passo 2:


   - [x] No campo Criar `Modelo de Execução` nome digitei `wordpress`.
   - [x] No campo `Descrição da versão do modelo` digite `wordpress`.
   - [x] Em Imagens de Aplicativos e Sistemas Operacionais, clique em `Início Rápido`, depois cliquei em `Amazon Linux` e selecionei a AMI do `Amazon Linux 2`.
   - [x] Na seção `Tipo de Instância` selecionei o tipo `t3.small`.
   - [x] No campo `Par de Chave` nome selecionei o `Par de chave` criada anteriormente.
   - [x] Em Configurações de Rede, no campo `Grupos de Segurança`, selecione o grupo `Servidor Web EC2` que foi criado anteriormente.
   - [x] Em `Tags de Recursos`, clique em Adicionar nova tag e adicionei as tags de Chave `Name: PB UFOPA`, `CostCenter:C092000024`  e `Projeto: PB UFOPA` para os Tipos de Recursos Instâncias e Volumes."
     
  <h1 align="center"> 
      <img src="https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/ac56b962-8493-44fc-84a7-1035346245d7"/>
     </h1><br>
     
   - [x] Em `Detalhes Avançados`, no campo `user_date.sh` adicione o script abaixo:
     

      
         #!/bin/bash
         #Atualizar os pacotes do sistema
         
         sudo yum update -y  ---------------> Esta opção responde "sim" automaticamente para instalação ou atualização do sistesma.
           |   |    |
           |   |     -----------------------> Atualizar os pacotes para suas versões mais recente
           |    ----------------------------> Ele permite instalar, atualizar e remover pacotes do sistema.
            --------------------------------> Executar comando como super usuário(Root)

         #Instalar, iniciar e configurar a inicialização automática do docker
         
         sudo yum install docker -y ---------> Esta sendo feito a estalação do docker de forma automática.
         sudo systemctl start docker
                 |       |
                 |        -------------------> Iniciar o serviço no caso do docker
                  ---------------------------> é o sistema de inicialização padrão em distribuições Linux.
         
         sudo systemctl enable docker--------> Este comando configura o Docker para iniciar automaticamente sempre que o sistema for inicializado.
         
         #Adicionar o usuário ec2-user ao grupo docker
         sudo usermod -aG docker ec2-user 
                 |     |           |
                 |     |            ------>  é o usuário padrão em instâncias do Amazon EC2 baseadas em Amazon Linux
                 |      ------------------> o "a" adiciona o usuario. e o "G" especifica o grupo
                 |                            ao qual o usuário será adicionado(docker).
                 |
                  ------------------------> Modifica um usuário.
         
         #Instalação do docker-compose
                ------------------------------>É uma ferramenta de linha de comando utilizada para transferir
               |                                 dados de para um servidor, utilizando um dos protocolos(https)
               |                                 
               |     -------------------------> ele instrui o curl a seguir automaticamente os redirecionamentos
               |    |                                            -------------------------------->  Esta é a URL de onde o Docker Compose será baixado.
               |    |                                           |
         sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose ----> Esta parte do comando diz onde salvar o arquivo baixado
                                                                                                       |          |        |
                                                                                                       |          |         ----> especifica o nome do arquivo de saída onde o conteúdo da URL será salvo.
                                                                                                       |           ------------> retorna a arquitetura do hardware.
                                                                                                        -----------------------> retorna o nome do sistema operacional.       
         sudo chmod +x /usr/local/bin/docker-compose ---------> Aqui estou tornaod executável o docker compose. 
         
         #Instalar, iniciar e configurar a inicialização automática do nfs-utils
         sudo yum install nfs-utils -y ------------> instalação do nfs
         sudo systemctl start nfs-utils -----------> Iniciar o serviço no caso do nfs- ultis
         sudo systemctl enable nfs-utils ----------> Este comando configura o nfs-utils para iniciar automaticamente sempre que o sistema for inicializado.
         
         #Criar a pasta onde o EFS vai ser montado
         sudo mkdir /efs
         
         #Montagem e configuração da montagem automática do EFS
               --------------> Este é o comando usado para montar sistemas de arquivos em diretórios existentes.
               |         -----> Especifica o tipo de sistema de arquivos a ser montado.
               |         |          -------->  Especifica a versão do NFS
               |         |         |             --------->Define o tamanho máximo do bloco de leitura para 1 MB ----------------------------------------> Esta é a localização do EFS que está sendo montado. 
               |         |         |            |                                                                              |
         sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-087b346d04000f310.efs.us-east-1.amazonaws.com:/ efs ------> o diretório que será montado
                                                                 |
                                                                 |
                                                                  ---------------------------------> Define o tamanho máximo do bloco de gravação para 1 MB
                                                                                                                                                                       ----->  indica  que o sistema de arquivos não será incluído em backups                                                                                                                                                                       |            e não será verificado pelo fsck durante a inicialização.                                                                                                                                                                         |
                                                                                                                                                                      |  
         sudo echo "fs-087b346d04000f310.efs.us-east-1.amazonaws.com:/ /efs nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0" >> /etc/fstab --> Este é o redirecionamento de saída do comando                    |                    |                                           |                                                                                  |                          echo.
               |                    |                                           |                                                                                  |   
               |                    |                                            ----------------------------------------------------------------------------------                                                                                          |                    |                                                                                | 
               |                    |                                                                                |
               |                    |                                                                                 -----------------------------------> Configurações para a montagem do NFS, como versão do NFS, tamanho do bloco de                     |                    |                                                                                                                        leitura/gravação
               |                    ------------------------------------->Este é o ponto de montagem local onde o EFS será montado.
               ----------------------------------------------------------> Este comando é usado para imprimir texto na saída padrão.
                  
         # Criar uma pasta para os arquivos do WordPress
         sudo mkdir /efs/wordpress
         
         # Criar um arquivo docker-compose.yaml para configurar o WordPress
               ---------------------------------------------------------------->  é um comando usado para exibir o conteúdo de arquivos.
               |
               |
         sudo cat <<EOL > /efs/docker-compose.yaml -------------------------------> redireciona a entrada de texto fornecida pelo "here document" para o arquivo /efs/docker-compose.yaml;
                    |
                     ---------------------------> indica o início do "here document"
         version: '3.8'
         services:
           wordpress:
             image: wordpress:latest
             container_name: wordpress
             ports:
               - "80:80"
             environment:
               WORDPRESS_DB_HOST: wordpress.cbggey8s8yli.us-east-1.rds.amazonaws.com
               WORDPRESS_DB_USER: wordpress
               WORDPRESS_DB_PASSWORD: wordpress
               WORDPRESS_DB_NAME: wordpress
               WORDPRESS_TABLE_CONFIG: wp_
             volumes:
               - /efs/wordpress:/var/www/html
         EOL
         
         # Inicializar o WordPress com docker-compose
               ----------------------------------------------> ferramenta usada para lidar com aplicativos Docker compostos por vários contêineres
              |                                       --------------------> É o comando usado para iniciar os serviços definidos no arquivo docker-compose.yaml
              |                                      |
         docker-compose -f /efs/docker-compose.yaml up -d --> Esta opção indica que os contêineres devem ser iniciados em modo "Segundo plano".
                         |              |
                         |              |
                         |               ------------------------------> Especifica o arquivo de configuração do Docker Compose a ser usado para definir os serviços. 
                         ------------------------------------------------>  é usada para especificar o arquivo de configuração do Docker Compose a ser utilizado 



### :globe_with_meridians: Etapas 8: Criando Auto Scaling:

- [x] Passo 1:
   - [x] Acesse o console AWS e entre no serviço `EC2`.
   - [x] No menu lateral esquerdo, na seção de `Auto Scaling` selecione `Grupo do Auto Scaling`
   - [x] Dentro de `Grupo do Auto Scaling` clique no botão Criar `Grupo do Auto Scaling`.
  
   <h1 align="center"> 
      <img src="https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/d0e44977-97bc-468c-a80b-2f2edb515f27"/>
     </h1><br>
- [x] Passo 2:
   - [x] Escolha o `modelo de lançamento`
   - [x] No campo Nome do `grupo do Auto Scaling` digite `Dimensionamento_automático`.
   - [x] Na seção `modelo de execução` selecione o `modelo` criado anteriormente.
   - [x] Clique em `Próximo`.

  <h1 align="center"> 
      <img src="https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/48690ac4-7766-408c-a18b-eab24636587d"/>
     </h1><br>

- [x] Passo 3:
   - [x] Na seção `Rede` , no campo `VPC` selecione a `VPC` criada anteriormente.
   - [x] No campo Zonas de disponibilidade e sub-redes selecione as duas `sub-redes privadas` criadas anteriormente.
   - [x] Cliquei em `Próximo` .
         
  <h1 align="center"> 
      <img src="https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/d4ad30d3-1b77-401e-97b3-0568ca16a92e"/>
     </h1><br>

- [x] Passo 4 :
   - [x] Na seção `Balanceamento de carga` selecione `Anexar a um balanceador de carga existente` .
   - [x] Na seção `Anexar a um balanceador de carga existente`, clique em Escolher entre `Classic Load Balancers` e selecione o `balanceador de carga` criado anteriormente.
   - [x] Cliquei em `Próximo`.
     
  <h1 align="center"> 
      <img src="https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/124a29e6-7123-4fa3-9d51-e1dc555d620d"/>
     </h1><br>
     
- [x] Passo 5 :
   - [x] No campo Capacidade desejada `digite "2"`.
   - [x] Em Scaling , no campo Capacidade mínima desejada `digite "2"`.
   - [x] No campo Capacidade máxima desejada `digitei "4`".
   - [x] Em Escalabilidade automática selecione a opção Política de escalabilidade de `rastreamento de destino`
   - [x] No campo Tipo de métrica deixei a padrão `Utilização média da CPU`.
   - [x] No campo Valor alvo digitei `75`.
   - [x] Cliquei em `Próximo` .

<h1 align="center"> 
      <img src="https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/8ffcb2d3-0ab2-44e1-aeaf-a24a58ae6895"/>
     </h1><br>
     

- [x] Passo 6 :
- [x] Próximos passos só apertar em próximo até finalizar a cria do `Grupo de Auto Scaling` .

![image](https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/9af5af88-54b8-486f-af9f-f750ff85197d)


### :globe_with_meridians: Etapas 9: Configuração do EC2 Instance Connect Endpoint:

- [x] Passo 1:
   - [x] Acesse o console AWS e entre no serviço `VPC` .
   - [x] No menu lateral esquerdo, na seção `Nuvem privada virtual` selecione `Endpoints` .
   - [x] Dentro de `Endpoints` clique no botão `Criar endpoint` .

   <h1 align="center"> 
      <img src="https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/dde15139-9e4d-4519-a451-9827eefccb81"/>
     </h1><br>
      
- [x] Passo 2:
   - [X] Em Name tag coloquei o nome `conexao endpoint`.
   - [x] Na categoria de `serviço` selecione `EC2 Instance Connect Endpoint`.
   - [x] Em VPC selecione a `VPC criada anteriormente`.
   - [x] Em `Grupo de segurança` selecione o grupo `EC2 DOCKER` que foi criado anteriormente.
   - [x] Em Subnet selecione uma `subnet privada` que foi criada anteriormente.
   - [x] Cliquei em `Criar endpoint`.

![image](https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/adef5414-657e-4b94-9fa0-8f5b6b998764)
![image](https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/7c2a38f3-d9af-4638-9fd3-d232628ac5ea)


### :globe_with_meridians: Etapas 10: Instalando o WordPress:

- [x] Passo 1:
   - [x] Acesse o `DNS name` do `Load Balancer` através do navegador.
  <h1 align="center"> 
      <img src="https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/316b1e8d-c48e-48f9-9b76-553016ba88c8"/>
     </h1><br>

- [x] Passo 2:
   - [x] Na tela de instalação do `WordPress` mantenha o `idioma padrão` e clique em `Continue`.

     <h1 align="center"> 
      <img src="https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/f28dd214-91b2-424e-a679-75d4101bef4d"/>
     </h1><br>    

- [x] Passo 3:
   - [x] Na tela seguinte preenchi os dados para `criação do usuário`.
   - [x] Cliquei em `Instalar WordPress` para finalizar.
         
        <h1 align="center"> 
      <img src="https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/22e035dc-e339-475f-bf17-b3236f3bd63c"/>
     </h1><br>   
     
- [x] Passo 4:
   - [x] Logue com seu `usuário` e `senha criado` anteriomente.
   - [x] Clique em `Logar`
  
   <h1 align="center"> 
      <img src="https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/50e4a342-5363-4705-b468-e26f7d6c18cb"/>
     </h1><br>

- [x] Passo 5:
   - [x] Painel de `configuração do wordpress`.
  
![WhatsApp Image 2024-05-06 at 15 22 20](https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/bdfa042d-9b22-48b2-92a1-25b200900d7f)

- [x] Passo 6:
   - [x] Vizualiação do modelo escolhido no `painel do wordpress` anteriomente.

![WhatsApp Image 2024-05-06 at 15 23 35](https://github.com/HectorCardoso53/Atividade-AWS-DOCKER/assets/118605794/dd538152-77ef-4e40-922a-3ddcaec795d2)






