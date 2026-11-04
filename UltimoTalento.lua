-- UltimoTalento 3.1
-- Detecta tu clase, te ofrece builds populares por rol (PvE/PvP) o tus propias builds,
-- muestra una vista previa de los 3 árboles (lo que tienes, lo que falta y el siguiente
-- talento) y, al activar una build, pone tus puntos en cola: cada punto libre se gasta
-- solo en el siguiente talento (árbol principal primero, de arriba hacia abajo).
-- Abre la ventana con /ut (o /tc) o con el botón del minimapa. Idioma: español / inglés.

local VERDE, ROJO, AMARILLO, GRIS, AZUL = "|cff33ff33", "|cffff4444", "|cffffd200", "|cff999999", "|cff66ccff"
local MAX_PUNTOS = 71

------------------------------------------------------------------------
-- Idiomas
------------------------------------------------------------------------

local TEXTOS = {
	es = {
		titulo = "UltimoTalento — %s nivel %d",
		modo = "Modo:", rol = "Rol:",
		Todos = "Todos", PvE = "PvE", PvP = "PvP", ["Mías"] = "Mías", ["Mía"] = "Mía",
		Tanque = "Tanque", DPS = "DPS", Sanador = "Sanador",
		activar = "Activar build", personalizar = "Personalizar", borrar = "Borrar mía", ventanaTalentos = "Ventana de talentos",
		guardar = "Guardar", misTalentos = "Mis talentos", vaciar = "Vaciar", cancelar = "Cancelar",
		pausar = "Pausar", reanudar = "Reanudar", quitar = "Quitar build", rolBoton = "Rol: %s",
		activa = " (activa)",
		invalida = "Esta build no es válida en tu cliente: %s",
		errArboles = "tiene más árboles que tu clase", errArbol = "no coincide con tu árbol de %s", errRango = "rango inválido en %s",
		arbol = "Árbol %d",
		detalle = "Rol: %s%s|r   Modo: %s%s|r\nPuntos: %d (%s)",
		limpio = "Talentos limpios: lista para activar.|r\nDesde nivel 1 cada punto se pondrá solo al subir.",
		compatible = "Tus %d puntos ya encajan con esta build.|r\nPuedes activarla sin reiniciar.",
		conflicto = "Tus talentos no coinciden.|r Reinícialos con el instructor y luego actívala.\n",
		sobran = "Sobran: %s", yMas = " y %d más",
		etapa = "Etapa: %d/%d puntos (%d%%)",
		leyenda = "Verde|r: completo   %sAmarillo|r: pendiente   %sAzul|r: siguiente en la cola   %sRojo|r: tienes puntos que la build no usa   %sGris|r: no se usa",
		tienesBuild = "Tienes %s%d|r  /  Build %s%d|r", puntosArbol = "%d puntos",
		tooltipRangos = "Tienes: %d/%d   Build: %d/%d", tooltipEditar = "Clic izquierdo: +1   Clic derecho: -1",
		editando = "Personalizando build", editAyuda = "Clic izquierdo en un talento: +1\nClic derecho: -1",
		editPuntos = "Puntos: %s%d/%d|r  (%s)\n", editVacia = "Elige talentos en los árboles.|r",
		editInalcanzable = "Hay talentos que no se pueden alcanzar (faltan puntos en filas de arriba o requisitos).|r",
		editValida = "Build válida.|r Ponle nombre:",
		editLeyenda = "Modo personalizado:|r los rangos muestran tu build (no tus talentos actuales). Al guardarla aparece en «Mías».",
		sinMias = "Aún no tienes builds propias.", sinMiasAyuda = "Pulsa «Personalizar» para crear una.",
		sinFiltro = "Ninguna build con estos filtros.", mostrandoActuales = "Mostrando tus talentos actuales.|r",
		activaTxt = "Activa: %s%s|r %s\n%d/%d puntos   Libres: %d%s", pausaTag = "[PAUSA]", onTag = "[ON]",
		siguiente = "\nSiguiente: %s", completaTxt = "\nBuild completa.", sinActiva = "Sin build activa.|r",
		miBuild = "Mi build", mia = " (mía)",
		-- chat
		chatPuse = "Puse 1 punto en %s%s|r (%d/%d).", chatNoPude = "No pude poner el punto en %s. Cola en pausa.|r",
		chatCompleta = "Build «%s» completa.|r", chatNoSig = "No encuentro el siguiente talento de la build. Cola en pausa; revisa con /ut.|r",
		chatActivada = "Build activada: %s%s|r. Tus puntos se pondrán solos al subir de nivel.",
		chatGuardada = "Build guardada: %s%s|r (%s).", chatBorrada = "Build borrada: %s", chatQuitada = "Build quitada: %s. Tus talentos no cambian.",
		chatPausa = "Cola en pausa.", chatSeguir = "Cola activa.",
		chatLogin = "Build activa: %s%s. /ut para abrir.", chatEnPausa = " (en pausa)", chatBienvenida = "Escribe /ut o usa el botón del minimapa para elegir una build.",
		chatIdioma = "Idioma: español.",
		miniSin = "Sin build activa", miniBuild = "Build: %s", miniAyuda = "Clic: abrir   Arrastrar: mover",
		idiomaTip = "Cambiar idioma / Change language",
	},
	en = {
		titulo = "UltimoTalento — %s level %d",
		modo = "Mode:", rol = "Role:",
		Todos = "All", PvE = "PvE", PvP = "PvP", ["Mías"] = "Mine", ["Mía"] = "Mine",
		Tanque = "Tank", DPS = "DPS", Sanador = "Healer",
		activar = "Activate build", personalizar = "Customize", borrar = "Delete mine", ventanaTalentos = "Talent window",
		guardar = "Save", misTalentos = "My talents", vaciar = "Clear", cancelar = "Cancel",
		pausar = "Pause", reanudar = "Resume", quitar = "Remove build", rolBoton = "Role: %s",
		activa = " (active)",
		invalida = "This build is not valid on your client: %s",
		errArboles = "has more trees than your class", errArbol = "does not match your %s tree", errRango = "invalid rank in %s",
		arbol = "Tree %d",
		detalle = "Role: %s%s|r   Mode: %s%s|r\nPoints: %d (%s)",
		limpio = "Talents are clean: ready to activate.|r\nFrom level 1, each point is spent automatically as you level.",
		compatible = "Your %d points already fit this build.|r\nYou can activate it without resetting.",
		conflicto = "Your talents don't match.|r Reset them at your class trainer, then activate it.\n",
		sobran = "Extra: %s", yMas = " and %d more",
		etapa = "Progress: %d/%d points (%d%%)",
		leyenda = "Green|r: done   %sYellow|r: pending   %sBlue|r: next in queue   %sRed|r: points the build doesn't use   %sGray|r: unused",
		tienesBuild = "You %s%d|r  /  Build %s%d|r", puntosArbol = "%d points",
		tooltipRangos = "You: %d/%d   Build: %d/%d", tooltipEditar = "Left click: +1   Right click: -1",
		editando = "Customizing build", editAyuda = "Left click a talent: +1\nRight click: -1",
		editPuntos = "Points: %s%d/%d|r  (%s)\n", editVacia = "Pick talents in the trees.|r",
		editInalcanzable = "Some talents can't be reached (missing points in upper rows or prerequisites).|r",
		editValida = "Valid build.|r Give it a name:",
		editLeyenda = "Custom mode:|r ranks show your build (not your current talents). Once saved it appears under “Mine”.",
		sinMias = "You don't have custom builds yet.", sinMiasAyuda = "Press “Customize” to create one.",
		sinFiltro = "No builds match these filters.", mostrandoActuales = "Showing your current talents.|r",
		activaTxt = "Active: %s%s|r %s\n%d/%d points   Free: %d%s", pausaTag = "[PAUSED]", onTag = "[ON]",
		siguiente = "\nNext: %s", completaTxt = "\nBuild complete.", sinActiva = "No active build.|r",
		miBuild = "My build", mia = " (mine)",
		chatPuse = "Spent 1 point in %s%s|r (%d/%d).", chatNoPude = "Couldn't spend the point in %s. Queue paused.|r",
		chatCompleta = "Build “%s” complete.|r", chatNoSig = "Can't find the next talent of the build. Queue paused; check /ut.|r",
		chatActivada = "Build activated: %s%s|r. Your points will be spent automatically as you level.",
		chatGuardada = "Build saved: %s%s|r (%s).", chatBorrada = "Build deleted: %s", chatQuitada = "Build removed: %s. Your talents are unchanged.",
		chatPausa = "Queue paused.", chatSeguir = "Queue active.",
		chatLogin = "Active build: %s%s. Type /ut to open.", chatEnPausa = " (paused)", chatBienvenida = "Type /ut or use the minimap button to choose a build.",
		chatIdioma = "Language: English.",
		miniSin = "No active build", miniBuild = "Build: %s", miniAyuda = "Click: open   Drag: move",
		idiomaTip = "Cambiar idioma / Change language",
	},
}

