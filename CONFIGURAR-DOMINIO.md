# Guía para Configurar el Dominio www.oles.cl

Esta guía explica cómo configurar el dominio personalizado `www.oles.cl` para el sitio del Observatorio de Legitimidad cuando estés listo.

## 📋 Requisitos Previos

1. **Tener el dominio `oles.cl` registrado** en un proveedor de dominios (ej: NIC Chile, GoDaddy, Namecheap, etc.)
2. **Acceso a la configuración DNS** del dominio
3. **Acceso al repositorio de GitHub** con permisos de administrador

---

## 🔧 Pasos para Configurar el Dominio

### Paso 1: Crear el archivo CNAME

1. En la raíz del proyecto, crea un archivo llamado `CNAME` (sin extensión)
2. Dentro del archivo, escribe solo:
   ```
   www.oles.cl
   ```
3. Guarda el archivo

**Nota:** Este archivo NO debe crearse ahora. Solo créalo cuando vayas a configurar el dominio.

### Paso 2: Configurar DNS en tu Proveedor de Dominio

Necesitas agregar registros DNS en el panel de control de tu proveedor de dominios:

#### Opción A: Usando registros CNAME (Recomendado)

Agrega estos registros DNS:

| Tipo | Nombre/Host | Valor/Destino | TTL |
|------|-------------|---------------|-----|
| CNAME | www | `matdknu.github.io` | 3600 (o automático) |
| A | @ | `185.199.108.153` | 3600 |
| A | @ | `185.199.109.153` | 3600 |
| A | @ | `185.199.110.153` | 3600 |
| A | @ | `185.199.111.153` | 3600 |

**Explicación:**
- El registro CNAME para `www` apunta a GitHub Pages
- Los registros A para `@` (dominio raíz) son las IPs de GitHub Pages (pueden cambiar, verifica en la documentación oficial)

#### Opción B: Solo con CNAME (más simple, pero requiere www)

Si solo quieres usar `www.oles.cl` (no `oles.cl` sin www):

| Tipo | Nombre/Host | Valor/Destino | TTL |
|------|-------------|---------------|-----|
| CNAME | www | `matdknu.github.io` | 3600 |

### Paso 3: Configurar en GitHub Pages

1. Ve a tu repositorio en GitHub: `https://github.com/matdknu/build_olescl`
2. Ve a **Settings** > **Pages**
3. En la sección **Custom domain**, escribe: `www.oles.cl`
4. Marca la casilla **Enforce HTTPS** (recomendado)
5. Guarda los cambios

### Paso 4: Verificar la Configuración

1. Espera 24-48 horas para que los cambios DNS se propaguen
2. Verifica que el dominio funciona:
   - Visita `http://www.oles.cl` (puede tardar en funcionar)
   - GitHub verificará automáticamente el dominio
3. Una vez verificado, GitHub habilitará HTTPS automáticamente

---

## 🔒 Configuración de HTTPS

GitHub Pages proporciona certificados SSL gratuitos mediante Let's Encrypt. Una vez que el dominio esté configurado y verificado:

1. Ve a **Settings** > **Pages** en GitHub
2. Marca **Enforce HTTPS**
3. Espera a que GitHub genere el certificado (puede tardar hasta 24 horas)

---

## 📝 Notas Importantes

### ⚠️ Importante sobre el archivo CNAME

- **NO crees el archivo CNAME ahora** si aún no tienes el dominio configurado
- Si el archivo CNAME existe pero el dominio no está configurado, GitHub Pages puede fallar
- El archivo CNAME debe contener SOLO el dominio, sin `http://` ni `https://`

### 🔄 Actualización de IPs de GitHub

Las IPs de GitHub Pages pueden cambiar. Verifica las IPs actuales en:
- https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site#configuring-a-subdomain

### 📍 Dominio con y sin www

Si quieres que tanto `oles.cl` como `www.oles.cl` funcionen:

1. Configura los registros A para el dominio raíz (`@`)
2. Configura el CNAME para `www`
3. En GitHub, puedes configurar ambos dominios en Settings > Pages

### 🚀 Después de Configurar

Una vez configurado el dominio:

1. **Actualiza las URLs internas** si es necesario (aunque los enlaces relativos deberían funcionar)
2. **Verifica que todas las imágenes y recursos se cargan correctamente**
3. **Prueba en diferentes navegadores y dispositivos**
4. **Configura redirecciones** si es necesario (ej: `oles.cl` → `www.oles.cl`)

---

## 🆘 Solución de Problemas

### El dominio no funciona después de 48 horas

1. Verifica que los registros DNS estén correctos usando:
   ```bash
   dig www.oles.cl
   # o
   nslookup www.oles.cl
   ```
2. Verifica que el archivo CNAME esté en la raíz del repositorio
3. Verifica en GitHub Settings > Pages que el dominio esté verificado

### Error "Domain not verified"

1. Asegúrate de que el archivo CNAME esté en la rama `main` (o la rama que uses)
2. Verifica que el contenido del CNAME sea exactamente `www.oles.cl` (sin espacios, sin http://)
3. Espera hasta 24 horas para la verificación automática

### HTTPS no funciona

1. Espera hasta 24 horas después de configurar el dominio
2. Verifica que "Enforce HTTPS" esté marcado en GitHub Settings > Pages
3. Si después de 24 horas no funciona, desmarca y vuelve a marcar "Enforce HTTPS"

---

## 📚 Recursos Adicionales

- [Documentación oficial de GitHub Pages sobre dominios personalizados](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site)
- [Verificar configuración DNS](https://dnschecker.org/)
- [Herramienta de verificación de DNS](https://mxtoolbox.com/)

---

## ✅ Checklist para cuando estés listo

- [ ] Dominio `oles.cl` registrado y activo
- [ ] Acceso al panel de control DNS del dominio
- [ ] Archivo `CNAME` creado en la raíz del proyecto con `www.oles.cl`
- [ ] Registros DNS configurados (CNAME y/o registros A)
- [ ] Dominio configurado en GitHub Settings > Pages
- [ ] Esperado 24-48 horas para propagación DNS
- [ ] Verificado que el dominio funciona
- [ ] HTTPS habilitado y funcionando
- [ ] Probado en diferentes navegadores y dispositivos

---

**Nota:** Esta configuración NO afecta el funcionamiento actual del sitio en GitHub Pages. El sitio seguirá funcionando en `https://matdknu.github.io/build_olescl/` hasta que configures el dominio personalizado.

