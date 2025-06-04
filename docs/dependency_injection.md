Guía Profunda: Inyección de Dependencias (DI) Básica en Docudex
1. Problema Actual
Tu código actual tiene estas limitaciones:

Instancias directas: Usas DatabaseHelper() directamente en las pantallas.

Acoplamiento fuerte: Cambiar una implementación (ej: mock para tests) requiere modificar múltiples archivos.

Dificultad para testing: No puedes reemplazar fácilmente dependencias en pruebas.

2. ¿Qué es la Inyección de Dependencias?
Patrón que inyecta dependencias desde fuera en lugar de crearlas internamente.
Ejemplo:
```dart
// ❌ Antes (acoplado)
class DocumentListScreen {
  final dbHelper = DatabaseHelper(); // Creación interna
}

// ✅ Después (inyectado)
class DocumentListScreen {
  final DatabaseHelper dbHelper;
  DocumentListScreen(this.dbHelper); // Inyección por constructor
}
```
3. Implementación Paso a Paso
**Paso 1: Crear un Contenedor de Dependencias**
```dart
// lib/core/dependency_container.dart
class DIContainer {
  static final DatabaseHelper dbHelper = DatabaseHelper();
  // Repositorios (si usas el patrón Repository)
  static final DocumentRepository documentRepo = DocumentRepositoryImpl(dbHelper);
  static final CategoryRepository categoryRepo = CategoryRepositoryImpl(dbHelper);
}
```

**Paso 2: Modificar Pantallas para Recibir Dependencias**
```dart
// lib/screens/document_list_screen.dart
class DocumentListScreen extends StatelessWidget {
  final DocumentRepository documentRepo;

  const DocumentListScreen({required this.documentRepo, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Usar documentRepo en lugar de DatabaseHelper()
  }
}
```

**Paso 3: Inyectar en el Punto de Entrada**
```dart
// lib/main.dart
void main() {
  runApp(
    ArchivoCentralApp(
      documentRepo: DIContainer.documentRepo,
    ),
  );
}

class ArchivoCentralApp extends StatelessWidget {
  final DocumentRepository documentRepo;

  const ArchivoCentralApp({required this.documentRepo, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DocumentListScreen(documentRepo: documentRepo),
    );
  }
}
```
4. Beneficios Clave
* **Testing fácil**:
```dart
testWidgets('DocumentListScreen', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: DocumentListScreen(
        documentRepo: MockDocumentRepository(), // Implementación fake
      ),
    ),
  );
});
```
* Flexibilidad: Cambiar DatabaseHelper por una versión con cache sin tocar pantallas.
* Single Responsibility: Cada clase se enfoca en su rol sin crear dependencias.

5. Casos Especiales
Para Widgets que Necesitan Dependencias:
```dart
class DocumentCard extends StatelessWidget {
  final Document document;
  final DocumentRepository documentRepo;

  const DocumentCard({
    required this.document,
    required this.documentRepo,
    Key? key,
  }) : super(key: key);
}
```

Para Dependencias en Rutas Nombradas:
```dart
MaterialApp(
  routes: {
    '/': (context) => DocumentListScreen(
      documentRepo: DIContainer.documentRepo,
    ),
  },
);
```

6. Alternativas para Proyectos Más Grandes
| Librería   | Ventajas                          | Uso Recomendado            |
|------------|----------------------------------|----------------------------|
| get_it     | Sencillo, sin boilerplate        | Apps pequeñas/medianas     |
| Riverpod   | Integrado con state management   | Apps complejas             |
| injectable | Generación de código automática  | Proyectos muy grandes      |

Ejemplo con get_it:
```dart
final getIt = GetIt.instance;
void setupDI() {
  getIt.registerSingleton<DatabaseHelper>(DatabaseHelper());
  getIt.registerSingleton<DocumentRepository>(DocumentRepositoryImpl(getIt()));
}

final documentRepo = getIt<DocumentRepository>();
```

7. Errores Comunes
* **Inyectar demasiadas dependencias**: Mejor dividir en widgets más pequeños.
* **Olvidar dispose** en controladores.
* **Usar singletons innecesarios**: solo para servicios globales.

8. Migración Gradual
* Empieza por las dependencias más críticas.
* Refactoriza pantallas una a una para usar `DIContainer.documentRepo` en lugar de `DatabaseHelper()`.
* Haz pruebas después de cada cambio.

**Conclusión**
La inyección de dependencias básica:
* Mejora la mantenibilidad del código.
* Facilita testing y cambios futuros.
* Requiere poco esfuerzo inicial (aprox. 20 min para configurar).
