# Itens necessários
- Instalação do Python e adicioná-lo ao Path
- Instalação do Robot Framework
- Plugin (Robot Framework Language Server) no VS Code (ou o editor de texto desejado)
- Dependências: além do Pyton e do robot, precisa da noje.js [Browser Lib](https://robotframework-browser.org/)
- Instalar e inicializar a [Library Browser](https://robotframework-browser.org/) - ver o item "INSTALLATION"
- `npm install @playwright/test`
- `npx playwright install-deps`

# Sobre o curso
- Library: Browser que utiliza o *Playwright* para interagir com elementos de uma página *web*
- Exacutar os testes na *CI do GitHub Actions*

## Playwright
- Framework (assim como o Cypress) da Microsoft que permite testes e2e para aplicativos web
- Da pra simular teste em navegador móvel
- **Evidências nativas com trace da execução, vídeos e screenshots**
- *trace*: https://trace.playwright.dev/ --> arrasta nele o arquivo zip que o robot gera na execução e vê detalhadamente os passos que foram feitos na execução dos testes
- É possível simular vários usuários usando vários contextos de navegadores, várias guias...
- Permite salvar e reutilizar contextos -> configurações --> ***Storage***
- Já tem esperas automáticas, por isso não precisamos usar KW com "Wait" como na Selenium, porém essa KW existe, pode ser usada e possui vários "states", como por exemplo "visible", assim, `Wait Until Element Is Visible` é o mesmo que `Wait For Elements State    selector`

## Playwright x Selenium
- Selenium: precisa dos drives dos navegadores para realizar os testes
- Playwright: conexão websocket direta com os navegadores, sendo mais rápido em execução

## Library Browser
- usa a tecnologia do Playwright (JavaScript)
- Flaky tests (intermitência) são reduzidos e a confiança da automação aumenta

## Library Faker
- utilizada para gerar dados randomicos
- `pip install robotframework-faker`

---

**Site automatizado**: https://serverest.dev/

**Rodar o teste**:
- teste específico: `robot -t "Nome do Teste" caminho_do_arquivo_de_teste.robot`
- todos os testes do arquivo: `robot caminho/para/o/seu/arquivo_de_teste.robot`


