# Agenda Flutter Mobile

Projeto desenvolvido para a disciplina de **Programação de Dispositivos Móveis** do curso de **Análise e Desenvolvimento de Sistemas** na **UTFPR**.

---

## Descrição do Projeto

Este é um projeto mobile desenvolvido em **Flutter** com o objetivo de **gerenciar compromissos pessoais** em agendas.  
A aplicação permite o **cadastro de usuários, compromissos e locais**, **gerenciamento dos compromissos**, **controle de convidados**, além de **editar, excluir e visualizar essas informações** de maneira prática.  
A interface foi desenvolvida com foco em **simplicidade** e **experiência do usuário**.

---

## Atividades da Equipe

- **Giovanne Ribeiro Mika**: Adaptação do CRUD de compromissos para o uso de banco de dados, desenvolvimento do select box de locais no cadastro de compromissos. Adicionou bugs ao projeto.
- **Thiago Pereira**: Adaptação do CRUD de usuários e locais para o uso de banco de dados, autenticação de usuários, correção do bug de compartilhamento de locais, 
implementou alteração de foto de perfil do usuário.
- **Matheus Andreiczuk**: Adaptação do CRUD e lógica de convites/convidados para o uso de banco de dados e implementação de nova funcionalidade de exclusão de convidados, 
correção dos demais bugs anteriormente citados.

---

## Instalação

Para instalar e executar o projeto no ambiente local:

1. Clone o repositório:

    ```bash
    git clone https://github.com/pereirathiago/flutter_agenda_app.git
    ```

2. Acesse o diretório do projeto:

    ```bash
    cd caminho/agenda-flutter-mobile
    ```

3. Instale as dependências com o Flutter:

    ```bash
    flutter pub get
    ```

4. Execute o projeto em um emulador ou dispositivo físico:

    ```bash
    flutter run
    ```

---

## Funcionalidades do Projeto

- Cadastro e autenticação de usuários
- CRUD de compromissos
- Gerenciamento de locais
- Envio e controle de convites para compromissos
- Interface acessível e moderna

---

## Tecnologias Utilizadas

- **Flutter** - Framework para desenvolvimento mobile
- **Dart** - Linguagem principal da aplicação
- **SQLite** - Banco de dados local
- **Firebase** - Auth de usuarios

---

## Bugs Conhecidos

- Após o cadastro de um novo compromisso, sua exibição no calendário dinâmico depende de uma interação manual do usuário na tela (como rolar ou navegar), para que a lista de compromissos seja atualizada e o novo compromisso apareça.
- O sistema ainda não está configurado para o fuso horário brasileiro (-3 GMT), podendo gerar inconsistências nos horários exibidos.
- A lista de compromissos pode não aparecer instantaneamente, sendo necessário aguardar um pouco ou trocar de tela e voltar.

---

## Funcionalidades Faltantes

- Não há

---

## Licença

Este projeto está sob a licença **MIT**. Consulte o arquivo [LICENSE](LICENSE) para mais informações.

--- 

## Autores

- **Giovanne Ribeiro Mika** - [GitHub](https://github.com/GiovanneMika)
- **Thiago Pereira** - [GitHub](https://github.com/pereirathiago)
- **Matheus Andreiczuk** - [GitHub](https://github.com/MatheusAndreiczuk)

---
