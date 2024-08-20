# Modern Data Stack (MDS) && Marketing

<h1 align="center">
  <a
    target="_blank"
    href="https://github.com/guaradata/etl-mds-marketing"
  >
    <img
      align="center"
      alt="Configuração de conexão do Postgres dentro do Airbyte"
      src="https://github.com/guaradata/etl-mds-marketing/blob/main/shared/img/mds_mkt_architecture.png"
      style="height: 50%;"
    />
  </a>
</h1>

# Introdução

Afinal, o que é Modern Data Stack (MDS)? O termo pode ser traduzido para o português como "Pilha de Dados Moderna" ou "Arquitetura de Dados Moderna". O MDS refere-se ao conjunto de ferramentas e tecnologias utilizadas para o processamento, armazenamento e análise de dados, incluindo uma variedade de softwares de código aberto e proprietários, como o Apache Airflow e o Databricks. O conceito de MDS traz consigo a ideia de uma mudança na arquitetura de dados, adotando ferramentas mais flexíveis e escaláveis à medida que o volume de dados cresce.

# Objetivo

Utilizar ferramentas modernas que compõem arquiteturas de dados atuais para extrair dados de mídia do Facebook Ads (Meta Ads), seguindo as referências disponíveis no [moderndatastack.xyz](<https://www.moderndatastack.xyz/stacks>), página de referência na área.

# Considerações

Este repositório foca principalmente na criação da arquitetura de dados, não em como utilizar as ferramentas que a compõem. Por isso, assume-se que você já tenha alguma familiaridade com as ferramentas utilizadas. Se precisar de ajuda, aqui estão algumas sugestões de vídeos que explicam mais sobre elas:

- Visão geral sobre o [Mage.Ai](https://www.youtube.com/watch?v=gi26uR4M_LI);
- Configurando uma conexão com o [Airbyte](https://www.youtube.com/watch?v=ryEo83sFsX8);

A documentação das ferramentas mencionadas anteriormente são bem completas e vão te ajudar a entender melhor as funcionalidades de cada uma, a documentação do Mage.AI encontra-se nesse [link](https://docs.mage.ai/introduction/overview) e a documentação do Airbyte pode ser acessada por [aqui](https://docs.airbyte.com/).

# Ferramentas

## Base

- [Docker Desktop](https://www.docker.com/get-started);

## MDS

- [Mage.AI](https://www.mage.ai/);
- [Airbyte](https://airbyte.com/);

## Utilitários

- [NGINX](https://nginx.org/);
- [PostgresSQL](https://www.postgresql.org/);

# Requisitos

- [Docker Desktop](https://www.docker.com/get-started);
- [Git](https://git-scm.com/downloads).

# Configuração do ambiente (Windows)

A seguintes etapas consideram que o Docker e o Git estejam previamente configurados na máquina na qual se quer criar este ambiente.

## Configurando o Airbyte

Recentemente, o Airbyte introduziu uma nova opção para utilizar a ferramenta localmente, chamada [abctl](https://docs.airbyte.com/using-airbyte/getting-started/oss-quickstart#1-install-abctl). Essa ferramenta é responsável por criar um cluster Kubernetes localmente, utilizando o [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/).

São muitos termos, mas a implementação é relativamente simples:

### Passo a passo

1. Crie uma pasta "mds-mkt" para o projeto;

2. Abra o Docker Desktop;
3. Baixe a última versão do executável para Windows do [abctl](https://github.com/airbytehq/abctl/releases/latest);
4. Extraía o arquivo "abctl.exe" para a pasta criada anteriormente;
5. Abra o terminal e navegue até a pasta do projeto;
6. Execute o seguinte comando:

```bash
.\abctl.exe local install
```

7. Após a finalização do comando anterior, execute:

```bash
.\abctl.exe local credentials
```

8. Guarde os dados que serão exibidos no terminal, serão utilizados para acessar a interface do Airbyte;
10. Acesse o [http://localhost:8000](http://localhost:8000).
11. Prossiga com as configurações iniciais de login;
12. Para fazer login na interface Web você utilizará o e-mail cadastrado na etapa anterior e a senha de acesso é a mesma que foi salva na etapa 8;

Neste ponto, temos o cluster do Airbyte funcionando localmente. A próxima etapa consiste em configurar a conexão com o [Meta Ads](https://developers.facebook.com/).  Para isso, é necessário criar um aplicativo na seção de desenvolvimento do Meta. Se você precisar criar toda a estrutura do zero, pode seguir [este tutorial](https://amanda-pach.medium.com/extraindo-dados-da-api-de-marketing-do-facebook-com-o-airbyte-71fa6d054342).

Dica: Se a conta de anúncios tiver um volume muito grande de informações coloque uma data de inicio mais próxima da data na qual você está testando esse ambiente (15 dias, ou menos, a partir da data atual), para que seja possível validar toda a configuração antes de testar com um volume de dados maior. O local da configuração está exposto na Imagem 1.

<h1 align="center">
  <a
    target="_blank"
    href="<https://github.com/guaradata/etl-mds-marketing>"
  >
    <img
      align="center"
      alt="Data de início do conector do Facebook Ads"
      src="https://github.com/guaradata/etl-mds-marketing/blob/main/shared/img/start-date-facebook-airbyte.png"
      style="height: 50%;"
    />
  </a>
</h1>

> **Imagem - 1:** Localização da configuração de data de início da extração de dados. **Fonte:** Autoria própria.

## Configurando o Mage.IA

A estrutura do Mage.IA foi conteinerizada junto ao Postgres, e um proxy reverso com NGINX foi adicionado como uma camada adicional de segurança.

### Passo a passo

1. Clone este repositório dentro da pasta "mds-mkt" com o seguinte comando:

```bash
git clone https://github.com/guaradata/etl-mds-marketing.git

```

2. Abra a pasta do projeto clonado;

3. Renomeie o arquivo "env.example.txt" para ".env"

4. Acesse o arquivo "io_config.yaml" que está no diretório ./mage/modern-data-stack, a partir da raiz do projeto que foi clonado;

5. Altere a linha a variável de ambiente "POSTGRES_HOST" para o endereço IPv4 da sua máquina ([como saber meu IPv4?](https://www.youtube.com/watch?v=bvKAa5UTvSs));

6. Abra o terminal e navegue até a pasta do projeto clonado;

7. Inicie os contêineres com o comando:

```bash
docker-compose up --build
```

8. Acesse a interface do [Mage.IA](http://localhost);

# Configuração das ferramentas

Após subir o contêiner do Airbyte e do Mage.IA com sucesso, vamos conectar o Facebook Ads (fonte de dados) ao Postgres (destino).

## Conectando o Facebook Ads ao Postgres com Airbyte

1. Conecte a fonte do Facebook Ads ao Postgres (como [conectar o Airbyte no Postgres?](https://youtu.be/mT9-B3SOKr0?si=sJb6TOp8kJMqPTfK&t=93)). Adicione os mesmos valores das variáveis de ambiente que foram configuradas no arquivo ".env" na configuração de conexão, como mostra a Imagem 2. Não esqueca de adicionar o IPv4 da sua máquina no campo "Host" (indicado com a seta amarela na Imagem 2), que foi obtido no [passo 5 da configuração do Mage.IA](https://github.com/guaradata/etl-mds-marketing?tab=readme-ov-file#configurando-o-mageia);

<h1 align="center">
  <a
    target="_blank"
    href="https://github.com/guaradata/etl-mds-marketing"
  >
    <img
      align="center"
      alt="Configuração de conexão do Postgres dentro do Airbyte"
      src="https://github.com/guaradata/etl-mds-marketing/blob/main/shared/img/postgres-airbyte.png"
      style="height: 50%;"
    />
  </a>
</h1>

> **Imagem - 2:** Configurações da conexão com o Postgres que devem ter os mesmos valores que estão no arquivo ".env". **Fonte:** Autoria própria.

2. A próxima etapa consiste em selecionar um stream do Facebook Ads, o stream que vamos trabalhar aqui é o "ads_insights_platform_and_device", como mostra a Imagem 3;

<h1 align="center">
  <a
    target="_blank"
    href="https://github.com/guaradata/etl-mds-marketing"
  >
    <img
      align="center"
      alt="Stream selecionada no Facebook Ads"
      src="https://github.com/guaradata/etl-mds-marketing/blob/main/shared/img/conn-config-airbyte.png"
      style="height: 50%;"
    />
  </a>
</h1>

> **Imagem - 3:** Seleção da stream "ads_insights_platform_and_device" dentro da conexão do Facebook Ads com o Postgres. **Fonte:** Autoria própria.

3. Finalize a configuração da conexão e aguarde a sincronização dos dados do Facebook Ads com o Postgres.

# Pipeline de dados com Mage.IA

Com a ingestão dos dados do Facebook Ads concluída, vamos testar a pipeline de dados no Mage.IA, que criará uma nova tabela a partir da tabela "ads_insights_platform_and_device".

## Teste da pipeline

1. Acesse a pipeline "mds_facebook" dentro da [interface do Mage.IA](http://localhost/pipelines/mds_facebook/edit?sideview=tree);

2. Rode o primeiro bloco de código para avaliar a conexão com o banco de dados Postgres, se caso houver falhas volte e avalie os passos da configuração conexão [nesta seção](https://github.com/guaradata/etl-mds-marketing?tab=readme-ov-file#configurando-o-mageia);

3. Com o Postgres conectado ao Mage.IA é possível seguir e executar todos os outros blocos, o bloco final irá te mostrar a tabela final criada.

## Sincronize a ingestão e a pipeline de dados

1. Agende a execução da conexão criada no Airbyte para que esteja sincronizada com o cronograma da pipeline de dados "mds_facebook". Isso é importante porque o Mage.IA deve executar a pipeline apenas após o Airbyte concluir a atualização da tabela "ads_insights_platform_and_device".