local DB
local function Idioma() return (DB and DB.idioma) or "es" end
local function L(clave, ...)
	local s = TEXTOS[Idioma()][clave] or TEXTOS.es[clave] or clave
	if select("#", ...) > 0 then return string.format(s, ...) end
	return s
end
local function NombreBuild(b) return (Idioma() == "en" and b.en) or b.nombre end

local function msg(texto) DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99UltimoTalento:|r " .. texto) end

local function SZ(f, w, h) f:SetWidth(w) f:SetHeight(h) end

local claseLocal, clase = UnitClass("player")

------------------------------------------------------------------------
-- Árbol de talentos y builds
------------------------------------------------------------------------

-- info[tab][i] = { nombre, icono, fila, col, rango, max, pre = índice del requisito }
local function LeerArbol()
	local info = {}
	for tab = 1, GetNumTalentTabs() do
		info[tab] = {}
		local pos = {}
		for i = 1, GetNumTalents(tab) do
			local nombre, icono, fila, col, rango, max = GetTalentInfo(tab, i)
			info[tab][i] = { nombre = nombre, icono = icono, fila = fila, col = col, rango = rango, max = max }
			pos[fila .. ":" .. col] = i
		end
		for i = 1, GetNumTalents(tab) do
			local pf, pc = GetTalentPrereqs(tab, i)
			if pf then info[tab][i].pre = pos[pf .. ":" .. pc] end
		end
	end
	return info
end

local function NombreArbol(tab) return GetTalentTabInfo(tab) or L("arbol", tab) end

-- Código -> obj[tab][i] = rango. Devuelve obj, total o nil, 0, error
local function Decodificar(codigo, info)
	local obj, total, tab = {}, 0, 1
	for parte in (codigo .. "-"):gmatch("([^-]*)-") do
		if tab > #info then
			if parte ~= "" then return nil, 0, L("errArboles") end
		else
			obj[tab] = {}
			if #parte > #info[tab] then return nil, 0, L("errArbol", NombreArbol(tab)) end
			for i = 1, #info[tab] do
				local r = tonumber(parte:sub(i, i)) or 0
				if r > info[tab][i].max then return nil, 0, L("errRango", info[tab][i].nombre) end
				obj[tab][i] = r
				total = total + r
			end
		end
		tab = tab + 1
	end
	for t = 1, #info do
		obj[t] = obj[t] or {}
		for i = 1, #info[t] do obj[t][i] = obj[t][i] or 0 end
	end
	return obj, total
