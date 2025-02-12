## Sobre a API-CONECTALA

Essa é uma APIRestful, feita em **PHP 8, Laravel 11 e Docker**

## Pré-requisitos

### Composer

Composer é um gerenciador de dependências do PHP.
É necessário para o Laravel funcionar.

Instruções para instalação: https://getcomposer.org/download/.

No momento da edição deste arquivo:

```bash
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    php composer-setup.php
    php -r "unlink('composer-setup.php');"
    sudo mv composer.phar /usr/local/bin/composer
```

Obviamente o hash acima vai mudar com novas versões do Composer.
Assim, **prefira usar as instruções do link acima**.

### Git

Instruções para instalação:
https://git-scm.com/book/en/v2/Getting-Started-Installing-Git

## Gerando chaves privada e pública do GitHub

No terminal:

```bash
    ssh-keygen -t rsa
```

Local padrão onde a chave é gerada (o comando aguarda _input_, pode ser `<ENTER>`):

```bash
    /root/.ssh/id_rsa
```

Novamente o comando aguarda _input_ de senha. Pode deixar em branco, portanto `<ENTER>` novamente.

Junto com esse arquivo (chave privada), é gerada a **chave pública** (`.pub`). Ela precisa ser exibida para o usuário:

```bash
    sudo cat /root/.ssh/id_rsa.pub
```

O usuário então deve **copiar toda a chave**, no formato iniciado abaixo:

```bash
    ssh-rsa AAAAB3NzaC...
```

O usuário deve:

1. Acessar https://github.com/settings/keys.
2. Usar o botão "New SSH key".
3. Dê um nome para a chave. Ex.: **KEY_API_TEST**
4. Colar todo o conteúdo da chave pública.
5. Clicar em "Add SSH key" novamente.
6. Confirmar com senha do GitHub.

Então, o script pode testar a conexão:

```bash
    ssh -T git@github.com
```

Comando aguarda _input_: `yes<ENTER>`

Se o output for `Hi <USERNAME>!...` é sinal que deu tudo certo!

## Clonando o projeto

1. Crie um novo diretório na raiz do sistema, para o novo projeto;
```bash 
    sudo mkdir /projetos
```
2. Navegue até o diretório onde fará o clone e clone o projeto;
```bash 
    cd /projetos
```
```bash 
    git clone git@github.com:Doginnn/api-conectala.git
```
3. Dentro do diretório e faça uma cópia do arquivo `.env.example` e renomeie-o para `.env`:
```bash 
    sudo cp .env.example .env
```
## Subindo o ambiente com Docker

No terminal, acesse a pasta onde o repositório foi clonado, por exemplo:

```bash
    cd /projetos/api-conectala
```

Dentro da pasta, execute:

```bash
    sudo docker compose up -d
```

## Migrando o banco de dados

Para migrar o banco de dados, o container `api-conectala` deve estar `up`. Agora é só rodar o comando abaixo.
```shell
    docker exec -it api-conectala php artisan migrate
```

**Obs.:** O banco de dados ficará somente com as tabelas e sem conteúdo.

Caso queira migrar e popular o Database com registros **FAKE** ([seeders](https://laravel.com/docs/10.x/eloquent-factories)), execute o comando abaixo:

**Atenção:** Esse comando irá **APAGAR** o Database criado anteriormente e popular com novos dados Fake. Se você salvou algo anteriormente no Database, **TUDO SERÁ PERDIDO**.

```shell
    docker exec -it api-conectala php artisan migrate:fresh --seed
```

# Endpoints da API
Dependendo das configurações no Docker, você poderá testar nos ambientes abaixo:

```text
    API via POSTMAN/INSOMNIA - http://127.0.0.1:8085/api
```

```text
    WEB via BROWSER DE SUA PREFERÊNCIA - http://127.0.0.1:8085
```
A API possui os seguintes endpoints:
1. Listar Todos os Usuários
- Método: **GET**
- URL: `/api`
- Descrição: Retorna uma lista de todos os usuários cadastrados.
- Exemplo de Resposta:
```json
[
    {
        "id": 1,
        "name": "root",
        "email": "root@gmail.com",
        "email_verified_at": "2025-02-12T11:54:55.000000Z",
        "created_at": "2025-02-12T11:54:55.000000Z",
        "updated_at": "2025-02-12T11:54:55.000000Z"
    },
    {
        "id": 2,
        "name": "admin",
        "email": "admin@gmail.com",
        "email_verified_at": "2025-02-12T11:54:55.000000Z",
        "created_at": "2025-02-12T11:54:55.000000Z",
        "updated_at": "2025-02-12T11:54:55.000000Z"
    },
    {
        "id": 3,
        "name": "suporte",
        "email": "suporte@gmail.com",
        "email_verified_at": "2025-02-12T11:54:55.000000Z",
        "created_at": "2025-02-12T11:54:56.000000Z",
        "updated_at": "2025-02-12T11:54:56.000000Z"
    }
]
```
2. Mostra detalhes de um Usuário
- Método: **GET**
- URL: `/api/users/{id}`
- Descrição: Retorna os detalhes de um usuário específico.
- Exemplo de Resposta:
```json
{
    "id": 1,
    "name": "root",
    "email": "root@gmail.com",
    "email_verified_at": "2025-02-12T11:54:55.000000Z",
    "created_at": "2025-02-12T11:54:55.000000Z",
    "updated_at": "2025-02-12T11:54:55.000000Z"
}
```
3. Criar um novo Usuário
- Método: **POST**
- URL: `/api/users`
- Descrição: Cria um novo usuário específico.
- Exemplo de Requisição(JSON):
```json
{
    "name": "Diógenes Dantas",
    "email": "diogenes4@gmail.com",
    "password": "QualquerSenha@123"
}
```
- Exemplo de Resposta:
```json
{
    "name": "Diógenes Dantas",
    "email": "diogenes4@gmail.com",
    "email_verified_at": "2025-02-12T12:36:22.000000Z",
    "updated_at": "2025-02-12T12:36:22.000000Z",
    "created_at": "2025-02-12T12:36:22.000000Z",
    "id": 4
}
```
4. Atualizar um usuário específico.
- Método: **PUT**
- URL: `/api/users/{id}`
- Descrição: Atualiza um novo usuário específico.
- Exemplo de Requisição(JSON):
```json
{
    "name": "Diógenes Dantas Modificado",
    "email": "diogenes4@gmail.com",
    "password": "Mudar!123"
}
```
- Exemplo de Resposta:
```json
{
    "id": 4,
    "name": "Diógenes Dantas Modificado",
    "email": "diogenes4@gmail.com",
    "email_verified_at": "2025-02-12T12:36:22.000000Z",
    "created_at": "2025-02-12T12:36:22.000000Z",
    "updated_at": "2025-02-12T12:40:56.000000Z"
}
```
5. Deletar um usuário específico.
- Método: **DELETE**
- URL: `/api/users/{id}`
- Descrição: Deleta um usuário específico.
- Exemplo de Requisição(JSON):
- Exemplo de Resposta:
```json
{
    "message": "User deleted successfully!"
}
```
## Contato
- Email: diogenesemmanuel@gmail.com
- Telefone: (83) 999 712 101
- Linkedin: https://linkedin.com/in/doginnn
- Feito com ❤️ por Diógenes Dantas 🚀
