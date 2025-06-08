# Manual: Cria\u00e7\u00e3o e Deploy do Docusaurus no GitHub Pages

## Sum\u00e1rio

1. [Introdu\u00e7\u00e3o](#introdu\u00e7\u00e3o)
1. [Pr\u00e9-requisitos](#pr\u00e9-requisitos)
1. [Criando o projeto Docusaurus](#criando-o-projeto-docusaurus)
1. [Configurando para GitHub Pages](#configurando-para-github-pages)
1. [Deploy autom\u00e1tico com GitHub Actions](#deploy-autom\u00e1tico-com-github-actions)
1. [Deploy manual](#deploy-manual)
1. [Configura\u00e7\u00f5es avan\u00e7adas](#configura\u00e7\u00f5es-avan\u00e7adas)
1. [Personalizando a Sidebar](#personalizando-a-sidebar)
1. [Dom\u00ednio personalizado](#dom\u00ednio-personalizado)
1. [Troubleshooting](#troubleshooting)

## Introdu\u00e7\u00e3o

O GitHub Pages \u00e9 uma solu\u00e7\u00e3o gratuita para hospedar sites est\u00e1ticos diretamente de reposit\u00f3rios GitHub. O Docusaurus possui integra\u00e7\u00e3o nativa com GitHub Pages, facilitando o processo de deploy.

## Pr\u00e9-requisitos

Antes de come\u00e7ar, certifique-se de ter:

- Node.js (vers\u00e3o 16.14 ou superior)
- npm ou yarn instalado
- Git instalado
- Conta no GitHub (gratuita)
- Editor de c\u00f3digo (VS Code recomendado)

### Verificando instala\u00e7\u00f5es

```bash
node --version
npm --version
git --version
```

## Criando o projeto Docusaurus

### 1. Criando um novo projeto

```bash
npx create-docusaurus@latest meu-site classic
cd meu-site
```

### 2. Inicializando reposit\u00f3rio Git

```bash
git init
git add .
git commit -m "Commit inicial do Docusaurus"
```

### 3. Criando reposit\u00f3rio no GitHub

1. Acesse [github.com](https://github.com)
1. Clique em \u201cNew repository\u201d
1. Nome do reposit\u00f3rio: `meu-site` (ou o nome desejado)
1. Mantenha p\u00fablico (necess\u00e1rio para GitHub Pages gratuito)
1. **N\u00c3O** inicialize com README (j\u00e1 temos um projeto)
1. Clique em \u201cCreate repository\u201d

### 4. Conectando ao reposit\u00f3rio remoto

```bash
git remote add origin https://github.com/SEU-USUARIO/meu-site.git
git branch -M main
git push -u origin main
```

## Configurando para GitHub Pages

### 1. Configurando docusaurus.config.js

```javascript
const config = {
  title: 'Meu Site de Documenta\u00e7\u00e3o',
  tagline: 'Documenta\u00e7\u00e3o incr\u00edvel no GitHub Pages',
  favicon: 'img/favicon.ico',

  // URL do seu GitHub Pages
  url: 'https://SEU-USUARIO.github.io',
  baseUrl: '/meu-site/', // Nome do seu reposit\u00f3rio

  // Configura\u00e7\u00f5es do GitHub
  organizationName: 'SEU-USUARIO', // Seu username do GitHub
  projectName: 'meu-site', // Nome do reposit\u00f3rio

  // Configura\u00e7\u00f5es de deploy
  deploymentBranch: 'gh-pages',
  trailingSlash: false,

  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',

  i18n: {
    defaultLocale: 'pt',
    locales: ['pt'],
  },

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: require.resolve('./sidebars.js'),
          editUrl: 'https://github.com/SEU-USUARIO/meu-site/tree/main/',
        },
        blog: {
          showReadingTime: true,
          editUrl: 'https://github.com/SEU-USUARIO/meu-site/tree/main/',
        },
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      },
    ],
  ],

  themeConfig: {
    navbar: {
      title: 'Meu Site',
      logo: {
        alt: 'Logo',
        src: 'img/logo.svg',
      },
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'tutorialSidebar',
          position: 'left',
          label: 'Documenta\u00e7\u00e3o',
        },
        {to: '/blog', label: 'Blog', position: 'left'},
        {
          href: 'https://github.com/SEU-USUARIO/meu-site',
          label: 'GitHub',
          position: 'right',
        },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Documenta\u00e7\u00e3o',
          items: [
            {
              label: 'Tutorial',
              to: '/docs/intro',
            },
          ],
        },
        {
          title: 'Comunidade',
          items: [
            {
              label: 'GitHub',
              href: 'https://github.com/SEU-USUARIO/meu-site',
            },
          ],
        },
      ],
      copyright: `Copyright \u00a9 ${new Date().getFullYear()} Meu Projeto. Constru\u00eddo com Docusaurus.`,
    },
  },
};

module.exports = config;
```

### 2. Testando localmente

```bash
npm start
```

Verifique se tudo est\u00e1 funcionando em `http://localhost:3000`

## Deploy autom\u00e1tico com GitHub Actions

### 1. Criando o workflow

Crie a pasta `.github/workflows/` e o arquivo `deploy.yml`:

```bash
mkdir -p .github/workflows
```

### 2. Configurando o arquivo deploy.yml

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches:
      - main
    # Revisar esta configura\u00e7\u00e3o se voc\u00ea usa um branch diferente

jobs:
  deploy:
    name: Deploy to GitHub Pages
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pages: write
      id-token: write
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      
      - uses: actions/setup-node@v4
        with:
          node-version: 18
          cache: npm

      - name: Install dependencies
        run: npm ci

      - name: Build website
        run: npm run build

      - name: Setup Pages
        uses: actions/configure-pages@v4

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./build

      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

### 3. Configurando GitHub Pages no reposit\u00f3rio

1. Acesse seu reposit\u00f3rio no GitHub
1. V\u00e1 em **Settings** \u2192 **Pages**
1. Em **Source**, selecione **GitHub Actions**
1. Salve as configura\u00e7\u00f5es

### 4. Fazendo o primeiro deploy

```bash
git add .
git commit -m "Adiciona GitHub Actions para deploy autom\u00e1tico"
git push origin main
```

O GitHub Actions ir\u00e1:

- Detectar o push para main
- Instalar depend\u00eancias
- Fazer build do site
- Fazer deploy para GitHub Pages

Voc\u00ea pode acompanhar o progresso em **Actions** no seu reposit\u00f3rio.

## Deploy manual

### 1. Usando o comando deploy do Docusaurus

Adicione suas credenciais Git (se necess\u00e1rio):

```bash
git config --global user.email "seu-email@example.com"
git config --global user.name "Seu Nome"
```

Configure a vari\u00e1vel de ambiente (opcional):

```bash
# Linux/macOS
export GIT_USER=SEU-USUARIO

# Windows
set GIT_USER=SEU-USUARIO
```

Execute o deploy:

```bash
npm run deploy
```

### 2. Deploy manual com build

Se preferir controle total:

```bash
# 1. Fazer build
npm run build

# 2. Navegar para a pasta build
cd build

# 3. Inicializar Git na pasta build
git init
git add -A
git commit -m "Deploy do site"

# 4. Fazer push para branch gh-pages
git push -f https://github.com/SEU-USUARIO/meu-site.git main:gh-pages

# 5. Voltar para pasta principal
cd ..
```

## Configura\u00e7\u00f5es avan\u00e7adas

### 1. Configurando multiple ambientes

Crie arquivos de configura\u00e7\u00e3o espec\u00edficos:

#### docusaurus.config.dev.js

```javascript
const config = require('./docusaurus.config.js');

module.exports = {
  ...config,
  url: 'http://localhost',
  baseUrl: '/',
};
```

#### docusaurus.config.prod.js

```javascript
const config = require('./docusaurus.config.js');

module.exports = {
  ...config,
  url: 'https://SEU-USUARIO.github.io',
  baseUrl: '/meu-site/',
};
```

#### package.json

```json
{
  "scripts": {
    "start": "docusaurus start --config docusaurus.config.dev.js",
    "build": "docusaurus build --config docusaurus.config.prod.js",
    "build:dev": "docusaurus build --config docusaurus.config.dev.js",
    "deploy": "docusaurus deploy --config docusaurus.config.prod.js"
  }
}
```

### 2. Otimiza\u00e7\u00f5es para produ\u00e7\u00e3o

#### Minifica\u00e7\u00e3o e compress\u00e3o

```javascript
// docusaurus.config.js
module.exports = {
  future: {
    experimental_faster: true,
  },
  webpack: {
    jsLoader: (isServer) => ({
      loader: require.resolve('swc-loader'),
      options: {
        jsc: {
          parser: {
            syntax: 'typescript',
            tsx: true,
          },
          target: 'es2017',
        },
        module: {
          type: isServer ? 'commonjs' : 'es6',
        },
      },
    }),
  },
};
```

#### PWA (Progressive Web App)

```bash
npm install @docusaurus/plugin-pwa
```

```javascript
// docusaurus.config.js
module.exports = {
  plugins: [
    [
      '@docusaurus/plugin-pwa',
      {
        debug: true,
        offlineModeActivationStrategies: [
          'appInstalled',
          'standalone',
          'queryString',
        ],
        pwaHead: [
          {
            tagName: 'link',
            rel: 'icon',
            href: '/img/logo.png',
          },
          {
            tagName: 'link',
            rel: 'manifest',
            href: '/manifest.json',
          },
          {
            tagName: 'meta',
            name: 'theme-color',
            content: 'rgb(37, 194, 160)',
          },
        ],
      },
    ],
  ],
};
```

### 3. SEO e Analytics

#### Google Analytics

```javascript
// docusaurus.config.js
module.exports = {
  presets: [
    [
      'classic',
      {
        gtag: {
          trackingID: 'G-XXXXXXXXXX',
          anonymizeIP: true,
        },
      },
    ],
  ],
};
```

#### Meta tags personalizadas

```javascript
// docusaurus.config.js
module.exports = {
  themeConfig: {
    metadata: [
      {name: 'keywords', content: 'documenta\u00e7\u00e3o, tutorial, guia, github pages'},
      {name: 'description', content: 'Documenta\u00e7\u00e3o completa hospedada no GitHub Pages'},
      {property: 'og:image', content: 'https://SEU-USUARIO.github.io/meu-site/img/og-image.png'},
    ],
  },
};
```

### 4. Workflow avan\u00e7ado com cache

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 18
          cache: npm

      - name: Install dependencies
        run: npm ci

      - name: Test build website
        run: npm run build

  deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    permissions:
      contents: read
      pages: write
      id-token: write
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 18
          cache: npm

      - name: Install dependencies
        run: npm ci

      - name: Build website
        run: npm run build

      - name: Setup Pages
        uses: actions/configure-pages@v4

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./build

      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

## Personalizando a Sidebar

Para modificar os links e se\u00e7\u00f5es que aparecem na navega\u00e7\u00e3o lateral do Docusaurus, edite o arquivo `sidebars.js` na raiz do projeto. Esse arquivo define a hierarquia de documentos e categorias exibidos.

```javascript
// sidebars.js
module.exports = {
  tutorialSidebar: [
    'intro',
    {
      type: 'category',
      label: 'Tutoriais',
      collapsed: false,
      items: [
        'tutorial-basico',
        'tutorial-avancado',
      ],
    },
  ],
};
```

- **label**: texto exibido na sidebar.
- **collapsed**: define se a categoria inicia aberta ou fechada.
- **items**: documentos ou subcategorias inclusos.

Ap\u00f3s salvar o arquivo, execute `npm start` para conferir a nova estrutura. Para mais exemplos, consulte a [documenta\u00e7\u00e3o oficial](https://docusaurus.io/docs/sidebar).

## Dom\u00ednio personalizado

### 1. Configurando dom\u00ednio pr\u00f3prio

Se voc\u00ea tem um dom\u00ednio pr\u00f3prio:

#### Crie arquivo CNAME

Na pasta `static/`, crie o arquivo `CNAME`:

```
meusite.com
```

#### Configure o DNS

No seu provedor de dom\u00ednio, configure:

```
Type: CNAME
Name: www
Value: SEU-USUARIO.github.io

Type: A
Name: @
Value: 185.199.108.153
Value: 185.199.109.153
Value: 185.199.110.153
Value: 185.199.111.153
```

#### Atualize docusaurus.config.js

```javascript
module.exports = {
  url: 'https://meusite.com',
  baseUrl: '/',
  // ... resto da configura\u00e7\u00e3o
};
```

### 2. Configurando HTTPS

No GitHub:

1. **Settings** \u2192 **Pages**
1. Em **Custom domain**, digite seu dom\u00ednio
1. Marque **Enforce HTTPS**

## Troubleshooting

### Problemas comuns e solu\u00e7\u00f5es

#### 1. Erro 404 no GitHub Pages

**Problema**: Site retorna 404 ou p\u00e1gina em branco

**Solu\u00e7\u00f5es**:

```javascript
// Verifique baseUrl no docusaurus.config.js
module.exports = {
  url: 'https://SEU-USUARIO.github.io',
  baseUrl: '/NOME-DO-REPOSITORIO/', // Deve corresponder ao nome do repo
  trailingSlash: false,
};
```

#### 2. GitHub Actions falha

**Problema**: Deploy falha na CI/CD

**Verifica\u00e7\u00f5es**:

1. Verifique permiss\u00f5es em **Settings** \u2192 **Actions** \u2192 **General**
1. Permiss\u00f5es do GITHUB_TOKEN: **Read and write permissions**
1. GitHub Pages deve estar configurado para **GitHub Actions**

#### 3. Links quebrados ap\u00f3s deploy

**Problema**: Links internos n\u00e3o funcionam

**Solu\u00e7\u00e3o**:

```javascript
// Use links relativos
module.exports = {
  onBrokenLinks: 'warn', // Para debug
  onBrokenMarkdownLinks: 'warn',
};
```

```markdown
<!-- Correto -->
[Link para docs](./intro)
[Link para imagem](/img/screenshot.png)

<!-- Incorreto -->
[Link absoluto](https://meusite.com/docs/intro)
```

#### 4. Imagens n\u00e3o carregam

**Problema**: Imagens aparecem quebradas

**Solu\u00e7\u00f5es**:

1. Coloque imagens em `static/img/`
1. Use caminhos corretos:

```markdown
<!-- Correto -->
![Alt text](/img/minha-imagem.png)

<!-- Incorreto -->
![Alt text](../../static/img/minha-imagem.png)
```

#### 5. Cache do browser

**Problema**: Mudan\u00e7as n\u00e3o aparecem

**Solu\u00e7\u00f5es**:

- Force refresh (Ctrl+Shift+R)
- Aguarde propaga\u00e7\u00e3o do CDN (at\u00e9 10 minutos)
- Verifique se o workflow executou com sucesso

### Comandos \u00fateis para debug

```bash
# Testar build local
npm run build
npm run serve

# Verificar configura\u00e7\u00e3o
npx docusaurus --version

# Limpar cache
npm run clear
rm -rf node_modules package-lock.json
npm install

# Debug do GitHub Actions localmente (com act)
npm install -g act
act -j deploy
```

### Verificando logs

#### GitHub Actions

1. Acesse **Actions** no reposit\u00f3rio
1. Clique no workflow que falhou
1. Examine os logs detalhados

#### Docusaurus local

```bash
# Build com logs detalhados
npm run build -- --verbose

# Debug mode
DEBUG=* npm run build
```

## Configura\u00e7\u00f5es de seguran\u00e7a

### 1. Dependabot para atualiza\u00e7\u00f5es

Crie `.github/dependabot.yml`:

```yaml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
    reviewers:
      - "SEU-USUARIO"
    assignees:
      - "SEU-USUARIO"
    commit-message:
      prefix: "npm"
      include: "scope"
```

### 2. Workflow de seguran\u00e7a

```yaml
name: Security Audit

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  schedule:
    - cron: '0 2 * * 1' # Segunda-feira \u00e0s 2h

jobs:
  audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 18
          
      - name: Run security audit
        run: npm audit --audit-level moderate
```

## Conclus\u00e3o

Seguindo este manual, voc\u00ea ter\u00e1 um site Docusaurus totalmente funcional no GitHub Pages com:

- \u2705 Deploy autom\u00e1tico via GitHub Actions
- \u2705 Configura\u00e7\u00e3o otimizada para produ\u00e7\u00e3o
- \u2705 SEO e analytics configurados
- \u2705 Dom\u00ednio personalizado (opcional)
- \u2705 Workflows de seguran\u00e7a
- \u2705 Troubleshooting abrangente

### Vantagens do GitHub Pages

- **Gratuito**: Para reposit\u00f3rios p\u00fablicos
- **Autom\u00e1tico**: Deploy via GitHub Actions
- **Confi\u00e1vel**: Infraestrutura do GitHub
- **Integrado**: Funciona perfeitamente com Docusaurus
- **CDN**: Distribui\u00e7\u00e3o global autom\u00e1tica

### Pr\u00f3ximos passos

1. Personalize o conte\u00fado e design
1. Configure analytics e monitoramento
1. Implemente workflows de CI/CD mais avan\u00e7ados
1. Adicione testes automatizados
1. Configure dom\u00ednio personalizado

### Recursos adicionais

- [Documenta\u00e7\u00e3o GitHub Pages](https://docs.github.com/pages)
- [Documenta\u00e7\u00e3o Docusaurus](https://docusaurus.io/)
- [GitHub Actions Marketplace](https://github.com/marketplace)
- [Docusaurus Deploy Guide](https://docusaurus.io/docs/deployment)