end

local function Codificar(obj)
	local partes = {}
	for t = 1, #obj do
		local s = ""
		for i = 1, #obj[t] do s = s .. obj[t][i] end
		partes[t] = (s:gsub("0+$", ""))
	end
	return (table.concat(partes, "-"):gsub("%-+$", ""))
end

local function PuntosPorArbol(obj)
	local p = {}
	for t = 1, #obj do
		p[t] = 0
		for _, r in ipairs(obj[t]) do p[t] = p[t] + r end
	end
	return p
end

local function Total(obj)
	local s = 0
	for _, v in ipairs(PuntosPorArbol(obj)) do s = s + v end
	return s
end

local function Reparto(obj) return table.concat(PuntosPorArbol(obj), "/") end

local function RangosActuales(info)
	local r = {}
	for t = 1, #info do
		r[t] = {}
		for i, d in ipairs(info[t]) do r[t][i] = d.rango end
	end
	return r
end

local function RangosVacios(info)
	local r = {}
	for t = 1, #info do
		r[t] = {}
		for i = 1, #info[t] do r[t][i] = 0 end
	end
	return r
end

-- "limpio", "compatible" o "conflicto", lista de sobrantes, puntos gastados
local function Comparar(obj, info)
	local gastados, sobran = 0, {}
	for t = 1, #info do
		for i, d in ipairs(info[t]) do
			gastados = gastados + d.rango
			if d.rango > obj[t][i] then
				table.insert(sobran, string.format("%s (%d/%d)", d.nombre, d.rango, obj[t][i]))
			end
		end
	end
	if gastados == 0 then return "limpio", sobran, 0 end
	if #sobran == 0 then return "compatible", sobran, gastados end
	return "conflicto", sobran, gastados
end

-- Siguiente talento a subir según rangos (reales o simulados)
local function SiguientePaso(obj, info, rangos)
	local p = PuntosPorArbol(obj)
	local orden = {}
	for t = 1, #info do orden[t] = t end
	table.sort(orden, function(a, b) return p[a] > p[b] end)
	for _, t in ipairs(orden) do
		local enArbol = 0
		for _, r in ipairs(rangos[t]) do enArbol = enArbol + r end
		for i, d in ipairs(info[t]) do
			if rangos[t][i] < obj[t][i] and enArbol >= (d.fila - 1) * 5 then
				local pre = d.pre
				if not pre or rangos[t][pre] >= info[t][pre].max then return t, i end
			end
		end
	end
end

local function Plan(obj, info, max, desdeCero)
	local r = desdeCero and RangosVacios(info) or RangosActuales(info)
	local lista = {}
	while #lista < (max or 100) do
		local t, i = SiguientePaso(obj, info, r)
		if not t then break end
		r[t][i] = r[t][i] + 1
		table.insert(lista, { t, i, r[t][i] })
	end
	return lista
end

-- ¿Se pueden colocar todos los puntos de la build empezando desde cero?
local function Alcanzable(obj, info)
	return #Plan(obj, info, 200, true) == Total(obj)
end

local function Mias()
	DB.mias = DB.mias or {}
	DB.mias[clase] = DB.mias[clase] or {}
	return DB.mias[clase]
end

local function BuildsDeClase()
	local r = {}
	for _, b in ipairs(UltimoTalentoBuilds[clase] or {}) do table.insert(r, b) end
	for _, b in ipairs(Mias()) do table.insert(r, b) end
	return r
end

------------------------------------------------------------------------
-- Motor de la cola
------------------------------------------------------------------------

local motor = CreateFrame("Frame")
local pendiente, espera, reintento = nil, 0, 0
local Refrescar

local function Libres() return UnitCharacterPoints("player") or 0 end

local function Intentar()
	if not DB or not DB.activo or DB.pausado or pendiente then return end
	if DB.activo.clase ~= clase then return end
	if Libres() <= 0 or UnitAffectingCombat("player") then return end
	local info = LeerArbol()
	local obj, total = Decodificar(DB.activo.codigo, info)
	if not obj then return end
	local t, i = SiguientePaso(obj, info, RangosActuales(info))
	if not t then
		local _, _, gastados = Comparar(obj, info)
		if gastados >= total then
			msg(VERDE .. L("chatCompleta", NombreBuild(DB.activo)))
		else
			msg(ROJO .. L("chatNoSig"))
			DB.pausado = true
		end
		Refrescar()
		return
	end
	local d = info[t][i]
	pendiente = { nombre = d.nombre, rango = d.rango + 1, max = obj[t][i], libres = Libres() }
	espera = 0
	LearnTalent(t, i)
end

motor:SetScript("OnUpdate", function(self, dt)
	if reintento > 0 then
		reintento = reintento - dt
		if reintento <= 0 then Intentar() end
	end
	if pendiente then
		espera = espera + dt
		if Libres() < pendiente.libres then
			msg(L("chatPuse", AMARILLO, pendiente.nombre, pendiente.rango, pendiente.max))
			pendiente = nil
			reintento = 0.6
			Refrescar()
		elseif espera > 6 then
			msg(ROJO .. L("chatNoPude", pendiente.nombre))
			DB.pausado = true
			pendiente = nil
			Refrescar()
		end
	end
end)

local function Activar(b)
	DB.activo = { clase = clase, nombre = b.nombre, en = b.en, codigo = b.codigo }
	DB.pausado = nil
	msg(L("chatActivada", AMARILLO, NombreBuild(b)))
	reintento = 0.5
end

------------------------------------------------------------------------
-- Ventana
------------------------------------------------------------------------

