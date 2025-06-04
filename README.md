# 📱 Docudex

**Docudex** es una app diseñada para ayudarte a **organizar, encontrar y controlar documentos físicos** de forma rápida y sencilla, aprovechando el potencial de las **etiquetas NFC**.

---

## 🎯 ¿Para qué sirve?

### ✅ 1. Guardar y localizar documentos físicos
- Guarda datos clave de cada documento (ej. “DNI caducado en 2027”).
- Indica su ubicación física: sala, armario, caja.
- Recupéralo fácilmente desde la app.

### ✅ 2. Visualizar estado de urgencia
- Aviso visual si un documento está por vencer o ya vencido.
- Útil para renovaciones, contratos, pólizas, etc.

### ✅ 3. Acceso instantáneo con etiquetas NFC
- Asocia una etiqueta NFC a una carpeta o documento físico.
- Al escanearla, Docudex abre automáticamente el documento asociado.
- Sin escribir ni buscar manualmente.

### ✅ 4. Evitar pérdidas y ahorrar tiempo
- Olvídate de “¿Dónde guardé esto?”.
- Toda la información está centralizada.
- Minimiza errores como olvidar renovar documentos.

---

## 🧠 ¿A quién está dirigido?

- Personas con muchos documentos físicos (facturas, seguros, papeles oficiales).
- Familias que comparten archivadores.
- Usuarios que quieran sacar partido a etiquetas NFC.
- Cualquiera que busque **orden y rapidez sin complicaciones**.

---

## ✅ Funcionalidades implementadas

### 🗂 Gestión de documentos
- Lista de documentos con título, categoría, ubicación y fecha.
- Borde de color según la categoría.
- Indicador visual de urgencia (verde/naranja/rojo).
- Icono personalizado por categoría.
- Botón ➕ para añadir documento.

### 📝 Formulario de Añadir/Editar documento
- Campos: título, sala, área, caja, fecha, nota, referencia.
- Selección de categoría con **color e icono personalizados**.
- Crear nuevas categorías desde el diálogo.
- Autocompletado de ubicaciones desde base de datos.
- Lectura de etiqueta NFC para rellenar el campo de referencia.
- Botón para limpiar la fecha.
- Validaciones con mensajes específicos.

### 🧠 Categorías
- Crear y eliminar categorías con icono y color personalizado.
- Al crear una categoría, se selecciona automáticamente.

### 📄 Detalle del documento
- Visualización completa de la información.
- Botones para editar y eliminar.
- Estilo claro con indicación de urgencia.

### 📶 NFC
- Botón flotante para escanear etiquetas NFC.
- Pantalla dedicada para lectura NFC:
  - Muestra el **texto grabado**, no solo el ID.
  - Manejo de errores si NFC está apagado o no disponible.

---

## 🟡 Pendiente o en progreso

### 📌 Vincular etiqueta NFC a documento
- Al leer una etiqueta, buscar documento por título o referencia.
- Si se encuentra, navegar al detalle.
- Si no, mostrar mensaje de “no encontrado”.

### ✍️ Escritura NFC (opcional)
- Posibilidad de escribir en la etiqueta desde el formulario o el detalle.

### 🔍 Búsqueda y filtros
- Buscar por título, ubicación o referencia.
- Filtros por categoría o urgencia.

### 📦 Exportación y copia de seguridad
- Exportar lista de documentos.
- Importar desde archivo (Excel, JSON...).

### 🎨 Mejoras visuales opcionales
- Modo oscuro consistente.
- Animaciones suaves en transiciones.

---

## 🚧 En desarrollo

Docudex está en constante evolución. ¡Tu feedback es bienvenido!


## License

This project is licensed under the [MIT License](LICENSE).
