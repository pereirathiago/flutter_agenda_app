# Agenda Flutter Mobile

Projeto desenvolvido para a disciplina de **Programação de Dispositivos Móveis** do curso de **Análise e Desenvolvimento de Sistemas** na **UTFPR**.

---

## Descrição do Projeto

Este é um projeto mobile desenvolvido em **Flutter** com o objetivo de **gerenciar compromissos pessoais** em agendas.  
A aplicação permite o **cadastro de usuários, compromissos e locais**, **gerenciamento dos compromissos**, **controle de convidados**, além de **editar, excluir e visualizar essas informações** de maneira prática.  
A interface foi desenvolvida com foco em **simplicidade** e **experiência do usuário**.

---

## Atividades da Equipe

- **Giovanne Ribeiro Mika**: Desenvolvimento do CRUD de compromissos e telas relacionadas, formatação dos campos de datas e validações, documentação do projeto, correção de bugs e participação nos testes.
- **Thiago Pereira**: Gerenciamento de usuários, desenvolvimento do CRUD de usuários e locais, implementações das validações de entrada, desenvolvimento das telas de login, cadastro e homepage (agenda) e componentização dos widgets.
- **Matheus Andreiczuk**: Implementação do sistema de convites e convidados, validações e padronizações relacionadas, criação da tela de visualização de convites recebidos, implementação da dinâmica de confirmação/recusa de convites, correção de bugs e participação nos testes.

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
- **Provider** - Gerenciamento de estado

---

## Bugs Conhecidos

- Ao excluir um compromisso e, em seguida, selecionar a opção para desfazer a exclusão, os convidados previamente associados ao compromisso não são recuperados, resultando na perda dessas informações.
- Compromissos e locais são atualmente compartilhados entre todos os usuários, não sendo filtrados individualmente para que cada usuário visualize apenas os compromissos e locais que criou.
- Após o cadastro de um novo compromisso, sua exibição no calendário dinâmico depende de uma interação manual do usuário na tela (como rolar ou navegar), para que a lista de compromissos seja atualizada e o novo compromisso apareça.
- O sistema ainda não está configurado para o fuso horário brasileiro (-3 GMT), podendo gerar inconsistências nos horários exibidos.

---

## Funcionalidades Faltantes

- A foto de perfil do usuário ainda não é alterável, permanecendo fixa após o cadastro inicial.
- Inclusão de um campo do tipo **SELECT** na tela de criação de compromisso, permitindo a seleção dos locais cadastrados, evitando a necessidade de digitação manual do local.
- Inclusão de um campo do tipo **SELECT** na tela de edição de compromisso, na funcionalidade de convite de participantes, permitindo escolher o usuário a ser convidado sem a necessidade de digitar manualmente o identificador ou nome.

---

## Licença

Este projeto está sob a licença **MIT**. Consulte o arquivo [LICENSE](LICENSE) para mais informações.

---

## Autores

- **Giovanne Ribeiro Mika** - [GitHub](https://github.com/GiovanneMika)
- **Thiago Pereira** - [GitHub](https://github.com/pereirathiago)
- **Matheus Andreiczuk** - [GitHub](https://github.com/MatheusAndreiczuk)

---
