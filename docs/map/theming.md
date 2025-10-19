# Theming & Styles (Summary)

## Goal
Consistent dark/light Mapbox styles across all map widgets using a single source of truth.

## How It Works
- Global `ThemeManager` (GetX + ChangeNotifier) holds `isDark`
- `BaseThemedMap` listens and rebuilds the TileLayer accordingly
- Map styles come from `.env` (with sensible defaults)

## BaseThemedMap
Use this wherever a themed map is needed. It accepts:
- `mapController`, `center` (required)
- `zoom`, `minZoom`, `maxZoom`
- `onPositionChanged`
- `additionalLayers` (markers, polylines)
- `interactionOptions`

## Env Variables
```env
MAPBOX_ACCESS_TOKEN=your_token
MAPBOX_DARK_STYLE_ID=mapbox/dark-v11
MAPBOX_DARK_URL=https://api.mapbox.com/styles/v1/{mapStyleId}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}
MAPBOX_LIGHT_STYLE_ID=mapbox/streets-v12
MAPBOX_LIGHT_URL=https://api.mapbox.com/styles/v1/{mapStyleId}/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}
```

## Common Pitfalls
- Theme not updating: ensure widgets listen (AnimatedBuilder/ListenableBuilder) or use BaseThemedMap
- Wrong style after toggle: update `ThemeManager.toggleTheme()` to flip internal `isDark` first, then apply GetX theme

## Where To Dive Deeper
- BaseThemedMap guide: packages/ui/lib/widgets/map/BASE_THEMED_MAP.md
- Theme reactivity fix: packages/ui/lib/widgets/map/THEME_REACTIVITY_FIX.md
- GetX integration: packages/ui/lib/widgets/map/GETX_THEME_INTEGRATION.md