local UI = CreateFrame("Frame", "UltimoTalentoFrame", UIParent)
SZ(UI, 960, 620)
UI:SetPoint("CENTER")
UI:SetFrameStrata("DIALOG")
UI:SetToplevel(true)
UI:SetBackdrop({
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = true, tileSize = 32, edgeSize = 32,
	insets = { left = 11, right = 12, top = 12, bottom = 11 },
})
UI:EnableMouse(true)
UI:SetMovable(true)
UI:SetClampedToScreen(true)
UI:RegisterForDrag("LeftButton")
UI:SetScript("OnDragStart", UI.StartMoving)
UI:SetScript("OnDragStop", UI.StopMovingOrSizing)
UI:Hide()
tinsert(UISpecialFrames, "UltimoTalentoFrame") -- Escape la cierra

local cerrar = CreateFrame("Button", nil, UI, "UIPanelCloseButton")
cerrar:SetPoint("TOPRIGHT", -6, -6)

local titulo = UI:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
titulo:SetPoint("TOP", 0, -18)

local function Texto(plantilla, x, y, ancho, padre)
	local f = (padre or UI):CreateFontString(nil, "OVERLAY", plantilla or "GameFontHighlight")
	f:SetPoint("TOPLEFT", x, y)
	f:SetJustifyH("LEFT")
	f:SetJustifyV("TOP")
	if ancho then f:SetWidth(ancho) end
	return f
end

-- Botones con texto traducible: guardan su clave y se re-etiquetan al cambiar idioma
local etiquetas = {}
local function Boton(clave, ancho, alto)
	local b = CreateFrame("Button", nil, UI, "UIPanelButtonTemplate")
	SZ(b, ancho, alto or 22)
	b.clave = clave
	if clave ~= "rolBoton" then b:SetText(L(clave)) end
	table.insert(etiquetas, b)
	return b
end

-- Interruptor de idioma (esquina superior izquierda)
local btnIdioma = CreateFrame("Button", nil, UI)
SZ(btnIdioma, 64, 20)
btnIdioma:SetPoint("TOPLEFT", 20, -16)
btnIdioma:SetBackdrop({
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true, tileSize = 16, edgeSize = 10,
	insets = { left = 2, right = 2, top = 2, bottom = 2 },
})
btnIdioma:SetBackdropColor(0, 0, 0, 0.8)
btnIdioma:SetBackdropBorderColor(1, 0.82, 0, 0.8)
btnIdioma:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")
btnIdioma.texto = btnIdioma:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
btnIdioma.texto:SetPoint("CENTER")

-- Estado de la vista
local filtroModo, filtroRol = "Todos", "Todos"
local seleccion          -- build elegida en la lista
local edicion            -- obj editable cuando se personaliza (nil = no editando)
local botonesModo, botonesRol = {}, {}

local function CrearFiltros(lista, valores, x, y, ancho, setter)
	for k, v in ipairs(valores) do
		local b = Boton(v, ancho, 20)
		b:SetPoint("TOPLEFT", x + (k - 1) * (ancho + 2), y)
		b:SetScript("OnClick", function() setter(v) Refrescar() end)
		lista[v] = b
	end
end

local lblModo = Texto("GameFontNormalSmall", 22, -50)
CrearFiltros(botonesModo, { "Todos", "PvE", "PvP", "Mías" }, 58, -46, 50, function(v) filtroModo = v end)
local lblRol = Texto("GameFontNormalSmall", 22, -74)
CrearFiltros(botonesRol, { "Todos", "Tanque", "DPS", "Sanador" }, 58, -70, 50, function(v) filtroRol = v end)

-- Lista de builds (columna izquierda)
local filas = {}
for k = 1, 11 do
	local f = CreateFrame("Button", nil, UI)
	SZ(f, 250, 20)
	f:SetPoint("TOPLEFT", 18, -96 - (k - 1) * 21)
	f:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
	local sel = f:CreateTexture(nil, "BACKGROUND")
	sel:SetAllPoints()
	sel:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
	sel:SetVertexColor(1, 0.8, 0, 0.6)
	sel:Hide()
	f.sel = sel
	f.texto = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	f.texto:SetPoint("LEFT", 4, 0)
	f.texto:SetWidth(244)
	f.texto:SetJustifyH("LEFT")
	f:SetScript("OnClick", function(self)
		if edicion then return end
		seleccion = self.build
		Refrescar()
	end)
	filas[k] = f
end

-- Detalle (columna izquierda, debajo de la lista)
local detNombre = Texto("GameFontNormal", 22, -332, 250)
local detInfo = Texto("GameFontHighlightSmall", 22, -350, 250)
local detEstado = Texto("GameFontHighlightSmall", 22, -380, 250)

-- Barra de progreso (etapa del jugador)
local barra = CreateFrame("StatusBar", nil, UI)
SZ(barra, 250, 14)
barra:SetPoint("TOPLEFT", 20, -446)
barra:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
barra:SetStatusBarColor(0.2, 0.8, 0.2)
barra:SetMinMaxValues(0, 1)
local barraFondo = barra:CreateTexture(nil, "BACKGROUND")
barraFondo:SetAllPoints()
barraFondo:SetTexture(0, 0, 0, 0.5)
local barraTexto = barra:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
barraTexto:SetPoint("CENTER")

-- Botones de la build seleccionada
local btnActivar = Boton("activar", 122, 22)
btnActivar:SetPoint("TOPLEFT", 20, -466)
local btnPersonalizar = Boton("personalizar", 122, 22)
btnPersonalizar:SetPoint("LEFT", btnActivar, "RIGHT", 6, 0)
local btnBorrar = Boton("borrar", 122, 22)
btnBorrar:SetPoint("TOPLEFT", 20, -490)
local btnTalentos = Boton("ventanaTalentos", 122, 22)
btnTalentos:SetPoint("LEFT", btnBorrar, "RIGHT", 6, 0)
btnTalentos:SetScript("OnClick", function() ToggleTalentFrame() end)

