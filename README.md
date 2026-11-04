# UltimoTalento

Addon de talentos para **World of Warcraft 3.3.5a (Wrath of the Lich King)**, hecho para **UltimoWoW**.

Detecta tu clase, te ofrece builds populares por rol (Tanque, DPS y Sanador) para PvE y PvP, y muestra la vista previa de tus árboles de talentos. Cuando activas una build, **pone tus puntos solo cada vez que subes de nivel**, desde el nivel 1 hasta el 80.

*English below.*

---

## Requisitos

- Cliente WoW **3.3.5a** (Interface 30300), por ejemplo el de UltimoWoW esMX.
- Funciona con cualquier idioma del cliente: las builds se guardan por posición del talento, no por su nombre.

## Instalación

1. **Cierra el WoW por completo.** El juego solo detecta addons nuevos al arrancar; `/reload` no basta.
2. Descarga `UltimoTalento-v3.1.zip` desde la sección **Releases**.
3. Descomprímelo dentro de la carpeta de addons de tu juego:
   ```
   <carpeta del WoW>\Interface\AddOns\
   ```
   Con el cliente de UltimoWoW, por ejemplo:
   ```
   C:\...\[UltimoWoW] Client esMX\UltimoWoW esMX\Interface\AddOns\
   ```
4. Revisa que la estructura quede así, con **una sola** carpeta `UltimoTalento`:
   ```
   Interface\AddOns\UltimoTalento\UltimoTalento.toc
   Interface\AddOns\UltimoTalento\UltimoTalento.lua
   Interface\AddOns\UltimoTalento\Builds.lua
   ```
   ⚠️ Si te queda `AddOns\UltimoTalento\UltimoTalento\...`, sube los archivos un nivel. Si no, el juego no lo encuentra.
5. Abre el WoW. En la pantalla de personajes, pulsa **AddOns** (abajo a la izquierda) y comprueba que **UltimoTalento** está marcado.
   Si sale "Desactualizado", marca **Cargar addons desactualizados**.
6. Entra con tu personaje. En el chat verás: *"UltimoTalento: Escribe /ut o usa el botón del minimapa…"*

## Uso

| Acción | Cómo |
|---|---|
| Abrir la ventana | `/ut` (o `/tc`), o el botón del **libro** en el minimapa |
| Cambiar idioma | Botón **ES \| EN** en la esquina de la ventana, o `/ut es` y `/ut en` |
| Pausar o reanudar la cola | Botones de la ventana, o `/ut pausa` y `/ut seguir` |
| Mover el botón del minimapa | Arrástralo |

### Activar una build

1. Filtra por **Modo** (PvE, PvP o Mías) y por **Rol** (Tanque, DPS o Sanador).
2. Elige una build de la lista. A la derecha verás los 3 árboles:
   - 🟢 **Verde**: talento completo.
   - 🟡 **Amarillo**: pendiente.
   - 🔵 **Azul**: el **siguiente** talento que se pondrá.
   - 🔴 **Rojo**: tienes puntos que la build no usa.
   - ⚪ **Gris**: la build no lo usa.
3. Revisa el requisito:
   - **Talentos limpios**: puedes activarla, incluso con un personaje nuevo de nivel 1.
   - **Tus puntos ya encajan**: puedes activarla sin reiniciar.
   - **No coinciden**: reinicia tus talentos con el instructor de tu clase y luego actívala.
4. Pulsa **Activar build**. Cada punto libre se gastará solo y te avisará en el chat. El orden es: primero el árbol principal, de arriba hacia abajo, respetando filas y requisitos.

### Crear tu propia build

1. Pulsa **Personalizar**. Puedes partir de la build seleccionada, de cero con **Vaciar** o de tus talentos actuales con **Mis talentos**.
2. **Clic izquierdo** en un talento suma un punto y **clic derecho** lo quita, con un máximo de 71 puntos.
3. El addon comprueba que la build se pueda alcanzar. Ponle nombre y rol, y pulsa **Guardar**.
4. Aparecerá en **Mías**, y se activa como cualquier otra.

## Builds incluidas

Hay 66 builds para las 10 clases (PvE y PvP de cada especialización), tomadas de las guías de Wowhead para WotLK. Para añadir más, edita `Builds.lua`. Cada build es un código con un dígito por talento, en orden fila/columna, y los árboles van separados por `-`. Es el mismo formato que la calculadora de talentos de Wowhead WotLK.

## Problemas frecuentes

- **No aparece en la lista de AddOns.** Revisa la estructura de carpetas del paso 4 y que hayas reiniciado el juego.
- **`/ut` no hace nada.** El addon no cargó. Mira si está desactivado en la lista de AddOns o si hay un error de Lua (con Swatter o BugSack).
- **Una build sale como "no válida".** El árbol de tu cliente es distinto al de esa build. El addon la bloquea para no poner puntos equivocados.
- **No pone el punto.** La cola espera a que salgas de combate. Si falla, se pausa sola y te avisa; reanúdala desde la ventana.
- **Los nombres de los talentos siguen en español al cambiar a inglés.** Esos textos los da el cliente del juego, no el addon.

## Desinstalar

Borra la carpeta `Interface\AddOns\UltimoTalento`. Las opciones y builds guardadas están en `WTF\Account\<CUENTA>\<Reino>\<Personaje>\SavedVariables\UltimoTalento.lua`; bórralo si quieres empezar de cero.

---

## English

**UltimoTalento** is a talent addon for WoW 3.3.5a (WotLK), made for UltimoWoW. It detects your class, offers popular PvE and PvP builds by role, previews your talent trees, and **spends your talent points automatically as you level** (from level 1 to 80). You can also design and save your own builds.

**Install:**
1. Close WoW completely.
2. Extract `UltimoTalento-v3.1.zip` into `<WoW folder>\Interface\AddOns\`, so you have `AddOns\UltimoTalento\UltimoTalento.toc`.
3. Start the game and make sure UltimoTalento is enabled in the AddOns list.

**Use:** open it with `/ut` or the minimap book button. Switch languages with the **ES | EN** toggle or with `/ut en`.
