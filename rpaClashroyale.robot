*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    Libraries/PrimeControlApiClashroyale.py

*** Variables ***
${BROWSER}          Chrome
${URL}              https://developer.clashroyale.com/
${MnuLogin}         xPath://*[@id="content"]/div/div[2]/div/header/div/div/div[3]/div/a[2]
${inpEmail}         xPath://*[@id="email"]
${inpSenha}         xPath://*[@id="password"]
${BtnLogin}         xPath://*[@id="content"]/div/div[2]/div/div/div/div/div/div/form/div[4]/button
${dropUserLogin}    xPath://*[@id="content"]/div/div[2]/div/header/div/div/div[3]/div/div/button
${dropMyAccount}    xPath://*[@id="content"]/div/div[2]/div/header/div/div/div[3]/div/div/ul/li[1]/a
${BtnCreatKey}      xPath://*[@id="content"]/div/div[2]/div/div/section[2]/div/div/div[2]/p/a/span[2]
${KeyName}          xPath://*[@id="name"]
${KeyDesc}          xPath://*[@id="description"]
${KeyIp}            xPath://*[@id="range-0"]
${BtnKey}           xPath://*[@id="content"]/div/div[2]/div/div/section/div/div/div[2]/form/div[5]/button
${StatusKeyApi}
${TokenApi}

*** Keywords ***
Registrar
    [Arguments]        ${message}    ${tipoKw}=k
    Log                ${message}
    Log To Console     ${message}
    Log To Console     '............................'
    ${PathFileName}    Set Variable    infoDir/passosRobo.txt
    Data Register      ${PathFileName}   ${message}    ${tipoKw}
Iniciando o Robo Clashroyale
    ${PathFileName}    Set Variable    infoDir/passosRobo.txt
    ${message}         Set Variable    '=== Relatório do passos do ROBO: ============================================='
    ${tipoKw}          Set Variable    t
    ${mode}            Set Variable    w
    Data Register      ${PathFileName}   ${message}    ${tipoKw}    ${mode}
    Log To Console    ...
    Registrar         '=== Inicia Tarefa: Iniciando o Robo Clashroyale =============================='  t
    Registrar         'Iniciando o Robo Clashroyale'
    ${StartBot}        Get Datetime Now
    ${StartBot}        Set Variable    'Inicio do Robo: ${StartBot}'
    Registrar          ${StartBot}

Acessar Website Clashroyale
    Registrar    '=== Inicia Tarefa: Acessar Website Clashroyale ==============================='  t
    Registrar    'Abre Navegador'
    Open Browser        about:blank    ${Browser}
    Registrar    'Maximiza Tela do Navegador'
    Maximize Browser Window
    Registrar    'Vai para a URL: ${URL}'
    Go To               ${URL}
Logar Website Clashroyale
    Registrar    '=== Inicia Tarefa: Logar Website Clashroyale ================================='  t
    Registrar    'Aguarda o elemento Menu Login ficar visivel'
    Wait Until Element Is Visible      ${MnuLogin}    30s
    Registrar    'Clica no elemento Menu Login'
    Click Element       ${MnuLogin}
    Registrar    'Aguarda input Email ficar visivel'
    Wait Until Element Is Visible      ${inpEmail}
    Registrar    'Escreve o EMail no campo Email'
    Input Text          ${inpEmail}    rprojetos.ti@hotmail.com
    Registrar    'Escreve a senha no campo senha'
    Input Password      ${inpSenha}    202200202200
    Registrar    'Clica no botão login'
    Click Button        ${BtnLogin}
Acessar Minha Conta Clashroyale
    Registrar    '=== Inicia Tarefa: Acessar Minha Conta Clashroyale ==========================='  t
    Registrar    'Aguarda o DropDown de acesso a My Accout ficar visivel'
    Wait Until Element Is Visible      ${dropUserLogin}
    Registrar    'Clica no DropDown do usuario logado'
    Click Element       ${dropUserLogin}
    Registrar    'Clica no elemento My Account'
    Click Element       ${dropMyAccount}
