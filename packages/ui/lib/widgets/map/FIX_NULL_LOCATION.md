# Fix: Navigator.pop() no retornaba la ubicación

## 🐛 Problema

Cuando el usuario seleccionaba una ubicación y confirmaba, el `Log` mostraba `null`:

```dart
Log('Selected location: $selectedLocation'); // Imprimía null
```

## 🔍 Causa

En el archivo `location_picker_page.dart`, el método `_confirmLocation()` estaba haciendo:

```dart
void _confirmLocation() {
  if (_currentCenter != null) {
    widget.onLocationSelected(_currentCenter!);
    Navigator.of(context).pop(); // ❌ No pasaba el valor
  }
}
```

El `Navigator.pop()` se llamaba **sin pasar el valor**, por lo que el `Future<LatLng?>` retornado por `navigateToLocationPicker` siempre era `null`.

## ✅ Solución

Cambié el `pop()` para que retorne la ubicación:

```dart
void _confirmLocation() {
  if (_currentCenter != null) {
    widget.onLocationSelected(_currentCenter!);
    Navigator.of(context).pop(_currentCenter); // ✅ Ahora pasa el valor
  }
}
```

## 📝 Cómo funciona ahora

### 1. Usuario selecciona ubicación
```
LocationPickerPage
  ↓
Usuario mueve el mapa
  ↓
_currentCenter = nueva ubicación
```

### 2. Usuario confirma
```
Botón "CONFIRMAR" → _confirmLocation()
  ↓
widget.onLocationSelected(_currentCenter) // Callback
  ↓
Navigator.pop(_currentCenter) // ✅ Retorna el valor
```

### 3. En el map_step.dart
```dart
final selectedLocation = await navigateToLocationPicker(...);
// Ahora selectedLocation tiene el valor LatLng correcto ✅

Log('Selected location: $selectedLocation'); 
// Imprime: Selected location: LatLng(4.711000, -74.072100)

if (selectedLocation != null) {
  controller.setLocation(selectedLocation); // ✅ Funciona
}
```

## 🔄 Flujo completo

```
map_step.dart
  ↓
navigateToLocationPicker() →  LocationPickerPage
  ↓                                     ↓
  ←  Navigator.pop(location)  ←  _confirmLocation()
  ↓
selectedLocation = LatLng(...)  ✅
  ↓
controller.setLocation(selectedLocation)
  ↓
UI actualizada con Obx()
```

## ✅ Verificación

Ahora el log debe mostrar:
```
Selected location: LatLng(4.711000, -74.072100)
```

Y la ubicación se guardará correctamente en el controlador.

## 📚 Patrón Navigator.pop con valores

### ❌ Incorrecto
```dart
Navigator.of(context).pop(); // No retorna nada
```

### ✅ Correcto
```dart
Navigator.of(context).pop(value); // Retorna el valor
```

### Recibir el valor
```dart
final result = await Navigator.of(context).push<Type>(
  MaterialPageRoute(builder: (context) => MyPage()),
);

// result contiene el valor pasado en pop(value)
```

## 🎯 Archivos modificados

- **`packages/ui/lib/widgets/map/location_picker_page.dart`**
  - Línea ~110: `Navigator.of(context).pop(_currentCenter);`

## ✨ Resultado

- ✅ `selectedLocation` ahora tiene el valor correcto
- ✅ `controller.setLocation()` recibe la ubicación
- ✅ El mapa estático se muestra con la ubicación
- ✅ El log muestra las coordenadas correctas

¡Fix aplicado exitosamente! 🎉
