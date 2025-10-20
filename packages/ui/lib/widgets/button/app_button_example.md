# AppButton Widget

Widget de botón reutilizable con múltiples variaciones de estilo.

## Variaciones disponibles

### Primary (Predeterminado)
Usa el color primario del tema (`colorScheme.primary`).
```dart
AppButton(
  label: 'Guardar',
  onPressed: () {},
  variation: AppButtonVariation.primary, // opcional, es el valor por defecto
)
```

### Secondary
Usa el color secundario del tema (`colorScheme.secondary`).
```dart
AppButton(
  label: 'Ver más',
  onPressed: () {},
  variation: AppButtonVariation.secondary,
)
```

### Cancel
Usa el color de error del tema (`colorScheme.errorContainer`).
```dart
AppButton(
  label: 'Cancelar',
  onPressed: () {},
  variation: AppButtonVariation.cancel,
)
```

## Propiedades

- `label` (String, requerido): Texto del botón
- `onPressed` (VoidCallback?, requerido): Función al presionar
- `variation` (AppButtonVariation, opcional): Variación de estilo (primary, secondary, cancel)
- `isLoading` (bool, opcional): Muestra un indicador de carga
- `icon` (Widget?, opcional): Icono a mostrar antes del texto
- `width` (double?, opcional): Ancho personalizado
- `height` (double?, opcional): Alto personalizado (por defecto: 50)
- `padding` (EdgeInsetsGeometry?, opcional): Padding interno
- `borderRadius` (BorderRadius?, opcional): Radio de borde (por defecto: 8)
- `backgroundColor` (Color?, opcional): Color de fondo personalizado (sobrescribe la variación)
- `textColor` (Color?, opcional): Color de texto personalizado
- `elevation` (double?, opcional): Elevación del botón (por defecto: 2)

## Ejemplos

### Con icono y carga
```dart
AppButton(
  label: 'Guardar servicios',
  icon: Icon(Icons.save),
  isLoading: isSaving,
  onPressed: () async {
    await saveData();
  },
)
```

### Botón de cancelar con icono
```dart
AppButton(
  label: 'Cancelar y restaurar',
  icon: Icon(Icons.cancel_outlined),
  variation: AppButtonVariation.cancel,
  onPressed: () {
    controller.cancelTemplateSelection();
  },
)
```

### Botón secundario personalizado
```dart
AppButton(
  label: 'Opciones',
  variation: AppButtonVariation.secondary,
  width: 200,
  height: 60,
  borderRadius: BorderRadius.circular(30),
  onPressed: () {},
)
```

## Colores por tema

### Dark Theme
- **Primary**: `#FF9900` (naranja)
- **Secondary**: `#CECFD2` (gris claro)
- **Cancel/Error**: Color de error oscuro

### Light Theme
- **Primary**: `#FF6601` (naranja brillante)
- **Secondary**: `#3F51B5` (índigo)
- **Cancel/Error**: Color de error claro