Criar Nova Chave Clashroyale
    Registrar    '=== Inicia Tarefa: Criar Nova Chave Clashroyale =============================='  t
    Registrar    'Aguarda o botão Create New Key ficar visivel'
    Wait Until Element Is Visible      ${BtnCreatKey}
    Registrar    'Clica no botão Create New Key'
    Click Element       ${BtnCreatKey}
    Registrar    'Obtem o IP externo dinâmicamente'
    ${IP}    Get External Ip
    Registrar    'Aguarda o Campo Key Name ficar visivel'
    Wait Until Element Is Visible      ${KeyName}
    Registrar    'Gera automaticamente um nome para a Key'
    ${nameKeyApi}          Create Name Api
    Registrar    'Insere o nome da key no campo key Name'
    Input Text             ${KeyName}     ${nameKeyApi}
    Registrar    'Insere uma descrição da key no campo Description'
    Input Text             ${KeyDesc}     Realizando a criação de uma key para teste
    Registrar    'Isere no campo Allowed Ip Addresses o ip obtido dinamicamente'
    Input Text             ${KeyIp}       ${IP}
    Registrar    'Clica no botão Create Key'
    Click Button           ${BtnKey}
    ${keysLimit}       Set Variable     xPath://*[@id="content"]/div/div[2]/div/div/section/div/div/div[2]/form/div[4]/div/span[2]
    Registrar    'Aguarda 2 segundos para verificar se vai dar tudo certo com a criação da key'
    Sleep    2s
    Registrar    'Seta mensagem a ser Registra, caso a key seja criada com sucesso'
    ${StatusKeyApi}    Set Variable     'A nova chave foi criada com sucesso, para ser utilizada'
    Registrar    'Seta essa mensagem para uso global, para que essa variavel seja utilizada por outra key'
    Set Global Variable    ${StatusKeyApi}
    Registrar    'Verifica se existe uma mensagem de limite do numero de keys criadas atingidas'
    ${IsKeyLimit}=   Run Keyword And Return Status    Element Should Be Visible   ${keysLimit}
    Registrar    'Chama a keyword Key Limit, caso o o numero de keys máximo criadas for atingido'
    Run Keyword If    ${IsKeyLimit}    Key Limit
    Registrar    'Log mostrando a mensagem de status de criação da New Key'
    Log               ${StatusKeyApi}

Key Limit
    Registrar    '=== Inicia SubTarefa: Key Limit =============================================='  t
    Registrar    'Aguarda Botão Back To My Keys ficar visivel'
    ${BackKeys}        Set Variable     xPath://*[@id="content"]/div/div[2]/div/div/section/div/div/div[1]/a/span[2]
    Registrar    'Clica no botão Back To My Keys'
    Click Element      ${BackKeys}
    Registrar    'Seta mensagem do numero maximo de keys criadas atingido'
    ${StatusKeyApi}    Set Variable    'Limite n° de chaves criadas excedido, será utilizada a última existente'
    Registrar    'Seta variavel global referente a mensagem do limite de keys criadas atingidas'
    Set Global Variable    ${StatusKeyApi}
    Registrar    'Emite um log de ERROR para essa condição'
    Log    ${StatusKeyApi}    ERROR

*** Keywords ***
Pega Ultima Key Api da Lista
    Registrar    '=== Inicia Tarefa: Pega Ultima Key Api da Lista =============================='  t
    Registrar    'Localiza a ultima key Api da lista'
    ${ElemApiKeyNow}      Set Variable     xPath://*[@id="content"]/div/div[2]/div/div/section[2]/div/div/div[2]/ul/li[last()]/a
    Registrar    'Verifica se o elemento referente a ultima key Api da lista esta visivel'
    Wait Until Element Is Visible          ${ElemApiKeyNow}
    Registrar    'Pega o link desse elemento para acesso a ao token da key Api'
    ${urlTokenApi}=       Get Element Attribute    ${ElemApiKeyNow}    href
    Registrar    'Log com o link da token Key Api'
    Log    ${urlTokenApi}
    Registrar    'Vai para a url/link da token key Api'
    Go To                 ${urlTokenApi}