-- Controles del modo edición
local cajaNombre = CreateFrame("EditBox", "UltimoTalentoNombre", UI, "InputBoxTemplate")
SZ(cajaNombre, 160, 20)
cajaNombre:SetPoint("TOPLEFT", 26, -440)
cajaNombre:SetAutoFocus(false)
cajaNombre:SetMaxLetters(40)
cajaNombre:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
cajaNombre:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
local rolEdicion = "DPS"
local btnRol = Boton("rolBoton", 80, 20)
btnRol:SetPoint("LEFT", cajaNombre, "RIGHT", 6, 0)
local ROLES = { "Tanque", "DPS", "Sanador" }
btnRol:SetScript("OnClick", function()
	local k = 1
	for n, r in ipairs(ROLES) do if r == rolEdicion then k = n % #ROLES + 1 end end
	rolEdicion = ROLES[k]
	Refrescar()
end)
local btnGuardar = Boton("guardar", 80, 22)
btnGuardar:SetPoint("TOPLEFT", 20, -466)
local btnMisTalentos = Boton("misTalentos", 84, 22)
btnMisTalentos:SetPoint("LEFT", btnGuardar, "RIGHT", 4, 0)
local btnLimpiar = Boton("vaciar", 80, 22)
btnLimpiar:SetPoint("LEFT", btnMisTalentos, "RIGHT", 4, 0)
local btnCancelar = Boton("cancelar", 80, 22)
btnCancelar:SetPoint("TOPLEFT", 20, -490)

-- Parte inferior izquierda: build activa
local sep = UI:CreateTexture(nil, "ARTWORK")
sep:SetTexture(1, 1, 1, 0.15)
SZ(sep, 252, 1)
sep:SetPoint("TOPLEFT", 18, -518)
local actTexto = Texto("GameFontHighlightSmall", 22, -524, 250)
local btnPausa = Boton("pausar", 80, 20)
btnPausa:SetPoint("BOTTOMLEFT", 104, 18)
local btnQuitar = Boton("quitar", 84, 20)
btnQuitar:SetPoint("LEFT", btnPausa, "RIGHT", 4, 0)

------------------------------------------------------------------------
-- Vista previa de los árboles
------------------------------------------------------------------------

local AX, AY, ANCHO_ARBOL, CELDA = 285, -50, 222, 44
local arboles = {}
local VistaActual -- { obj, info }

local function CrearCelda(t, padre)
	local b = CreateFrame("Button", nil, padre)
	SZ(b, 34, 34)
	b:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	b.icono = b:CreateTexture(nil, "ARTWORK")
	b.icono:SetAllPoints()
	b.borde = b:CreateTexture(nil, "OVERLAY")
	b.borde:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
	b.borde:SetBlendMode("ADD")
	SZ(b.borde, 62, 62)
	b.borde:SetPoint("CENTER")
	b.fondoRango = b:CreateTexture(nil, "OVERLAY")
	b.fondoRango:SetTexture(0, 0, 0, 0.75)
	SZ(b.fondoRango, 28, 12)
	b.fondoRango:SetPoint("BOTTOMRIGHT", 4, -4)
	b.rango = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	b.rango:SetPoint("CENTER", b.fondoRango, "CENTER", 0, 0)
	b:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")
	b:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetTalent(self.t, self.i)
		if VistaActual then
			local d = VistaActual.info[self.t][self.i]
			local o = VistaActual.obj[self.t][self.i]
			GameTooltip:AddLine(" ")
			GameTooltip:AddLine(L("tooltipRangos", d.rango, d.max, o, d.max), 1, 0.82, 0)
			if edicion then GameTooltip:AddLine(L("tooltipEditar"), 0.6, 0.8, 1) end
		end
		GameTooltip:Show()
	end)
	b:SetScript("OnLeave", function() GameTooltip:Hide() end)
	b:SetScript("OnClick", function(self, boton)
		if not edicion then return end
		local d = VistaActual.info[self.t][self.i]
		local v = edicion[self.t][self.i]
		if boton == "RightButton" then
			if v > 0 then edicion[self.t][self.i] = v - 1 end
		elseif v < d.max and Total(edicion) < MAX_PUNTOS then
			edicion[self.t][self.i] = v + 1
		end
		Refrescar()
	end)
	b.t = t
	return b
end

for t = 1, 3 do
	local a = CreateFrame("Frame", nil, UI)
	SZ(a, ANCHO_ARBOL, 520)
	a:SetPoint("TOPLEFT", AX + (t - 1) * (ANCHO_ARBOL + 6), AY)
	a:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 12,
		insets = { left = 3, right = 3, top = 3, bottom = 3 },
	})
	a:SetBackdropColor(0, 0, 0, 0.6)
	a:SetBackdropBorderColor(0.6, 0.6, 0.6, 1)
	a.fondo = a:CreateTexture(nil, "BACKGROUND")
	a.fondo:SetPoint("TOPLEFT", 4, -4)
	a.fondo:SetPoint("BOTTOMRIGHT", -4, 4)
	a.fondo:SetAlpha(0.35)
	a.titulo = a:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	a.titulo:SetPoint("TOP", 0, -8)
	a.puntos = a:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
	a.puntos:SetPoint("TOP", 0, -24)
	a.celdas = {}
	arboles[t] = a
end

