*** Settings ***
Resource            ../resources/serve-rest-front.resource
Suite Teardown      Close Browser    ALL

*** Test Cases ***
Cadastro e Login com sucesso Serve Rest front
    Abrir o navegador
    Ir para o ServeRest
    Preencher os dados do novo usuário e cadastrar
    Conferir usuário cadastrado com sucesso

DESAFIO - Conferir se o novo usuário é mostrado na listagem de usuário
    Abrir o navegador
    Ir para o ServeRest
    Preencher os dados do novo usuário e cadastrar
    Conferir usuário cadastrado com sucesso
    Acessar a lista de usuários
    Conferir que o usuário aparece na listagem

Exemplo utilizando requisições https        #não estou fazendo teste de API, mas sim requisiçoes atraves do backend --> https://serverest.dev
    Abrir o navegador
    Ir para o ServeRest
    Criar usuário via API
    Logar com usuário cadastrado via API
