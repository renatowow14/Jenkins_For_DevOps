# Requisitos do Docker Host

## Como o SonarQube usa um Elasticsearch incorporado, certifique-se de que a configuração do host Docker esteja em conformidade com os requisitos do modo de produção do Elasticsearch e a configuração dos descritores de arquivo .

* ` https://github.com/SonarSource/docker-sonarqube/issues/282`

## Por exemplo, no Linux, você pode definir os valores recomendados para a sessão atual executando os seguintes comandos como root no host:

* ` sysctl -w vm.max_map_count=524288`
* ` sysctl -w fs.file-max=131072 ` 
* ` ulimit -n 131072 `
* ` ulimit -u 8192 `

# Referencia de Instalação Oficial:

* ` https://docs.sonarqube.org/latest/setup/install-server/ `

$~$

![Alt text](SQ-instance-components.png?raw=true "Title")


# Build

Change config on docker-compose.yml

*      - SONARQUBE_JDBC_USERNAME=user_database 
*      - SONARQUBE_JDBC_PASSWORD=password_database
*      - SONARQUBE_JDBC_URL=jdbc:postgresql://ip_database:5432/sonarqube

Change network config on docker-compose.yml:


*      - rede_lapig
*       ipv4_address: 172.18.0.24
# Run:

*     - docker-compose up -d
