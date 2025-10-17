# StaticMapView Widget

## Descripción

`StaticMapView` es un widget de mapa estático que muestra una ubicación específica con un marcador. Se ajusta automáticamente al tamaño de su contenedor padre y es ideal para mostrar ubicaciones previamente seleccionadas sin interacción del usuario.

## Características

- 📍 Muestra una ubicación específica en el mapa
- 📏 Se ajusta al tamaño del contenedor padre
- 🎯 Marcador personalizable
- 🔒 Interacciones deshabilitadas por defecto (vista estática)
- 🎨 Bordes redondeados
- 🔄 Actualización automática al cambiar la ubicación

## Uso Básico

```dart
import 'package:ui/widgets/map/static_map_view.dart';
import 'package:latlong2/latlong.dart';

// Uso simple
Container(
  height: 300,
  child: StaticMapView(
    location: LatLng(4.7110, -74.0721),
  ),
)
```

## Propiedades

| Propiedad | Tipo | Por defecto | Descripción |
|-----------|------|-------------|-------------|
| `location` | `LatLng` | **requerido** | Ubicación a mostrar en el mapa |
| `zoom` | `double` | `15.0` | Nivel de zoom del mapa |
| `showMarker` | `bool` | `true` | Mostrar marcador en la ubicación |
| `markerIcon` | `IconData` | `Icons.person_pin_circle` | Icono del marcador |
| `markerColor` | `Color` | `Colors.red` | Color del marcador |
| `markerSize` | `double` | `40` | Tamaño del marcador |
| `enableInteractions` | `bool` | `false` | Habilitar interacciones del mapa |

## Ejemplos

### 1. Vista Estática Básica (300px de alto)

```dart
Container(
  height: 300,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  ),
  child: StaticMapView(
    location: LatLng(4.7110, -74.0721),
  ),
)
```

### 2. Con Marcador Personalizado

```dart
StaticMapView(
  location: LatLng(4.7110, -74.0721),
  markerIcon: Icons.store,
  markerColor: Colors.blue,
  markerSize: 50,
)
```

### 3. Zoom Cercano

```dart
StaticMapView(
  location: LatLng(4.7110, -74.0721),
  zoom: 18.0, // Muy cerca
)
```

### 4. Sin Marcador

```dart
StaticMapView(
  location: LatLng(4.7110, -74.0721),
  showMarker: false, // Solo el mapa
)
```

### 5. Con Interacciones Habilitadas

```dart
StaticMapView(
  location: LatLng(4.7110, -74.0721),
  enableInteractions: true, // Usuario puede hacer zoom/pan
)
```

### 6. Adaptable al Contenedor

```dart
// El widget se ajusta automáticamente
Expanded(
  child: StaticMapView(
    location: LatLng(4.7110, -74.0721),
  ),
)

// O con dimensiones específicas
SizedBox(
  width: 400,
  height: 250,
  child: StaticMapView(
    location: LatLng(4.7110, -74.0721),
  ),
)
```

## Integración en Formularios

### Ejemplo: LocationMapStep

```dart
import 'package:ui/widgets/map/static_map_view.dart';

class LocationMapStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final location = controller.location.value;
      
      return Column(
        children: [
          ElevatedButton(
            onPressed: () => selectLocation(context),
            child: Text('Seleccionar ubicación'),
          ),
          
          // Mostrar mapa cuando hay ubicación
          if (location != null) ...[
            const SizedBox(height: 16),
            Container(
              height: 300,
              child: StaticMapView(
                location: location,
                zoom: 16.0,
                markerIcon: Icons.location_on,
                markerColor: Colors.red,
              ),
            ),
          ],
        ],
      );
    });
  }
}
```

## Comportamiento

### Actualización Automática

El widget detecta cambios en la ubicación y actualiza el mapa automáticamente:

```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  LatLng location = LatLng(4.7110, -74.0721);
  
  void updateLocation(LatLng newLocation) {
    setState(() {
      location = newLocation; // El mapa se actualiza automáticamente
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return StaticMapView(location: location);
  }
}
```

## Estilos de Mapa

El widget usa el estilo de mapa configurado en `.env`:

```env
MAPBOX_DARK_URL=https://api.mapbox.com/styles/v1/{mapStyleId}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}
MAPBOX_DARK_STYLE_ID=mapbox/dark-v11
MAPBOX_ACCESS_TOKEN=your_token_here
```

Estilos disponibles:
- `mapbox/streets-v11` - Calles
- `mapbox/outdoors-v11` - Exterior
- `mapbox/light-v11` - Claro
- `mapbox/dark-v11` - Oscuro (por defecto)
- `mapbox/satellite-v9` - Satélite

## Casos de Uso

### 1. Vista Previa de Ubicación Seleccionada
```dart
// Después de que el usuario selecciona una ubicación
Container(
  height: 300,
  child: StaticMapView(
    location: selectedLocation,
    zoom: 16.0,
  ),
)
```

### 2. Lista de Ubicaciones
```dart
ListView.builder(
  itemCount: locations.length,
  itemBuilder: (context, index) {
    return Card(
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: StaticMapView(
              location: locations[index],
              zoom: 14.0,
            ),
          ),
          ListTile(
            title: Text('Ubicación ${index + 1}'),
          ),
        ],
      ),
    );
  },
)
```

### 3. Confirmación de Dirección
```dart
Column(
  children: [
    Text('¿Es esta la ubicación correcta?'),
    Container(
      height: 300,
      child: StaticMapView(location: address),
    ),
    ElevatedButton(
      onPressed: confirmAddress,
      child: Text('Confirmar'),
    ),
  ],
)
```

## Diferencias con LocationPickerPage

| Característica | StaticMapView | LocationPickerPage |
|----------------|---------------|-------------------|
| Propósito | Mostrar ubicación | Seleccionar ubicación |
| Interacciones | Deshabilitadas (por defecto) | Habilitadas |
| Pin | Fijo en la ubicación | Centrado en pantalla |
| Uso | Vista previa | Selección activa |
| Tamaño | Se ajusta al padre | Pantalla completa |

## Rendimiento

- ✅ Ligero y rápido
- ✅ Cache de tiles automático
- ✅ No consume recursos cuando no es visible
- ✅ Actualización eficiente al cambiar ubicación

## Tips

1. **Usa bordes redondeados** para mejor apariencia:
   ```dart
   Container(
     decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
     child: StaticMapView(location: location),
   )
   ```

2. **Agrega sombra** para destacar el mapa:
   ```dart
   Container(
     decoration: BoxDecoration(
       boxShadow: [
         BoxShadow(
           color: Colors.black.withOpacity(0.1),
           blurRadius: 8,
         ),
       ],
     ),
     child: StaticMapView(location: location),
   )
   ```

3. **Define altura explícita** para mejor control:
   ```dart
   Container(
     height: 300, // Altura fija
     child: StaticMapView(location: location),
   )
   ```

## Troubleshooting

### Mapa no se muestra
- Verifica que MAPBOX_ACCESS_TOKEN esté en `.env`
- Verifica conexión a internet
- Verifica que el contenedor tenga altura definida

### Marcador no aparece
- Verifica que `showMarker: true`
- Verifica que el `markerSize` sea visible
- Verifica que el `markerColor` contraste con el mapa

### Mapa se ve cortado
- Define altura explícita en el contenedor padre
- Usa `ClipRRect` para bordes redondeados
- Verifica que el contenedor tenga espacio suficiente

## Licencia

Parte del paquete UI de Bartoo monorepo.
