# Maps Troubleshooting (Summary)

## Map Not Loading
- Validate `.env` is loaded and token present
- Check network connectivity
- Ensure `urlTemplate` and style IDs are correct

## Null Location On Return
- Confirm Location Picker uses `Navigator.pop(selectedLatLng)`
- Consumer must handle `null` when user cancels

## Dark Style Stuck
- Fix `ThemeManager.toggleTheme()` to toggle internal `isDark` then apply GetX theme; notify listeners
- Verify map widgets rebuild on theme change (use BaseThemedMap)

## Marker/Pin Misalignment
- Use a vertical offset of half the icon size so pin tip aligns to center

## Zoom Issues
- For precise selection, default to zoom ≈ 17
- Adjust min/max zoom to your needs (5–18 typical)

## References
- Fix null return: packages/ui/lib/widgets/map/FIX_NULL_LOCATION.md
- Style bug fix: packages/ui/lib/widgets/map/MAP_STYLE_BUG_FIX.md
- Pin offset: packages/ui/lib/widgets/map/PIN_OFFSET_FIX.md
- Zoom tweak: packages/ui/lib/widgets/map/ZOOM_ADJUSTMENT.md
