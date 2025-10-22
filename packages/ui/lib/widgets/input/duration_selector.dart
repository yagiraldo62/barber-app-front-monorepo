import 'package:ui/widgets/input/text_field.dart';
import 'package:ui/widgets/selector/common_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DurationSelector extends StatelessWidget {
  final int initialValue;
  final Function(int) onChanged;
  final double? width;
  final double? height;
  final String labelText;
  final Color? backgroundColor;
  final Color? textColor;
  final BorderRadius? borderRadius;

  // Lista de duraciones de 15 a 240 min en intervalos de 15
  static final List<int> _durations = List.generate(
    16,
    (index) => (index + 1) * 15,
  );

  DurationSelector({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.width,
    this.height,
    this.labelText = 'Duración',
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
  }) {
    // Inicializar el valor seleccionado cuando se crea el widget
    _selectedDuration.value = _findClosestDuration(initialValue);
    _textController.text = _formatDuration(_selectedDuration.value);
  }

  // Usando RxInt para gestionar el estado reactivo
  final RxInt _selectedDuration = RxInt(15);
  // Controlador para el campo de texto
  final TextEditingController _textController = TextEditingController();

  int _findClosestDuration(int value) {
    // Si el valor es exactamente uno de los intervalos, usarlo
    if (_durations.contains(value)) {
      return value;
    }

    // Si no, encontrar el valor más cercano (redondeado hacia arriba)
    for (final duration in _durations) {
      if (duration >= value) {
        return duration;
      }
    }

    // Si es mayor que el valor máximo, usar el máximo
    return _durations.last;
  }

  // Función para formatear la duración en un formato legible
  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours == 0) {
      return '${minutes}m';
    } else if (remainingMinutes == 0) {
      return '${hours}h';
    } else {
      return '${hours}h ${remainingMinutes.toString().padLeft(2, '0')}m';
    }
  }

  // Función para mostrar el diálogo de selección
  void _showDurationPicker(BuildContext context) {
    CommonSelector.show<int>(
      context: context,
      title: 'Seleccionar duración',
      icon: Icons.schedule,
      items: _durations,
      selectedItem: _selectedDuration.value,
      itemBuilder: (context, duration, isSelected) {
        final theme = Theme.of(context);
        return ListTile(
          minTileHeight: 50,
          leading: Icon(
            Icons.timer_outlined,
            color: isSelected ? theme.colorScheme.primary : null,
          ),
          title: Text(
            _formatDuration(duration),
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? theme.colorScheme.primary : null,
            ),
          ),
          trailing:
              isSelected
                  ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
                  : null,
          tileColor:
              isSelected
                  ? theme.colorScheme.primaryContainer.withOpacity(0.2)
                  : null,
        );
      },
      onItemSelected: (duration) {
        _selectedDuration.value = duration;
        _textController.text = _formatDuration(duration);
        onChanged(duration);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      // Actualizar el texto si cambia la duración seleccionada
      if (_textController.text != _formatDuration(_selectedDuration.value)) {
        _textController.text = _formatDuration(_selectedDuration.value);
      }

      return CommonTextField(
        controller: _textController,
        labelText: labelText,
        readOnly: true,
        onTap: () => _showDurationPicker(context),
        prefixIcon: Icon(Icons.schedule, color: theme.colorScheme.onSurface),
        suffixIcon: Icon(
          Icons.arrow_drop_down,
          color: theme.colorScheme.onSurface,
        ),
      );
    });
  }
}
