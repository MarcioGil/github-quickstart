

# Desafio de Projeto: Simulação de Ataques de Força Bruta com Kali Linux e Medusa

Este repositório documenta a execução de um desafio de projeto da [Digital Innovation One (DIO)](https://web.dio.me), focado em demonstrar a compreensão e aplicação de técnicas de ataque de força bruta em um ambiente de laboratório controlado. O objetivo é utilizar o Kali Linux e a ferramenta Medusa para simular ataques a diferentes serviços em máquinas vulneráveis, como o Metasploitable 2 e o Damn Vulnerable Web Application (DVWA).

## 1. Introdução

Ataques de força bruta representam uma das ameaças mais comuns e persistentes à segurança de sistemas de informação. Consistem em tentativas sistemáticas e exaustivas de adivinhar credenciais de autenticação, como nomes de usuário e senhas, para obter acesso não autorizado a sistemas e serviços. A eficácia desses ataques depende diretamente da complexidade das senhas e das políticas de segurança implementadas.

Este projeto prático visa explorar os mecanismos por trás dos ataques de força bruta, utilizando ferramentas especializadas disponíveis no Kali Linux, como o Medusa. Através da simulação de cenários realistas em ambientes vulneráveis, será possível não apenas compreender a mecânica dos ataques, mas também identificar e propor medidas de mitigação eficazes para proteger os sistemas contra tais ameaças.

### Objetivos de Aprendizagem

- Compreender ataques de força bruta em diferentes serviços (FTP, Web, SMB).
- Utilizar o Kali Linux e o Medusa para auditoria de segurança em ambiente controlado.
- Documentar processos técnicos de forma clara e estruturada.
- Reconhecer vulnerabilidades comuns e propor medidas de mitigação.
- Utilizar o GitHub como portfólio técnico para compartilhar documentação e evidências.

---


## 2. Configuração do Ambiente de Laboratório

Para a realização dos testes de forma segura e isolada, foi configurado um ambiente de laboratório virtualizado utilizando o Oracle VM VirtualBox. Este ambiente consiste em duas máquinas virtuais (VMs) operando em uma rede interna, garantindo que as atividades de pentest não afetem a rede local ou a internet.

### Componentes do Laboratório

| Componente | Descrição |
|---|---|
| **Software de Virtualização** | Oracle VM VirtualBox |
| **Máquina Atacante** | Kali Linux (VM) |
| **Máquina Alvo** | Metasploitable 2 (VM) |
| **Configuração de Rede** | Rede Interna (Host-Only) |

### Máquina Atacante: Kali Linux

O [Kali Linux](https://www.kali.org/) é uma distribuição Linux baseada em Debian, projetada para forense digital e testes de penetração. Ela vem pré-instalada com uma vasta gama de ferramentas de segurança, incluindo o Medusa, que será utilizado neste projeto.

### Máquina Alvo: Metasploitable 2

O [Metasploitable 2](https://docs.rapid7.com/metasploit/metasploitable-2/) é uma máquina virtual Linux intencionalmente vulnerável, criada pela Rapid7. Ela serve como um alvo legal e seguro para praticar habilidades de pentest e testar ferramentas de segurança. Esta VM possui diversos serviços vulneráveis, incluindo FTP, SSH, Telnet e aplicações web como o DVWA.

### Configuração da Rede

Ambas as máquinas virtuais foram configuradas para utilizar uma **Rede Interna (Host-Only)** no VirtualBox. Esta configuração cria uma rede privada entre a máquina hospedeira e as VMs, permitindo que elas se comuniquem entre si, mas isolando-as de redes externas. Isso é crucial para garantir que os ataques simulados fiquem contidos no ambiente de laboratório.

- **Endereço IP do Kali Linux:** `192.168.56.101` (Exemplo)
- **Endereço IP do Metasploitable 2:** `192.168.56.102` (Exemplo)

Após a inicialização das VMs, os endereços IP foram verificados utilizando o comando `ifconfig` em ambos os sistemas.





## 3. Ferramenta Utilizada: Medusa

### O que é o Medusa?

O [Medusa](https://www.kali.org/tools/medusa/) é uma ferramenta de auditoria de login de rede paralela, projetada para ser rápida, massivamente paralela e modular. Desenvolvida por JoMo-Kun da Foofus Networks, o Medusa tem como objetivo suportar o maior número possível de serviços que permitem autenticação remota. É uma ferramenta essencial no arsenal de qualquer profissional de segurança que realiza testes de penetração.

### Características Principais

O Medusa se destaca por suas características únicas que o tornam uma ferramenta poderosa para ataques de força bruta:

- **Testes Paralelos Baseados em Threads**: O Medusa pode realizar testes de força bruta contra múltiplos hosts, usuários ou senhas simultaneamente, aumentando significativamente a velocidade dos ataques.

- **Entrada de Usuário Flexível**: As informações de alvo (host, usuário, senha) podem ser especificadas de várias maneiras. Cada item pode ser uma entrada única ou um arquivo contendo múltiplas entradas, proporcionando grande flexibilidade na configuração dos ataques.

- **Design Modular**: Cada módulo de serviço existe como um arquivo `.mod` independente. Isso significa que não são necessárias modificações no núcleo da aplicação para estender a lista de serviços suportados para força bruta.

### Protocolos Suportados

O Medusa suporta uma ampla variedade de protocolos, incluindo:

- FTP
- SSH
- HTTP/HTTPS
- SMB/SMBNT
- MySQL
- PostgreSQL
- Telnet
- VNC
- RDP
- E muitos outros

### Sintaxe Básica

A sintaxe básica do Medusa é relativamente simples e intuitiva:

```bash
medusa -h [host] -u [username] -P [password_file] -M [module] -t [threads]
```

### Parâmetros Importantes

| Parâmetro | Descrição |
|---|---|
| `-h [TEXT]` | Hostname ou endereço IP do alvo |
| `-H [FILE]` | Arquivo contendo hostnames ou endereços IP |
| `-u [TEXT]` | Nome de usuário para testar |
| `-U [FILE]` | Arquivo contendo nomes de usuário para testar |
| `-p [TEXT]` | Senha para testar |
| `-P [FILE]` | Arquivo contendo senhas para testar |
| `-M [TEXT]` | Nome do módulo a executar (sem extensão .mod) |
| `-n [NUM]` | Número de porta TCP não padrão |
| `-t [NUM]` | Total de logins a serem testados simultaneamente |
| `-f` | Para após encontrar o primeiro usuário/senha válido |
| `-F` | Para após encontrar o primeiro usuário/senha válido em qualquer host |
| `-v [NUM]` | Nível de verbosidade [0-6] |

### Instalação

No Kali Linux, o Medusa geralmente já vem pré-instalado. Caso não esteja, pode ser facilmente instalado através do gerenciador de pacotes APT:

```bash
sudo apt update
sudo apt install medusa
```

Para verificar se o Medusa está instalado corretamente, execute:

```bash
medusa -d
```

Este comando exibirá todos os módulos disponíveis no Medusa.

---

## 4. Cenários de Ataque Simulados

Neste projeto, foram simulados três cenários distintos de ataques de força bruta, cada um focado em um serviço diferente. Os cenários foram projetados para demonstrar a versatilidade do Medusa e a importância de implementar medidas de segurança adequadas em diferentes tipos de serviços.

### 4.1. Ataque de Força Bruta em FTP

O **File Transfer Protocol (FTP)** é um protocolo de rede padrão usado para transferir arquivos entre um cliente e um servidor em uma rede. Apesar de sua idade e das vulnerabilidades conhecidas, o FTP ainda é amplamente utilizado em muitos ambientes.

#### Objetivo

Demonstrar como um atacante pode utilizar o Medusa para tentar adivinhar credenciais de acesso a um servidor FTP, explorando senhas fracas ou padrão.

#### Configuração

- **Alvo**: Serviço FTP no Metasploitable 2 (porta 21)
- **Wordlist de Usuários**: `wordlists/users.txt`
- **Wordlist de Senhas**: `wordlists/passwords.txt`
- **Threads**: 4

#### Comando Utilizado

```bash
medusa -h 192.168.56.102 -U wordlists/users.txt -P wordlists/passwords.txt -M ftp -t 4 -v 6 -f
```

#### Explicação dos Parâmetros

- `-h 192.168.56.102`: Especifica o endereço IP do alvo (Metasploitable 2)
- `-U wordlists/users.txt`: Especifica o arquivo contendo a lista de usuários
- `-P wordlists/passwords.txt`: Especifica o arquivo contendo a lista de senhas
- `-M ftp`: Especifica o módulo FTP
- `-t 4`: Define 4 threads paralelas para o ataque
- `-v 6`: Define o nível de verbosidade máximo (6) para output detalhado
- `-f`: Para o ataque após encontrar a primeira credencial válida

#### Resultado Esperado

O Medusa testará todas as combinações de usuários e senhas das wordlists fornecidas. Quando uma credencial válida for encontrada (por exemplo, `msfadmin:msfadmin`), o Medusa exibirá a mensagem de sucesso e, devido ao parâmetro `-f`, encerrará o ataque.

#### Validação de Acesso

Após obter credenciais válidas, é possível validar o acesso conectando-se ao servidor FTP:

```bash
ftp 192.168.56.102
# Inserir usuário e senha encontrados
```

#### Script Automatizado

Um script bash foi criado para automatizar este processo: `scripts/ftp_bruteforce.sh`

```bash
cd scripts
./ftp_bruteforce.sh 192.168.56.102
```

---

### 4.2. Ataque de Força Bruta em Formulário Web (DVWA)

O **Damn Vulnerable Web Application (DVWA)** é uma aplicação web PHP/MySQL intencionalmente vulnerável. Ela contém diversos tipos de vulnerabilidades web comuns, incluindo formulários de login vulneráveis a ataques de força bruta.

#### Objetivo

Demonstrar como automatizar tentativas de login em um formulário web utilizando o Medusa, explorando a ausência de mecanismos de proteção como CAPTCHA ou limitação de tentativas.

#### Configuração

- **Alvo**: DVWA hospedado no Metasploitable 2
- **URL**: `http://192.168.56.102/dvwa/login.php`
- **Nível de Segurança**: Baixo (Low)
- **Wordlist de Usuários**: `wordlists/users.txt`
- **Wordlist de Senhas**: `wordlists/passwords.txt`

#### Comando Utilizado

```bash
medusa -h 192.168.56.102 -U wordlists/users.txt -P wordlists/passwords.txt \
       -M web-form -m FORM:"/dvwa/login.php" -m FORM-DATA:"username=&password=&Login=Login" \
       -m DENY-SIGNAL:"Login failed" -t 4 -v 6 -f
```

#### Explicação dos Parâmetros

- `-M web-form`: Especifica o módulo de formulário web
- `-m FORM:"/dvwa/login.php"`: Especifica o caminho do formulário de login
- `-m FORM-DATA:"username=&password=&Login=Login"`: Especifica os campos do formulário
- `-m DENY-SIGNAL:"Login failed"`: Especifica a mensagem que indica falha no login
- Demais parâmetros são similares ao exemplo anterior

**Nota**: A sintaxe exata pode variar dependendo da estrutura do formulário DVWA. Pode ser necessário ajustar os parâmetros após inspecionar o código HTML do formulário.

#### Alternativa: Usando o Hydra

Para ataques em formulários web, o **Hydra** pode ser mais adequado que o Medusa. Exemplo:

```bash
hydra -L wordlists/users.txt -P wordlists/passwords.txt \
      192.168.56.102 http-post-form \
      "/dvwa/login.php:username=^USER^&password=^PASS^&Login=Login:Login failed"
```

#### Validação de Acesso

Após obter credenciais válidas (geralmente `admin:password` no DVWA), acesse a aplicação através do navegador e faça login.

---

### 4.3. Password Spraying em SMB com Enumeração de Usuários

O **Server Message Block (SMB)** é um protocolo de compartilhamento de arquivos em rede amplamente utilizado em ambientes Windows. O **password spraying** é uma técnica de ataque que tenta uma senha comum em múltiplas contas de usuário, ao invés de tentar múltiplas senhas em uma única conta.

#### Objetivo

Demonstrar a técnica de password spraying em um serviço SMB, combinada com enumeração de usuários, para evitar bloqueios de conta.

#### Enumeração de Usuários

Antes de realizar o password spraying, é importante enumerar os usuários válidos no sistema alvo. Ferramentas como `enum4linux` ou `nmap` podem ser utilizadas:

```bash
enum4linux -U 192.168.56.102
```

Ou usando o Nmap:

```bash
nmap --script smb-enum-users.nse -p 445 192.168.56.102
```

#### Configuração

- **Alvo**: Serviço SMB no Metasploitable 2 (porta 445)
- **Usuários Enumerados**: Salvos em `wordlists/smb_users.txt`
- **Senha Comum**: `password123` (ou uma wordlist reduzida)
- **Threads**: 2 (para evitar sobrecarga e detecção)

#### Comando Utilizado

```bash
medusa -h 192.168.56.102 -U wordlists/smb_users.txt -p password123 -M smbnt -t 2 -v 6 -f
```

#### Explicação da Técnica

Ao invés de testar múltiplas senhas para cada usuário (o que pode causar bloqueio de conta), o password spraying testa uma única senha (ou um conjunto muito pequeno de senhas comuns) em todos os usuários. Isso reduz significativamente o risco de bloqueio de contas e pode passar despercebido por sistemas de detecção de intrusão.

#### Validação de Acesso

Se uma credencial válida for encontrada, é possível validar o acesso utilizando ferramentas como `smbclient`:

```bash
smbclient -L 192.168.56.102 -U username%password
```

#### Script Automatizado

Um script bash foi criado para automatizar este processo: `scripts/smb_bruteforce.sh`

```bash
cd scripts
./smb_bruteforce.sh 192.168.56.102
```

---

## 5. Wordlists Utilizadas

As wordlists são componentes essenciais em ataques de força bruta. Elas contêm listas de possíveis usuários e senhas que serão testados contra o alvo. Para este projeto, foram criadas wordlists simples para fins educacionais.

### Wordlist de Usuários (`wordlists/users.txt`)

Contém nomes de usuário comuns e padrão que frequentemente existem em sistemas vulneráveis:

```
admin
root
user
msfadmin
administrator
guest
test
postgres
mysql
ftp
```

### Wordlist de Senhas (`wordlists/passwords.txt`)

Contém senhas comuns, fracas e padrão que são frequentemente utilizadas:

```
123456
password
12345678
qwerty
123456789
12345
1234
111111
1234567
dragon
123123
baseball
iloveyou
trustno1
1234567890
sunshine
master
welcome
shadow
ashley
football
jesus
michael
ninja
mustang
password1
msfadmin
admin
root
toor
letmein
```

### Wordlists Profissionais

Para testes mais abrangentes, existem wordlists profissionais disponíveis:

- **RockYou**: Uma das wordlists mais famosas, contendo milhões de senhas reais vazadas.
  - Localização no Kali Linux: `/usr/share/wordlists/rockyou.txt.gz`
  - Descompactar: `gunzip /usr/share/wordlists/rockyou.txt.gz`

- **SecLists**: Coleção abrangente de wordlists para diversos tipos de testes de segurança.
  - Instalação: `sudo apt install seclists`
  - Localização: `/usr/share/seclists/`

---

## 6. Medidas de Mitigação e Recomendações de Segurança

Após compreender como os ataques de força bruta funcionam, é fundamental implementar medidas de mitigação para proteger os sistemas contra tais ameaças. A seguir, são apresentadas as principais recomendações de segurança.

### 6.1. Políticas de Senha Forte

A primeira linha de defesa contra ataques de força bruta é a implementação de políticas de senha robustas.

**Recomendações**:

- **Comprimento Mínimo**: Exigir senhas com no mínimo 12-16 caracteres.
- **Complexidade**: Combinar letras maiúsculas, minúsculas, números e caracteres especiais.
- **Evitar Palavras de Dicionário**: Não utilizar palavras comuns ou informações pessoais.
- **Não Reutilizar Senhas**: Cada serviço deve ter uma senha única.
- **Verificação contra Senhas Vazadas**: Utilizar serviços como [Have I Been Pwned](https://haveibeenpwned.com/) para verificar se senhas foram comprometidas.

### 6.2. Autenticação Multifator (MFA/2FA)

A autenticação multifator adiciona uma camada extra de segurança, exigindo que o usuário forneça dois ou mais fatores de verificação.

**Tipos de MFA**:

- **SMS/Token**: Código enviado via SMS ou gerado por aplicativo autenticador.
- **Aplicativos Autenticadores**: Google Authenticator, Microsoft Authenticator, Authy.
- **Biometria**: Impressão digital, reconhecimento facial.
- **Chaves de Segurança Físicas**: YubiKey, Titan Security Key.

**Benefícios**:

Mesmo que um atacante consiga obter a senha através de força bruta, ele ainda precisará do segundo fator para acessar o sistema, tornando o ataque significativamente mais difícil.

### 6.3. Limitação de Tentativas de Login

Implementar mecanismos que limitem o número de tentativas de login falhadas pode desacelerar ou impedir ataques de força bruta.

**Estratégias**:

- **Bloqueio Temporário de Conta**: Bloquear a conta após um número definido de tentativas falhadas (ex: 5 tentativas).
- **Delays Progressivos**: Aumentar o tempo de espera entre tentativas após cada falha.
- **CAPTCHA**: Exigir resolução de CAPTCHA após algumas tentativas falhadas.

**Considerações**:

É importante balancear segurança com usabilidade. Bloqueios muito agressivos podem resultar em negação de serviço (DoS) para usuários legítimos ou serem explorados por atacantes para bloquear contas de forma maliciosa.

### 6.4. Bloqueio de Endereços IP

Bloquear endereços IP que apresentam comportamento suspeito pode ajudar a mitigar ataques de força bruta.

**Implementação**:

- **Fail2Ban**: Ferramenta que monitora logs de serviços e bloqueia IPs com múltiplas tentativas falhadas.
  ```bash
  sudo apt install fail2ban
  sudo systemctl enable fail2ban
  sudo systemctl start fail2ban
  ```

- **Configuração de Firewall**: Utilizar iptables ou ufw para bloquear IPs manualmente ou através de scripts automatizados.

**Limitações**:

Atacantes podem contornar bloqueios de IP utilizando proxies rotativos, VPNs ou botnets distribuídas.

### 6.5. Monitoramento e Detecção de Intrusão

Implementar sistemas de monitoramento e detecção de intrusão (IDS/IPS) permite identificar e responder rapidamente a ataques em andamento.

**Ferramentas**:

- **Snort**: Sistema de detecção de intrusão de código aberto.
- **Suricata**: IDS/IPS de alto desempenho.
- **OSSEC**: Sistema de detecção de intrusão baseado em host (HIDS).

**Ações**:

- Monitorar logs de autenticação em tempo real.
- Configurar alertas para padrões anormais de tentativas de login.
- Analisar regularmente logs para identificar atividades suspeitas.

### 6.6. Desabilitar Serviços Desnecessários

Serviços que não são utilizados devem ser desabilitados para reduzir a superfície de ataque.

**Exemplos**:

- Se o FTP não é necessário, desabilite o serviço:
  ```bash
  sudo systemctl stop vsftpd
  sudo systemctl disable vsftpd
  ```

- Utilize protocolos mais seguros como SFTP (SSH File Transfer Protocol) ao invés de FTP.

### 6.7. Atualização e Patch Management

Manter sistemas e aplicações atualizados é crucial para proteger contra vulnerabilidades conhecidas.

**Práticas**:

- Aplicar patches de segurança regularmente.
- Configurar atualizações automáticas quando apropriado.
- Monitorar boletins de segurança de fornecedores.

### 6.8. Educação e Conscientização de Usuários

Usuários são frequentemente o elo mais fraco na cadeia de segurança. Educar e conscientizar usuários sobre boas práticas de segurança é essencial.

**Tópicos**:

- Importância de senhas fortes e únicas.
- Reconhecimento de tentativas de phishing.
- Habilitação de autenticação multifator.
- Não compartilhar credenciais.

### 6.9. Implementação de CAPTCHA

CAPTCHA (Completely Automated Public Turing test to tell Computers and Humans Apart) pode ser utilizado para diferenciar humanos de bots automatizados.

**Implementação**:

- Exigir CAPTCHA após algumas tentativas de login falhadas.
- Utilizar reCAPTCHA v3 para uma experiência mais transparente.

### 6.10. Rate Limiting

Implementar rate limiting para limitar o número de requisições que um IP ou usuário pode fazer em um determinado período de tempo.

**Benefícios**:

- Desacelera ataques de força bruta.
- Reduz a carga no servidor.
- Dificulta automação de ataques.

---

## 7. Considerações Éticas e Legais

É de extrema importância ressaltar que os ataques de força bruta e outras técnicas de pentest devem ser realizados **apenas em ambientes controlados e com autorização explícita**. O uso não autorizado dessas técnicas é **ilegal** e pode resultar em sérias consequências legais.

### Aspectos Legais

- **Lei de Crimes Cibernéticos**: No Brasil, a Lei nº 12.737/2012 (conhecida como "Lei Carolina Dieckmann") tipifica crimes cibernéticos, incluindo invasão de dispositivos informáticos.
- **Autorização**: Sempre obtenha autorização por escrito antes de realizar testes de penetração em sistemas que não sejam de sua propriedade.
- **Escopo Definido**: Defina claramente o escopo dos testes e não exceda os limites acordados.

### Ética Profissional

- **Confidencialidade**: Mantenha a confidencialidade de todas as informações obtidas durante os testes.
- **Responsabilidade**: Reporte todas as vulnerabilidades encontradas de forma responsável.
- **Não Causar Danos**: Evite causar danos aos sistemas testados.

### Ambientes de Teste Legais

Para praticar habilidades de pentest de forma legal, utilize:

- **Máquinas Virtuais Vulneráveis**: Metasploitable, DVWA, WebGoat, HackTheBox, TryHackMe.
- **Laboratórios Pessoais**: Configure seu próprio ambiente de laboratório isolado.
- **Programas de Bug Bounty**: Participe de programas legítimos de bug bounty onde empresas autorizam testes em seus sistemas.

---

## 8. Estrutura do Repositório

```
desafio-brute-force/
├── README.md                    # Documentação principal do projeto
├── wordlists/                   # Diretório contendo wordlists
│   ├── users.txt                # Lista de usuários comuns
│   └── passwords.txt            # Lista de senhas comuns
├── scripts/                     # Scripts automatizados para ataques
│   ├── ftp_bruteforce.sh        # Script para ataque FTP
│   ├── ssh_bruteforce.sh        # Script para ataque SSH
│   └── smb_bruteforce.sh        # Script para ataque SMB
├── images/                      # Capturas de tela e imagens
│   └── (screenshots dos testes)
└── docs/                        # Documentação adicional
    └── (documentos complementares)
```

---

## 9. Como Utilizar Este Repositório

### Pré-requisitos

- Kali Linux instalado (máquina física ou virtual)
- Metasploitable 2 instalado e configurado
- VirtualBox ou VMWare para virtualização
- Conhecimentos básicos de Linux e redes

### Passo a Passo

1. **Clone o Repositório**:
   ```bash
   git clone https://github.com/MarcioGil/github-quickstart.git
   cd github-quickstart/desafio-brute-force
   ```

2. **Configure o Ambiente**:
   - Configure as VMs (Kali Linux e Metasploitable 2) em rede interna.
   - Verifique os endereços IP com `ifconfig`.

3. **Execute os Scripts**:
   ```bash
   cd scripts
   ./ftp_bruteforce.sh <IP_DO_ALVO>
   ./ssh_bruteforce.sh <IP_DO_ALVO>
   ./smb_bruteforce.sh <IP_DO_ALVO>
   ```

4. **Analise os Resultados**:
   - Observe os outputs dos scripts.
   - Valide as credenciais encontradas.

5. **Documente Suas Descobertas**:
   - Adicione capturas de tela em `images/`.
   - Documente suas observações e aprendizados.

---

## 10. Conclusão

Este projeto demonstrou de forma prática como ataques de força bruta podem ser realizados utilizando o Kali Linux e a ferramenta Medusa em ambientes vulneráveis controlados. Através da simulação de cenários realistas em serviços como FTP, aplicações web (DVWA) e SMB, foi possível compreender não apenas a mecânica dos ataques, mas também a importância crítica de implementar medidas de segurança robustas.

As principais lições aprendidas incluem:

- **Vulnerabilidade de Senhas Fracas**: Senhas simples e padrão podem ser quebradas em questão de minutos ou até segundos.
- **Importância da Autenticação Multifator**: MFA adiciona uma camada essencial de segurança que torna ataques de força bruta significativamente mais difíceis.
- **Necessidade de Monitoramento**: Sistemas de detecção e monitoramento são cruciais para identificar e responder a ataques em tempo real.
- **Defesa em Profundidade**: Nenhuma medida de segurança única é perfeita; uma abordagem em camadas é essencial.

Este conhecimento é fundamental para profissionais de segurança da informação, desenvolvedores e administradores de sistemas, permitindo que implementem defesas eficazes e protejam seus sistemas contra ameaças reais.

---

## 11. Referências

1. Kali Linux - Site Oficial. Disponível em: [https://www.kali.org/](https://www.kali.org/)
2. Medusa - Kali Linux Tools. Disponível em: [https://www.kali.org/tools/medusa/](https://www.kali.org/tools/medusa/)
3. Metasploitable 2 - Rapid7 Documentation. Disponível em: [https://docs.rapid7.com/metasploit/metasploitable-2/](https://docs.rapid7.com/metasploit/metasploitable-2/)
4. DVWA - Damn Vulnerable Web Application. Disponível em: [https://github.com/digininja/DVWA](https://github.com/digininja/DVWA)
5. OWASP - Blocking Brute Force Attacks. Disponível em: [https://owasp.org/www-community/controls/Blocking_Brute_Force_Attacks](https://owasp.org/www-community/controls/Blocking_Brute_Force_Attacks)
6. FreeCodeCamp - How to Use Medusa for Fast, Multi-Protocol Brute-Force Attacks. Disponível em: [https://www.freecodecamp.org/news/how-to-use-medusa-for-fast-multi-protocol-brute-force-attacks-security-tutorial/](https://www.freecodecamp.org/news/how-to-use-medusa-for-fast-multi-protocol-brute-force-attacks-security-tutorial/)
7. GitHub - Medusa Repository. Disponível em: [https://github.com/jmk-foofus/medusa](https://github.com/jmk-foofus/medusa)
8. Digital Innovation One (DIO). Disponível em: [https://web.dio.me](https://web.dio.me)

---

## 12. Autor

**Márcio Gil**

Este projeto foi desenvolvido como parte do desafio de projeto da Digital Innovation One (DIO), demonstrando competências em segurança da informação, testes de penetração e documentação técnica.

---

## 13. Licença

Este projeto é disponibilizado para fins educacionais. O uso das técnicas e ferramentas aqui descritas deve ser feito de forma ética e legal, apenas em ambientes autorizados.

---

## 14. Aviso Legal

⚠️ **IMPORTANTE**: As técnicas e ferramentas descritas neste repositório devem ser utilizadas **APENAS** em ambientes de teste controlados e com autorização explícita. O uso não autorizado dessas técnicas é **ILEGAL** e pode resultar em processos criminais. O autor não se responsabiliza pelo uso indevido das informações aqui contidas.

---

**Desenvolvido com 💜 para a comunidade DIO**

