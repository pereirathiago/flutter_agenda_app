# Agenda Flutter Mobile

Projeto desenvolvido para a disciplina de **Programação de Dispositivos Móveis** do curso de **Análise e Desenvolvimento de Sistemas** na **UTFPR**.

---

## Descrição do Projeto

Este é um projeto mobile desenvolvido em **Flutter** com o objetivo de **gerenciar compromissos pessoais** em agendas.  
A aplicação permite o **cadastro de usuários, compromissos e locais**, **gerenciamento dos compromissos**, **controle de convidados**, além de **editar, excluir e visualizar essas informações** de maneira prática.  
A interface foi desenvolvida com foco em **simplicidade** e **experiência do usuário**.

---

## Atividades da Equipe

- **Giovanne Ribeiro Mika**: Adicionou API para busca de local a partir do CEP. Consertou o bug de fuso horário, além do overflow de pixel na select box de local. Adicionou logo ao app e splash screen.
- **Thiago Pereira**: Função de adicionar foto no perfil, a partir da câmera do dispositivo. Incrementou a tela de compromissos a fim de possibilitar comentários dos participantes. Adicionou alguns componentes de loading necessários para melhor navegação. Possibilitou ao convidado o acesso completo ao compromisso, que pode comentar e ver quem serão os participantes. Consertou bug da visualização de compromissos no calendário, além de consertar o bug de visualização do select de local.
- **Matheus Andreiczuk**: Adicionou função de cadastrar local a partir do GPS do dispositivo. Elaborou visualização do local do compromisso, bem como ver o local do compromisso no qual foi convidado, ambos no google maps.

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
- **MockAPI** - Consumo de rota POST e GET da funcionalidade dos comentários

---

## Bugs Conhecidos

- Não há
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