local function DibujarArboles(obj, info)
	local sigT, sigI
	if not edicion then sigT, sigI = SiguientePaso(obj, info, RangosActuales(info)) end
	VistaActual = { obj = obj, info = info }
	local pObj = PuntosPorArbol(obj)
	for t, a in ipairs(arboles) do
		if not info[t] then a:Hide() else
			a:Show()
			local _, _, _, fondo = GetTalentTabInfo(t)
			if fondo then a.fondo:SetTexture("Interface\\TalentFrame\\" .. fondo .. "-TopLeft") end
			local cur = 0
			for _, d in ipairs(info[t]) do cur = cur + d.rango end
			a.titulo:SetText(NombreArbol(t))
			if edicion then
				a.puntos:SetText(AZUL .. L("puntosArbol", pObj[t]) .. "|r")
			else
				a.puntos:SetText(L("tienesBuild", cur >= pObj[t] and VERDE or AMARILLO, cur, AMARILLO, pObj[t]))
			end
			for i, d in ipairs(info[t]) do
				local c = a.celdas[i]
				if not c then
					c = CrearCelda(t, a)
					a.celdas[i] = c
				end
				c.i = i
				c:ClearAllPoints()
				c:SetPoint("TOPLEFT", 20 + (d.col - 1) * 48, -42 - (d.fila - 1) * CELDA)
				c.icono:SetTexture(d.icono)
				local o, r = obj[t][i], d.rango
				local brillo, color, texto
				if edicion then
					texto = o .. "/" .. d.max
					if o > 0 then brillo, color = true, { 0.4, 0.8, 1 } else brillo = false end
				elseif r > o then
					brillo, color, texto = true, { 1, 0.2, 0.2 }, r .. "/" .. o -- sobra (no está en la build)
				elseif o == 0 then
					brillo, texto = false, (r > 0 and r .. "" or "")
				elseif r >= o then
					brillo, color, texto = true, { 0.2, 1, 0.2 }, r .. "/" .. o -- completo
				else
					brillo, color, texto = true, { 1, 0.82, 0 }, r .. "/" .. o -- pendiente
				end
				if t == sigT and i == sigI then color = { 0.3, 0.7, 1 } end -- siguiente en la cola
				c.icono:SetDesaturated(not brillo and r == 0)
				c.icono:SetAlpha((brillo or r > 0) and 1 or 0.45)
				if color then
					c.borde:SetVertexColor(color[1], color[2], color[3])
					c.borde:Show()
				else
					c.borde:Hide()
				end
				c.rango:SetText(texto or "")
				if texto and texto ~= "" then c.fondoRango:Show() else c.fondoRango:Hide() end
				c:Show()
			end
			for i = #info[t] + 1, #a.celdas do a.celdas[i]:Hide() end
		end
	end
end

local leyenda = Texto("GameFontHighlightSmall", AX, -580, 670)

------------------------------------------------------------------------
-- Lógica de la ventana
------------------------------------------------------------------------

local function Filtrar()
	local r = {}
	for _, b in ipairs(BuildsDeClase()) do
		local okModo = filtroModo == "Todos" or b.modo == filtroModo or (filtroModo == "Mías" and b.mia)
		local okRol = filtroRol == "Todos" or b.rol == filtroRol
		if okModo and okRol then table.insert(r, b) end
	end
	return r
end

local function MostrarModoEdicion(enEdicion)
	local normales = { btnActivar, btnPersonalizar, btnBorrar, btnTalentos }
	local editar = { cajaNombre, btnRol, btnGuardar, btnMisTalentos, btnLimpiar, btnCancelar }
	for _, b in ipairs(normales) do if enEdicion then b:Hide() else b:Show() end end
	for _, b in ipairs(editar) do if enEdicion then b:Show() else b:Hide() end end
end

local function DetalleEdicion(info)
	local total = Total(edicion)
	local valida = Alcanzable(edicion, info)
	detNombre:SetText(AZUL .. L("editando") .. "|r")
	detInfo:SetText(L("editAyuda"))
	local txt = L("editPuntos", total > 0 and AMARILLO or GRIS, total, MAX_PUNTOS, Reparto(edicion))
	if total == 0 then
		txt = txt .. GRIS .. L("editVacia")
	elseif not valida then
		txt = txt .. ROJO .. L("editInalcanzable")
	else
		txt = txt .. VERDE .. L("editValida")
	end
	detEstado:SetText(txt)
	btnRol:SetText(L("rolBoton", L(rolEdicion)))
	if total > 0 and valida and cajaNombre:GetText() ~= "" then btnGuardar:Enable() else btnGuardar:Disable() end
	barra:Hide()
	DibujarArboles(edicion, info)
	leyenda:SetText(AZUL .. L("editLeyenda"))
end

