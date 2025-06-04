Guía Profunda: Widgets Reutilizables en Flutter
1. Problema Actual en Docudex
En tu código, identificamos estos pain points:

Duplicación de UI: Los mismos campos de formulario (ej: dropdowns de ubicación) se repiten en múltiples pantallas con lógica similar.

Falta de consistencia: Cambiar el estilo de un input requiere modificar varios archivos.

Código inflado: Pantallas como add_edit_document_screen.dart mezclan lógica de negocio con UI.

2. Filosofía de Widgets Reutilizables
Principios clave:

Single Responsibility: Cada widget hace una cosa y la hace bien.

Composición: Construye interfaces complejas combinando widgets simples.

Customización Controlada: Expone parámetros para adaptarse a diferentes contextos.

3. Implementación Paso a Paso
Paso 1: Identificar Patrones Repetitivos
Ejemplos en Docudex:

Dropdowns de ubicación (Sala/Área/Caja)

Inputs de texto con label y validación

Selectores de fecha

Paso 2: Diseñar la API del Widget
Para el dropdown de ubicación:

```dart
class LocationDropdown extends StatelessWidget {
  final String type; // 'room', 'area', 'box'
  final String? value;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;
  final bool showAddButton;

  const LocationDropdown({
    required this.type,
    required this.onChanged,
    this.value,
    this.validator,
    this.showAddButton = true,
  });
}
```

Paso 3: Implementar Lógica Interna

```dart
@override
Widget build(BuildContext context) {
  final locations = context.watch<LocationProvider>().getByType(type);

  return DropdownButtonFormField<String>(
    value: value,
    items: locations.map((loc) => DropdownMenuItem(
      value: loc,
      child: Text(loc),
    )).toList(),
    onChanged: onChanged,
    validator: validator,
    decoration: InputDecoration(
      labelText: 'Ubicación - ${type.capitalize()}',
      suffixIcon: showAddButton ? IconButton(
        icon: const Icon(Icons.add),
        onPressed: () => _addNewLocation(context, type),
      ) : null,
    ),
  );
}
```

Paso 4: Manejar Dependencias
Acceso a datos: Usa un Provider o repositorio inyectado.

Eventos complejos: Expón callbacks como onAddNewLocation.

4. Beneficios Clave
Consistencia visual: Todos los dropdowns se ven y comportan igual.

Mantenimiento simplificado: Cambios centralizados en un solo archivo.

Testing aislado: Puedes testear el widget independientemente.

5. Ejemplo Avanzado: Input con Validación

```dart
class LabeledTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? hint;
  final bool isRequired;
  final TextInputType? keyboardType;

  const LabeledTextField({
    this.controller,
    required this.label,
    this.hint,
    this.isRequired = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label + (isRequired ? '*' : ''),
        hintText: hint,
      ),
      validator: isRequired 
          ? (value) => value!.isEmpty ? '$label es obligatorio' : null
          : null,
      keyboardType: keyboardType,
    );
  }
}
```

6. Integración en Pantallas
Antes:

```dart
// En add_edit_document_screen.dart
DropdownButtonFormField(
  value: selectedRoom,
  items: rooms.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
  onChanged: (val) => setState(() => selectedRoom = val),
  decoration: InputDecoration(labelText: 'Sala'),
)
```

Después:

```dart
LocationDropdown(
  type: 'room',
  value: selectedRoom,
  onChanged: (val) => setState(() => selectedRoom = val),
)
```

7. Testing del Widget

```dart
testWidgets('LocationDropdown muestra opciones', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: LocationDropdown(
          type: 'room',
          onChanged: (val) {},
        ),
      ),
    ),
  );

  expect(find.text('Ubicación - Room'), findsOneWidget);
  await tester.tap(find.byType(DropdownButtonFormField<String>));
  await tester.pump();
});
```

8. Errores Comunes a Evitar
Sobrediseño:
❌ Crear props para cada pequeña variación.
✅ Exponer solo las customizaciones necesarias.

Ignorar el contexto:

```dart
// ❌ Mal
final rooms = DatabaseHelper().getRooms();

// ✅ Bien
final rooms = context.watch<LocationProvider>().rooms;
```

Olvidar la accesibilidad:

```dart
Semantics(
  label: 'Selector de $type',
  child: DropdownButtonFormField(...),
)
```

9. Migración Gradual
Empieza por el componente más repetido (ej: dropdowns de ubicación).

Refactoriza una pantalla a la vez.

Haz commits atómicos:

"feat: add LocationDropdown widget"

"refactor: migrate add_document screen to use LocationDropdown"

