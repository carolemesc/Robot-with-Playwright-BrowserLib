*** Settings ***
Library        Browser    timeout=00:00:05    enable_presenter_mode=${true}        #por padrão o timeout é 10s; o enable_presenter_mode roda em modo debug, destaca os elementos na tela, mostra as kw que está executando
Library        FakerLibrary
Library        DateTime

*** Variables ***
${BROWSER}                  chromium
${HEADLESS}                 ${false}    #para ver o navegador abrindo e interagindo com os testes
${SITE_SERVE_REST}          https://front.serverest.dev/login
${BOTAO_CADASTRESE}         css=.btn-link
${INPUT_NOME_CADASTRO}      id=nome
${NOME}                     Carol Teste May
${INPUT_EMAIL_CADASTRO}     id=email
${INPUT_SENHA_CADASTRO}     id=password
${CHECKBOX_CADASTRO}        id=administrador
${BOTAO_CADASTRAR}          xpath=//button[@data-testid='cadastrar'][contains(.,'Cadastrar')]
${BOTAO_LOGOUT}             xpath=//button[@data-testid='logout'][contains(.,'Logout')]
${LISTAR_USUARIOS}          xpath=//a[@data-testid='listarUsuarios'][contains(.,'Listar')]    #ou css=a[@data-testid='listarUsuarios']
${TABELA_LISTA_USUARIOS}    xpath=//table[@class='table table-striped'][contains(., 'NomeEmailSenhaAdministradorAções')]    #ou css=table



*** Keywords ***
Abrir o navegador
    New Browser        browser=${BROWSER}        headless=${HEADLESS}

    #********criando os arquivos de evidência********:
    # ${NOW}             Get Current Date          result_format=%d-%m-%Y_%H%M%S
    # &{recordVideo}     Create Dictionary         dir=${OUTPUT_DIR}/evidencias/traces/videos/${NOW}
    # ${TRACE_NAME}      FakerLibrary.Uuid 4                                        #cria um identificador único para colocar como nome do arquivo
    New Context        viewport={'width': 1200, 'height': 800}                      #tamanho da janela do teste
    # ...                tracing=${OUTPUT_DIR}/evidencias/traces/${NOW}/${TRACE_NAME}.zip
    # ...                recordVideo=&{recordVideo}

Ir para o ServeRest
    New Page           url=${SITE_SERVE_REST}
    ${TITLE}           Get Title    ==    Front - ServeRest    #confere o título da página, mas se usar apenas "Get Title" ele retorna o titulo da página também

Preencher os dados do novo usuário e cadastrar
    #Record Selector    #essa kw mostra os seletores no log, depois de usar é só deletar, é o mesmo que usar o f12, mas de forma mais prática
    Click                      ${BOTAO_CADASTRESE}
    ${email}                   FakerLibrary.Email
    Set Test Variable          ${EMAIL_GLOBAL}               ${email}
    Log                        ${EMAIL_GLOBAL}
    Fill Text                  ${INPUT_NOME_CADASTRO}        ${NOME}
    Fill Text                  ${INPUT_EMAIL_CADASTRO}       ${email}
    Fill Text                  ${INPUT_SENHA_CADASTRO}       Password123@
    Check Checkbox             ${CHECKBOX_CADASTRO}
    Click                      ${BOTAO_CADASTRAR}
    Wait For Elements State    ${BOTAO_LOGOUT}

Conferir usuário cadastrado com sucesso
    Wait For Elements State    h1
    Get Text                   h1   ==    Bem Vindo ${NOME}
    Get Element States         ${BOTAO_LOGOUT}    validate    value & visible    #valida se o botão logout aparece, assim como no ultimo step da KW anterior ("Wait For Elements State    ${BOTAO_LOGOUT}"), porém nesse caso ele também valida se o botão possui um valor e é visível
    
Acessar a lista de usuários
    Click                      ${LISTAR_USUARIOS}
    
Conferir que o usuário aparece na listagem    
    ${elemento_email}    Get Table Cell Element    ${TABELA_LISTA_USUARIOS}     1       "${EMAIL_GLOBAL}"
    ${email}             Get Text                  ${elemento_email}  ==  ${EMAIL_GLOBAL}
    ${elemento_nome}     Get Table Cell Element    ${TABELA_LISTA_USUARIOS}      "Nome"       "${EMAIL_GLOBAL}"    #pega o elemento da coluna "nome" onde tem o email que eu quero
    ${nome}              Get Text                  ${elemento_nome}  ==  ${NOME}

Criar usuário via API
    ${email}                       FakerLibrary.Email
    Set Test Variable              ${EMAIL_GLOBAL_API}          ${email}
    ${resposta}                    Http                         url=https://serverest.dev/usuarios
    ...                            method=POST
    ...                            body={"nome": "${NOME}","email": "${email}","password": "Password123@","administrador": "true"}
    Should Be Equal As Integers    ${resposta["status"]}    201

Logar com usuário cadastrado via API
    ${resposta}                    Http                         url=https://serverest.dev/login
    ...                            method=POST
    ...                            body={"email": "${EMAIL_GLOBAL_API}","password": "Password123@"}
    Should Be Equal As Integers    ${resposta["status"]}    200
    LocalStorage Set Item          serverest/userNome       ${NOME}            # adiciona os valores no Local Storage do site. obs.: isso foi pessivel pegar quando logou > f12 > application > locas storage
    LocalStorage Set Item          serverest/userEmail      ${EMAIL_GLOBAL_API}
    LocalStorage Set Item          serverest/userToken      ${resposta["body"]["authorization"]}

    Go To                          url=https://front.serverest.dev/admin/home
    Take Screenshot