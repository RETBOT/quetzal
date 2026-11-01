---
name: security-lab-design
description: Diseño de laboratorios de seguridad aislados: alcance, aislamiento de red, instantáneas, reproducibilidad y limpieza. Úsala cuando el usuario quiera practicar pentesting, montar un entorno vulnerable, o reproducir un escenario de ataque sin tocar producción.
---

# Security Lab Design

> **Scaffold v2.1** — Reconstruida a partir de `docs/v2.1/SKILLS-REGISTRY.md`. El paquete
> original no incluía esta skill. Sustitúyela cuando llegue la versión de referencia.

## Objetivo

Un laboratorio sirve para romper cosas sin consecuencias. Si puede alcanzar algo real,
no es un laboratorio: es una red.

> *"El primer paso de un pentest no es `nmap`. Es saber qué puedes tocar."*

## Principios

| Principio | Regla concreta |
|---|---|
| **Aislamiento** | Red host-only o interna. Sin puente a la LAN ni a internet |
| **Desechable** | Se puede destruir y reconstruir sin perder nada |
| **Reproducible** | Se levanta desde código o script, no desde pasos de memoria |
| **Acotado** | Recursos limitados: no tumbas tu host por un `fork bomb` de práctica |
| **Documentado** | Alcance, credenciales de práctica y plan de limpieza escritos |

## Arquitectura recomendada

```
Host
 └── Hypervisor (VirtualBox / VMware / Hyper-V)
      └── Red interna aislada (host-only, sin NAT)
           ├── Atacante   (Kali / Parrot)
           ├── Objetivo   (Juice Shop, DVWA, VM vulnerable)
           └── (opcional) Víctima Windows / AD lab
```

Variantes:

| Opción | Aislamiento | Cuándo |
|---|---|---|
| VMs con red host-only | Fuerte | Práctica real, AD, red |
| Docker en red interna | Medio | Aplicaciones web |
| Contenedor con `--network none` | Muy fuerte | Analizar un binario o servicio |
| Servicio en la nube | Débil | Solo si está diseñado para ser vulnerable |

**Nunca** levantes Juice Shop o DVWA con puerto publicado en una IP pública. Existen y se
encuentran.

## Checklist de aislamiento

- [ ] Red sin NAT y sin bridge a la interfaz física.
- [ ] Puerto publicado solo en `127.0.0.1` si usas Docker.
- [ ] Sin credenciales reales en las VMs del laboratorio.
- [ ] Sin monturas del host hacia contenedores vulnerables.
- [ ] Sin acceso al metadata endpoint de la nube.
- [ ] Verificado: desde el objetivo, `curl` a internet **falla**.

Esa última casilla es la que importa. Verifícala, no la asumas.

## Recursos y límites

```bash
# Docker: límites explícitos
docker run --rm -it \
  --network lab-net \
  --memory 1g --cpus 1 \
  --pids-limit 200 \
  --read-only --tmpfs /tmp \
  juice-shop
```

Sin `--pids-limit`, un `fork bomb` de práctica congela tu máquina. Sin `--memory`, el OOM
mata al host.

## Reproducibilidad

| Nivel | Herramienta |
|---|---|
| VMs | Vagrant, imágenes exportadas + snapshot base |
| Contenedores | `docker-compose.yml` versionado |
| Configuración | Ansible / script de aprovisionamiento |
| Datos | Seed reproducible, no un dump que solo tú tienes |

- **Snapshot antes de empezar.** Siempre. Restaurar es un clic; reconstruir toma una tarde.
- Un laboratorio que solo funciona en tu máquina no es reproducible, es folclore.

## Plan de limpieza

Antes de empezar, escribe cómo termina:

- [ ] Detener y eliminar contenedores (`docker compose down -v`).
- [ ] Restaurar snapshot o destruir VMs.
- [ ] Eliminar reglas de firewall y redes creadas.
- [ ] Borrar credenciales y tokens generados durante la práctica.
- [ ] Revisar que nada quedó escuchando en una interfaz externa.
- [ ] Sanitizar capturas y evidencias antes de compartirlas.

## Entornos vulnerables de práctica

| Objetivo | Cubre |
|---|---|
| OWASP Juice Shop | Web moderna, JWT, lógica de negocio |
| DVWA | Inyección clásica, XSS, file inclusion |
| crAPI | API Top 10, BOLA |
| Metasploitable / VulnHub | Red, servicios, escalada |
| GOAD / DVAD | Active Directory |

Empieza con uno. Un laboratorio de tres objetivos que no configuraste no enseña nada.

## Límites

- No conectes el laboratorio a tu red doméstica "solo un momento".
- No uses datos reales de clientes en el laboratorio.
- No dejes el laboratorio corriendo entre sesiones sin snapshot y sin documentar.
- No presentes un hallazgo de laboratorio como si fuera de producción.
- Si necesitas probar algo que requiere red real, pide autorización explícita y documenta
  el alcance antes de tocar nada.