Pega o Token de Autorizacao de Acesso a Api Clashroyale
    Registrar    '=== Inicia Tarefa: Pega o Token de Autorizacao de Acesso a Api Clashroyale ==='  t
    Registrar    'Aguarda painel com o Token ficar visivel'
    ${boxTokenApi}         Set Variable     xPath://*[@id="content"]/div/div[2]/div/div/section/div/div/div[2]/form/div[1]/div/samp
    Wait Until Element Is Visible           ${boxTokenApi}
    Registrar    'Captura o Token do painel'
    ${TokenApi}            Get Text         ${boxTokenApi}
    Registrar    'Seta a variavel token como global para ser usada por outras keys'
    Set Global Variable    ${TokenApi}
    Registrar    'Mensagem de log com o valor do Token'
    Log                    ${TokenApi}
    Registrar    'Mensagem para o console com o valor do Token'
    Log To Console         ${TokenApi}

Obtem Informacoes do Clan
    Registrar    '=== Inicia Tarefa: Obtem Informacoes do Clan ================================='  t
    Registrar    'Mensagem de log com o token confirmando a visualização do token na variavel global'
    Log                ${TokenApi}
    Registrar    'Executando a keyword/Custom Library <Search Clan By Name>'
    ${InfoClan}        Search Clan By Name          ${TokenApi}   'The Resistance'   '#9V2Y'   'BR'
    Registrar    'Log do dicionario que contem todas as informações do Clan escolhido'
    Log                ${InfoClan}
Obtem Informacoes Gerais dos Membros do Clan
    Registrar    '=== Inicia Tarefa: Obtem Informacoes Gerais dos Membros do Clan =============='  t
    Registrar    'Executando a keyword/Custom Library <Get Info Members>'
    ${infoMembers}     Get Info Members             ${TokenApi}   'The Resistance'   '#9V2Y'   'BR'
    Registrar    'Log da Lista formada por dicionarios com todas informações de membros do Clan'
    Log                ${infoMembers}
Obtem Lista de TAG e NOME dos Membros do Clan
    Registrar    '=== Inicia Tarefa: Obtem Lista de TAG e NOME dos Membros do Clan ============='  t
    Registrar    'Executando a keyword/Custom Library <Get List Tag Name Members>'
    ${ListMembers}     Get List Tag Name Members    ${TokenApi}   'The Resistance'   '#9V2Y'   'BR'
    Registrar    'Log da Lista formada por Listas com a tag e o nome dos membros do Clan'
    Log                ${ListMembers}
Grava Arquivo CSV com Informacoes dos Membros do Clan
    Registrar    '=== Inicia Tarefa: Grava Arquivo CSV com Informacoes dos Membros do Clan ====='  t
    Registrar    'Seta variavel com o diretorio/arquivo.csv'
    ${PathFileName}    Set Variable            infoDir/testInfoMembers.csv
    Registrar    'Executando a keyword/Custom Library <Write Info Members To Csv>'
    Write Info Members To Csv    ${TokenApi}   'The Resistance'   '#9V2Y'   'BR'    ${PathFileName}
    Registrar    'Executando a keyword/Custom Library <Get Full Path Csv File>'
    ${FullPathFile}    Get Full Path Csv File    ${CURDIR}    ${PathFileName}
    Registrar    'Variavel com a informação do caminho completo do arquivo csv'
    ${infoCsv}         Set Variable    O caminho completo do csv de informações sobre membros é: ${FullPathFile}
    Registrar    'Log com o caminho completo do arquivo csv'
    Log                ${infoCsv}
Executa Teardown
    Registrar    '=== Inicia Tarefa: Executa Teardown =========================================='  t
    Registrar    'Fim das Tarefas do Robo / Fecha o BROWSER'
    Close Browser


*** Tasks ***
Executar Clashroyale
    Iniciando o Robo Clashroyale
    Acessar Website Clashroyale
    Logar Website Clashroyale
    Acessar Minha Conta Clashroyale
    Criar Nova Chave Clashroyale
    Pega Ultima Key Api da Lista
    Pega o Token de Autorizacao de Acesso a Api Clashroyale
    Obtem Informacoes do Clan
    Obtem Informacoes Gerais dos Membros do Clan
    Obtem Lista de TAG e NOME dos Membros do Clan
    Grava Arquivo CSV com Informacoes dos Membros do Clan
    [Teardown]    Executa Teardown

# robot -d ./result -l debug rpaClashroyale.robot