local function DetalleBuild(b, info)
	local obj, total, err = Decodificar(b.codigo, info)
	detNombre:SetText(NombreBuild(b))
	btnActivar:Disable()
	btnPersonalizar:Enable()
	if b.mia then btnBorrar:Enable() else btnBorrar:Disable() end
	if not obj then
		detInfo:SetText(ROJO .. L("invalida", err) .. "|r")
		detEstado:SetText("")
		barra:Hide()
		btnPersonalizar:Disable()
		for _, a in ipairs(arboles) do a:Hide() end
		return
	end
	detInfo:SetText(L("detalle", AMARILLO, L(b.rol), AMARILLO, L(b.modo), total, Reparto(obj)))

	local estado, sobran, gastados = Comparar(obj, info)
	local puede = true
	if estado == "limpio" then
		detEstado:SetText(VERDE .. L("limpio"))
	elseif estado == "compatible" then
		detEstado:SetText(VERDE .. L("compatible", gastados))
	else
		puede = false
		local l = {}
		for k = 1, math.min(3, #sobran) do l[k] = sobran[k] end
		detEstado:SetText(ROJO .. L("conflicto") .. GRIS .. L("sobran", table.concat(l, ", ")) ..
			(#sobran > 3 and L("yMas", #sobran - 3) or "") .. "|r")
	end

	-- Etapa del jugador dentro de la build
	local hechos = 0
	for t = 1, #info do for i, d in ipairs(info[t]) do hechos = hechos + math.min(d.rango, obj[t][i]) end end
	barra:Show()
	barra:SetMinMaxValues(0, math.max(total, 1))
	barra:SetValue(hechos)
	barraTexto:SetText(L("etapa", hechos, total, total > 0 and math.floor(hechos * 100 / total) or 0))

	btnActivar:SetScript("OnClick", function() Activar(b) Refrescar() end)
	if puede and not (DB.activo and DB.activo.codigo == b.codigo) then btnActivar:Enable() end
	DibujarArboles(obj, info)
	leyenda:SetText(VERDE .. L("leyenda", AMARILLO, AZUL, ROJO, GRIS))
end

-- Textos fijos (se vuelven a poner al cambiar de idioma)
local function AplicarIdioma()
	for _, b in ipairs(etiquetas) do
		if b.clave == "rolBoton" then b:SetText(L("rolBoton", L(rolEdicion))) else b:SetText(L(b.clave)) end
	end
	lblModo:SetText(L("modo"))
	lblRol:SetText(L("rol"))
	if Idioma() == "en" then
		btnIdioma.texto:SetText(GRIS .. "ES|r | " .. AMARILLO .. "EN|r")
	else
		btnIdioma.texto:SetText(AMARILLO .. "ES|r | " .. GRIS .. "EN|r")
	end
end

Refrescar = function()
	if not DB or not UI:IsShown() then return end
	local info = LeerArbol()
	AplicarIdioma()
	titulo:SetText(L("titulo", claseLocal, UnitLevel("player")))
	for v, b in pairs(botonesModo) do if v == filtroModo then b:LockHighlight() else b:UnlockHighlight() end end
	for v, b in pairs(botonesRol) do if v == filtroRol then b:LockHighlight() else b:UnlockHighlight() end end

	local lista = Filtrar()
	local esta = false
	for _, b in ipairs(lista) do if b == seleccion then esta = true end end
	if not esta and not edicion then seleccion = lista[1] end

	for k, f in ipairs(filas) do
		local b = lista[k]
		if b then
			local obj = Decodificar(b.codigo, info)
			local color = b.mia and AZUL or (b.modo == "PvP" and "|cffff8080" or "|cff80c0ff")
			local etiqueta = b.mia and L("Mía") or L(b.modo)
			local activa = (DB.activo and DB.activo.codigo == b.codigo) and (VERDE .. L("activa") .. "|r") or ""
			f.texto:SetText(string.format("%s[%s]|r %s %s%s|r%s", color, etiqueta, NombreBuild(b), GRIS, obj and Reparto(obj) or "?", activa))
			f.build = b
			if b == seleccion then f.sel:Show() else f.sel:Hide() end
			f:Show()
		else
			f:Hide()
		end
	end

	MostrarModoEdicion(edicion ~= nil)
	if edicion then
		DetalleEdicion(info)
	elseif seleccion then
		DetalleBuild(seleccion, info)
	else
		detNombre:SetText(filtroModo == "Mías" and L("sinMias") or L("sinFiltro"))
		detInfo:SetText(filtroModo == "Mías" and L("sinMiasAyuda") or "")
		detEstado:SetText("")
		barra:Hide()
		btnActivar:Disable()
		btnBorrar:Disable()
		btnPersonalizar:Enable()
		DibujarArboles(RangosActuales(info), info) -- sin selección: tus talentos actuales
		leyenda:SetText(GRIS .. L("mostrandoActuales"))
	end

	if DB.activo and DB.activo.clase == clase then
		local obj, total = Decodificar(DB.activo.codigo, info)
		local gastados = 0
		for t = 1, #info do for _, d in ipairs(info[t]) do gastados = gastados + d.rango end end
		local sig = ""
		if obj then
			local t, i = SiguientePaso(obj, info, RangosActuales(info))
			sig = t and L("siguiente", AZUL .. info[t][i].nombre .. "|r") or (VERDE .. L("completaTxt") .. "|r")
		end
		actTexto:SetText(L("activaTxt", AMARILLO, NombreBuild(DB.activo),
			DB.pausado and (ROJO .. L("pausaTag") .. "|r") or (VERDE .. L("onTag") .. "|r"),
			gastados, total or 0, Libres(), sig))
		btnPausa:SetText(DB.pausado and L("reanudar") or L("pausar"))
		btnPausa:Enable()
		btnQuitar:Enable()
	else
		actTexto:SetText(GRIS .. L("sinActiva"))
		btnPausa:Disable()
		btnQuitar:Disable()
	end
end

-- Acciones de los botones
local function CambiarIdioma(nuevo)
	DB.idioma = nuevo or (Idioma() == "es" and "en" or "es")
	msg(L("chatIdioma"))
	Refrescar()
end
btnIdioma:SetScript("OnClick", function() CambiarIdioma() end)
btnIdioma:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:AddLine(L("idiomaTip"))
	GameTooltip:Show()
end)
btnIdioma:SetScript("OnLeave", function() GameTooltip:Hide() end)

btnPersonalizar:SetScript("OnClick", function()
	local info = LeerArbol()
	edicion = seleccion and Decodificar(seleccion.codigo, info) or RangosVacios(info)
	rolEdicion = seleccion and seleccion.rol or "DPS"
	if seleccion then
		cajaNombre:SetText(seleccion.mia and seleccion.nombre or (NombreBuild(seleccion) .. L("mia")))
	else
		cajaNombre:SetText(L("miBuild"))
	end
	Refrescar()
end)
btnCancelar:SetScript("OnClick", function() edicion = nil cajaNombre:ClearFocus() Refrescar() end)
btnLimpiar:SetScript("OnClick", function() edicion = RangosVacios(LeerArbol()) Refrescar() end)
btnMisTalentos:SetScript("OnClick", function() edicion = RangosActuales(LeerArbol()) Refrescar() end)
cajaNombre:SetScript("OnTextChanged", function() if edicion then Refrescar() end end)
btnGuardar:SetScript("OnClick", function()
	local nombre = cajaNombre:GetText()
	local codigo = Codificar(edicion)
	local lista = Mias()
	local b
	for _, x in ipairs(lista) do if x.nombre == nombre then b = x end end
	if b then
		b.codigo, b.rol = codigo, rolEdicion
	else
		b = { nombre = nombre, codigo = codigo, rol = rolEdicion, modo = "Mía", mia = true }
		table.insert(lista, b)
	end
	-- si era la build activa, actualiza la cola con los cambios
	if DB.activo and DB.activo.nombre == nombre then DB.activo.codigo = codigo reintento = 0.5 end
	msg(L("chatGuardada", AZUL, nombre, Reparto(edicion)))
	edicion = nil
	cajaNombre:ClearFocus()
	seleccion = b
	filtroModo = "Mías"
	Refrescar()
end)
btnBorrar:SetScript("OnClick", function()
	if not seleccion or not seleccion.mia then return end
	local lista = Mias()
	for k, x in ipairs(lista) do if x == seleccion then table.remove(lista, k) break end end
	msg(L("chatBorrada", seleccion.nombre))
	seleccion = nil
	Refrescar()
end)
btnPausa:SetScript("OnClick", function()
	DB.pausado = not DB.pausado
	msg(DB.pausado and L("chatPausa") or L("chatSeguir"))
	if not DB.pausado then reintento = 0.3 end
	Refrescar()
end)
btnQuitar:SetScript("OnClick", function()
	msg(L("chatQuitada", DB.activo and NombreBuild(DB.activo) or ""))
	DB.activo = nil
	Refrescar()
end)

UI:SetScript("OnShow", function() Refrescar() end)
UI:SetScript("OnHide", function() edicion = nil cajaNombre:ClearFocus() end)

local function Alternar()
	if UI:IsShown() then UI:Hide() else UI:Show() end
end

------------------------------------------------------------------------
-- Botón del minimapa
------------------------------------------------------------------------

local mini = CreateFrame("Button", "UltimoTalentoMinimapButton", Minimap)
SZ(mini, 31, 31)
mini:SetFrameStrata("MEDIUM")
mini:SetFrameLevel(8)
mini:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
local icono = mini:CreateTexture(nil, "BACKGROUND")
icono:SetTexture("Interface\\Icons\\INV_Misc_Book_11")
SZ(icono, 20, 20)
icono:SetPoint("TOPLEFT", 7, -5)
local borde = mini:CreateTexture(nil, "OVERLAY")
borde:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
SZ(borde, 53, 53)
borde:SetPoint("TOPLEFT")
local function PosMini()
	local a = math.rad(DB and DB.minimapa or 200)
	mini:ClearAllPoints()
	mini:SetPoint("CENTER", Minimap, "CENTER", math.cos(a) * 80, math.sin(a) * 80)
end
mini:RegisterForDrag("LeftButton")
mini:SetScript("OnDragStart", function(self)
	self:SetScript("OnUpdate", function()
		local mx, my = Minimap:GetCenter()
		local cx, cy = GetCursorPosition()
		local s = Minimap:GetEffectiveScale()
		DB.minimapa = math.deg(math.atan2(cy / s - my, cx / s - mx))
		PosMini()
	end)
end)
mini:SetScript("OnDragStop", function(self) self:SetScript("OnUpdate", nil) end)
mini:SetScript("OnClick", Alternar)
mini:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:AddLine("UltimoTalento")
	GameTooltip:AddLine(DB.activo and L("miniBuild", NombreBuild(DB.activo)) or L("miniSin"), 1, 1, 1)
	GameTooltip:AddLine(L("miniAyuda"), 0.6, 0.6, 0.6)
	GameTooltip:Show()
end)
mini:SetScript("OnLeave", function() GameTooltip:Hide() end)

------------------------------------------------------------------------
-- Eventos y comandos
------------------------------------------------------------------------

motor:RegisterEvent("PLAYER_LOGIN")
motor:RegisterEvent("CHARACTER_POINTS_CHANGED")
motor:RegisterEvent("PLAYER_LEVEL_UP")
motor:RegisterEvent("PLAYER_REGEN_ENABLED")
motor:RegisterEvent("PLAYER_TALENT_UPDATE")
motor:SetScript("OnEvent", function(self, ev)
	if ev == "PLAYER_LOGIN" then
		UltimoTalentoDB = UltimoTalentoDB or {}
		DB = UltimoTalentoDB
		DB.idioma = DB.idioma or "es"
		PosMini()
		reintento = 3
		if DB.activo then
			msg(L("chatLogin", NombreBuild(DB.activo), DB.pausado and L("chatEnPausa") or ""))
		else
			msg(L("chatBienvenida"))
		end
	elseif DB then
		if not pendiente then reintento = math.max(reintento, 1) end
		Refrescar()
	end
end)

SLASH_ULTIMOTALENTO1 = "/ut"
SLASH_ULTIMOTALENTO2 = "/tc"
SlashCmdList.ULTIMOTALENTO = function(arg)
	arg = (arg or ""):lower()
	if not DB then return end
	if arg == "pausa" or arg == "pause" then
		DB.pausado = true msg(L("chatPausa")) Refrescar()
	elseif arg == "seguir" or arg == "resume" then
		DB.pausado = nil msg(L("chatSeguir")) reintento = 0.3 Refrescar()
	elseif arg == "en" or arg == "es" then
		CambiarIdioma(arg)
	else
		Alternar()
	end
end
