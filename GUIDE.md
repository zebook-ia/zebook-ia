# Guia de Setup e Deploy do Blog Jekyll com Tema Chirpy

Este documento orienta a configurar, personalizar e publicar um blog Jekyll baseado no tema **Chirpy**. As instruções incluem comandos prontos para uso, trechos de SASS/CSS e scripts de automação.

## Índice
1. [Instalação e Setup Inicial](#1-instalacao-e-setup-inicial)
2. [Personalização de Cores](#2-personalizacao-de-cores)
3. [Configuração do GitHub Pages](#3-configuracao-do-github-pages)
4. [Deploy via GitHub CLI](#4-deploy-via-github-cli)
5. [Manutenção e Atualizações](#5-manutencao-e-atualizacoes)
6. [Checklist de Etapas](#6-checklist-de-etapas)
7. [Troubleshooting](#7-troubleshooting)

---

## 1. Instalação e Setup Inicial

### 1.1 Pré-requisitos
- **Ruby** (>= 2.7)
- **Bundler**
- **Node.js** (>= 14)
- **Git**
- **GitHub CLI** (`gh`)

### 1.2 Instalação das dependências (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install ruby-full build-essential zlib1g-dev nodejs npm git curl -y
sudo gem install bundler
```
Instale o GitHub CLI conforme a [documentação oficial](https://github.com/cli/cli#installation):
```bash
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg |\
  sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
  sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh -y
```

### 1.3 Fork e Clone do Repositório Chirpy
1. Acesse [https://github.com/cotes2020/jekyll-theme-chirpy](https://github.com/cotes2020/jekyll-theme-chirpy) e clique em **Fork**.
2. Clone seu fork:
```bash
git clone https://github.com/SEU_USUARIO/jekyll-theme-chirpy.git my-blog
cd my-blog
```

### 1.4 Configuração Inicial do `_config.yml`
Edite o arquivo `_config.yml` e ajuste:
```yaml
url: "https://SEU_USUARIO.github.io"
baseurl: ""
title: "Meu Blog"
author:
  name: "Seu Nome"
  email: "seu@email.com"
```

### 1.5 Setup do Ambiente de Desenvolvimento Local
Instale as dependências Ruby e Node:
```bash
bundle install
npm install
```

### 1.6 Testar o Site Localmente
Execute o servidor Jekyll em modo de desenvolvimento:
```bash
bundle exec jekyll s --watch
```
Acesse `http://localhost:4000` no navegador para visualizar o blog.

---

## 2. Personalização de Cores

Crie ou edite `assets/css/custom.scss` para sobrescrever as variáveis do tema utilizando CSS custom properties.

```scss
/* Variáveis personalizadas */
:root {
  /* Fundo principal */
  --color-bg: #000033; /* azul marinho escuro */
  /* Texto principal */
  --color-text: #808080; /* cinza médio */
  /* Títulos */
  --color-heading: #B0B0B0; /* cinza claro */
}

/* Navbar e sidebar */
.navbar, .sidebar {
  background-color: var(--color-bg);
  color: var(--color-text);
}

/* Cards e containers de conteúdo */
.card {
  background-color: var(--color-bg);
  color: var(--color-text);
  border-color: var(--color-heading);
}

/* Blocos de código */
.highlight {
  background-color: #001122;
  color: var(--color-text);
}

/* Botões e links */
a, .btn {
  color: var(--color-heading);
}
a:hover, .btn:hover {
  color: var(--color-text);
  text-decoration: underline;
}

/* Footer */
footer {
  background-color: var(--color-bg);
  color: var(--color-text);
}
```

### Requisitos de Acessibilidade
- Verifique o contraste das cores usando ferramentas como [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/).
- Garanta que o contraste entre `#000033` e `#808080` seja superior a 4.5:1.
- Todos os botões e links devem ter estados `:hover` visíveis.

---

## 3. Configuração do GitHub Pages

### 3.1 Configurar Repositório no GitHub
1. Crie um repositório vazio em `https://github.com/SEU_USUARIO/SEU_REPO`.
2. Defina o branch padrão como `main`.

### 3.2 GitHub Actions
O Chirpy já inclui um workflow em `.github/workflows/pages-deploy.yml`. Verifique se as variáveis estão configuradas corretamente:
```yaml
on:
  push:
    branches: [main]
```
A ação gerará o site e publicará no branch `gh-pages`.

### 3.3 Domínio Customizado
Caso utilize domínio próprio, crie o arquivo `CNAME` na raiz do repositório com o domínio desejado e configure o DNS apontando para o GitHub Pages.

### 3.4 Variáveis de Ambiente
No GitHub, em **Settings > Secrets and variables > Actions**, adicione as chaves necessárias para workflows (ex.: tokens de deploy, caso utilize scripts personalizados).

---

## 4. Deploy via GitHub CLI

### 4.1 Instalação e Autenticação
Instale o `gh` (veja etapa 1.2) e autentique:
```bash
gh auth login
```
Siga as instruções para autenticar via navegador.

### 4.2 Criar/Configurar Repositório
```bash
gh repo create SEU_USUARIO/SEU_REPO --public -y
```
Faça push do código inicial:
```bash
git remote add origin https://github.com/SEU_USUARIO/SEU_REPO.git
git branch -M main
git push -u origin main
```

### 4.3 Script de Deploy Automatizado
Utilize o script `deploy.sh` (incluído neste repositório) para compilar e fazer push para `gh-pages`:
```bash
bash deploy.sh
```
O script executa `bundle exec jekyll build` e publica o conteúdo da pasta `_site` no branch `gh-pages`.

### 4.4 Atualizar o Site
Edite posts ou configurações e execute novamente:
```bash
bash deploy.sh
```

### 4.5 Troubleshooting
- Verifique mensagens de erro de `jekyll build`.
- Confirme se o token do GitHub possui permissão de push.
- Caso o site não atualize, confira a aba **Actions** no GitHub.

---

## 5. Manutenção e Atualizações

### 5.1 Atualizar o Tema Chirpy
```bash
git submodule update --remote
bundle update
```
### 5.2 Backup das Personalizações
- Mantenha todas as alterações em arquivos separados (ex.: `custom.scss`).
- Realize commit frequentes e armazene em repositório remoto.

### 5.3 Rebuild e Redeploy
```bash
bundle exec jekyll clean
bundle exec jekyll build
bash deploy.sh
```
### 5.4 Monitoramento do Site
- Acompanhe os relatórios da aba **Actions** para verificar falhas.
- Utilize serviços externos para monitorar disponibilidade (ex.: UptimeRobot).

---

## 6. Checklist de Etapas
- [ ] Instalar Ruby, Bundler, Node.js e GitHub CLI
- [ ] Fazer fork do repositório Chirpy
- [ ] Configurar `_config.yml`
- [ ] Instalar dependências com `bundle install` e `npm install`
- [ ] Testar localmente com `bundle exec jekyll s`
- [ ] Personalizar `custom.scss` conforme desejado
- [ ] Configurar repositório e GitHub Actions
- [ ] Executar `bash deploy.sh`
- [ ] Verificar publicação em `https://SEU_USUARIO.github.io`

---

## 7. Troubleshooting

| Problema | Possível Solução |
|----------|----------------------|
| **Erro `jekyll build`** | Verifique se todas as dependências estão instaladas e se o `Gemfile` está correto. |
| **Falha no deploy** | Confirme as permissões do token e se o branch `gh-pages` existe. |
| **Cores sem contraste** | Ajuste os valores em `custom.scss` até atingir contraste ≥ 4.5:1. |
| **Links sem `:hover` visível** | Adicione estilos de `:hover` em `custom.scss`. |
| **GitHub Pages não atualiza** | Verifique a página de configurações do repositório e a aba **Actions**. |

---

**Fim do Guia.**
