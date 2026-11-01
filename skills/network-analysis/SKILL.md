---
name: network-analysis
description: Análisis de redes y tráfico (TCP/IP, DNS, HTTP/TLS) con captura y lectura de paquetes. Úsala cuando el usuario pida diagnosticar conectividad, entender un handshake, leer un pcap, o explicar cómo viaja el tráfico de una aplicación.
---

# Network Analysis

> **Scaffold v2.1** — Reconstruida a partir de `docs/v2.1/SKILLS-REGISTRY.md`. El paquete
> original no incluía esta skill. Sustitúyela cuando llegue la versión de referencia.

## Alcance

**Solo lectura y solo laboratorio propio.** Analizas tráfico de sistemas que te
pertenecen o de un entorno donde tienes autorización escrita. Capturar tráfico ajeno es
interceptación, no análisis.

Si el alcance no está claro: para y pregunta. Ofrece un laboratorio local (`localhost`,
VMs aisladas, Juice Shop) en lugar de una red real.

## Modelo por capas: qué revisar y en qué orden

| Capa | Pregunta | Herramienta |
|---|---|---|
| Enlace / IP | ¿Hay ruta? ¿Resuelve ARP? | `ip a`, `ip route`, `arp -a` |
| Transporte | ¿El puerto escucha? ¿SYN/SYN-ACK? | `ss -tulpn`, `telnet`/`nc -vz` |
| DNS | ¿Resuelve el nombre? ¿A qué IP? | `dig`, `nslookup`, `Resolve-DnsName` |
| TLS | ¿Handshake completo? ¿Certificado válido? | `openssl s_client`, navegador |
| Aplicación | ¿Qué responde? ¿Qué status? | `curl -v`, DevTools |
| Tráfico | ¿Qué pasa realmente en el cable? | `tcpdump`, Wireshark |

**Baja por capas, no saltes.** "No carga" casi nunca es la capa 7; empieza abajo.

## Diagnóstico de conectividad, en orden

```bash
# 1. ¿Tengo IP y ruta?
ip a && ip route

# 2. ¿Resuelve el nombre?
dig +short api.ejemplo.com

# 3. ¿El puerto responde?
nc -vz api.ejemplo.com 443

# 4. ¿El handshake TLS cierra?
openssl s_client -connect api.ejemplo.com:443 -servername api.ejemplo.com

# 5. ¿Qué dice la aplicación?
curl -v --max-time 10 https://api.ejemplo.com/health
```

Si el paso 3 falla y el 2 funcionó: firewall, security group o servicio caído.
Si el 2 falla: DNS. Si el 4 falla: certificado, SNI o TLS deshabilitado.

## Captura de tráfico

```bash
# Solo cabeceras, sin payload ni DNS resuelto
sudo tcpdump -i eth0 -nn -s 0 -w captura.pcap host 10.0.0.5 and port 443

# Lectura rápida en consola
sudo tcpdump -i any -nn 'tcp port 443 and host 10.0.0.5'
```

- `-nn` evita resolución de nombres y hace la salida determinista.
- `-s 0` captura el paquete completo, no truncado.
- Filtra **en la captura**, no después: un pcap sin filtro puede ser gigante.
- Guarda a `.pcap` y analiza en Wireshark; ahí ves reconstrucción de flujo y tiempos.

### Filtros de Wireshark que sí sirven

```
tcp.flags.syn == 1 && tcp.flags.ack == 0     # intentos de conexión
tcp.analysis.retransmission                  # retransmisiones (pérdida)
tcp.analysis.zero_window                     # receptor saturado
dns.flags.rcode != 0                         # DNS fallando
tls.alert_message                            # errores de TLS
http.response.code >= 400
```

## Lectura del handshake TLS

| Fase | Qué confirma |
|---|---|
| Client Hello | SNI (qué dominio pidió), versiones y cifrados ofrecidos |
| Server Hello | Cifrado elegido, certificado |
| Certificate | Emisor, validez, cadena completa |
| Finished | Handshake completo |

- Si el Server Hello no llega: firewall o servicio caído.
- Si el certificado es inválido y el cliente lo rechaza, verás `tls.alert`.
- **Con TLS 1.3 el certificado viaja cifrado**: Wireshark no lo muestra sin claves. Si
  necesitas verlo, exporta las claves de sesión (`SSLKEYLOGFILE`) en el cliente, no
  rompas TLS.

## Rendimiento de red: qué medir

| Señal en el pcap | Significado |
|---|---|
| Retransmisiones | Pérdida de paquetes |
| `zero_window` | El receptor no puede procesar |
| RTT alto constante | Distancia o congestión |
| Muchos SYN sin respuesta | Filtrado o servicio caído |
| Conexiones nuevas por request | Falta keep-alive |

## Límites

- No capturar tráfico de redes de terceros. Nunca.
- No desofuscar payload ajeno ni operar sobre credenciales capturadas.
- No uses ARP spoofing, MITM ni inyección fuera de un laboratorio aislado tuyo.
- No declares "la red está bien" porque el ping responde: ICMP puede ir y el puerto estar
  filtrado.
- Si el `.pcap` contiene datos personales, sanitízalo antes de compartirlo.
