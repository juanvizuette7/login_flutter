# 📂 SafeDocs – Gestión Segura de Documentos con Flutter + Supabase

SafeDocs es una aplicación multiplataforma desarrollada en **Flutter** que permite a los usuarios **subir, almacenar y consultar documentos (PDF, Word, Excel, TXT)** en la nube de forma **segura y accesible** usando **Supabase**.

Este proyecto fue desarrollado como caso de estudio para la **Universidad Cooperativa de Colombia (UCC)**, demostrando el uso práctico de **Flutter + Supabase** en la construcción de aplicaciones innovadoras.

---

## ✨ Características

- 🔑 **Autenticación de usuarios** (registro e inicio de sesión con Supabase Auth).
- 📤 **Subida de documentos** a Supabase Storage (`safe-docs`).
- 📝 **Formulario de metadatos** al subir: título y categoría (Académico, Legal, Financiero, Personal, Otro).
- 📂 **Organización de archivos** por usuario autenticado.
- 🔍 **Filtro por categorías** para encontrar documentos fácilmente.
- 📑 **Vista de documentos con íconos** según el tipo de archivo (PDF, Word, Excel, TXT).
- 🌐 **Multiplataforma**: funciona en **Web, Android y Windows**.

---

## 🚀 Tecnologías Usadas

- **Flutter 3.x**
- **Dart**
- **Supabase (Auth + Database + Storage)**
- **flutter_dotenv** para manejar credenciales seguras
- **Material 3** para diseño moderno

---

## 📲 Caso de Estudio

### 📝 Problema
En la vida académica y profesional, los estudiantes y docentes deben **gestionar múltiples documentos** (proyectos, evidencias, certificados, reportes legales, balances financieros, etc.).  
Estos archivos suelen perderse, estar dispersos en correos o no tener un respaldo confiable.

### 💡 Solución
**SafeDocs** proporciona un repositorio personal en la nube:  
- Cada usuario se registra e inicia sesión.  
- Puede subir cualquier documento con un título y categoría.  
- Los archivos quedan respaldados en Supabase Storage.  
- Se pueden consultar y descargar en cualquier momento.  

### 🎯 Impacto
- ✅ Seguridad y respaldo de documentos.  
- ✅ Acceso inmediato desde cualquier dispositivo.  
- ✅ Organización por categorías.  
- ✅ Escalable a otros usos (académicos, legales, financieros).  

---

## ⚙️ Instalación y Uso

### 1. Clonar el repositorio
```bash
git clone https://github.com/juanvizuette7/login_flutter.git
cd login_flutter
