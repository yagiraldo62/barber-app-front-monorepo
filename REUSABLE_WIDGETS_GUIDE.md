# Reusable Widgets - Usage Guide

## PhoneNumberInput Widget

### Basic Usage

```dart
import 'package:ui/widgets/input/phone_number_input.dart';

PhoneNumberInput(
  labelText: 'Número de teléfono',
  initialPhone: '+15551234567', // Optional
  onChanged: (phoneE164) {
    print('Phone number: $phoneE164'); // Returns E164 format
    // Example output: "+15551234567"
  },
  onValidated: (isValid) {
    print('Is valid: $isValid');
  },
)
```

### Features
- ✅ International phone number formatting
- ✅ Country code selector with flags
- ✅ Auto-validation
- ✅ E164 format output
- ✅ Consistent theming

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `labelText` | `String` | `'Número de teléfono'` | Label above input |
| `initialPhone` | `String?` | `null` | Initial phone number |
| `onChanged` | `Function(String)?` | `null` | Callback when phone changes (E164) |
| `onValidated` | `Function(bool)?` | `null` | Callback with validation status |
| `focusNode` | `FocusNode?` | `null` | Custom focus node |

---

## OtpCodeInput Widget

### Basic Usage

```dart
import 'package:ui/widgets/input/otp_code_input.dart';

OtpCodeInput(
  length: 6, // Number of digits
  onChanged: (value) {
    print('Current OTP: $value');
    // Example output: "123" (partial)
  },
  onCompleted: (value) {
    print('Completed OTP: $value');
    // Example output: "123456" (complete)
    // Auto-submit logic here
  },
)
```

### Features
- ✅ Individual digit boxes
- ✅ Auto-focus on next field
- ✅ Auto-focus on previous field (backspace)
- ✅ Theme-aware styling
- ✅ Auto-submit on completion
- ✅ Numeric keyboard
- ✅ Digit-only input

### Props

| Prop | Type | Default | Description |
|------|------|---------|-------------|
| `length` | `int` | `6` | Number of OTP digits |
| `onChanged` | `Function(String)?` | `null` | Called on each digit change |
| `onCompleted` | `Function(String)?` | `null` | Called when all digits entered |

### Styling
The widget automatically uses your theme colors:
- `primaryContainer` - Box background
- `primary` - Focused/active border
- `secondary` - Default border (with opacity)
- `error` - Error border

---

## Complete Example: Phone Verification

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui/widgets/input/phone_number_input.dart';
import 'package:ui/widgets/input/otp_code_input.dart';
import 'package:ui/widgets/button/app_button.dart';

class MyPhoneVerification extends StatefulWidget {
  @override
  State<MyPhoneVerification> createState() => _MyPhoneVerificationState();
}

class _MyPhoneVerificationState extends State<MyPhoneVerification> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  bool codeSent = false;
  bool isLoading = false;

  Future<void> sendCode() async {
    setState(() => isLoading = true);
    
    // Your API call here
    await Future.delayed(Duration(seconds: 2));
    
    setState(() {
      codeSent = true;
      isLoading = false;
    });
  }

  Future<void> verifyCode() async {
    setState(() => isLoading = true);
    
    // Your API call here
    await Future.delayed(Duration(seconds: 2));
    
    setState(() => isLoading = false);
    
    // Navigate on success
    Get.offAllNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Phone Verification')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Phone Input Section
            AnimatedCrossFade(
              firstChild: Column(
                children: [
                  PhoneNumberInput(
                    onChanged: (phoneE164) {
                      phoneController.text = phoneE164;
                    },
                  ),
                  SizedBox(height: 20),
                  AppButton(
                    label: 'Send Code',
                    isLoading: isLoading,
                    onPressed: sendCode,
                    width: double.infinity,
                  ),
                ],
              ),
              secondChild: SizedBox.shrink(),
              crossFadeState: codeSent 
                ? CrossFadeState.showSecond 
                : CrossFadeState.showFirst,
              duration: Duration(milliseconds: 300),
            ),

            // OTP Input Section
            AnimatedCrossFade(
              firstChild: Column(
                children: [
                  Text('Enter verification code'),
                  SizedBox(height: 20),
                  OtpCodeInput(
                    length: 6,
                    onChanged: (value) {
                      otpController.text = value;
                    },
                    onCompleted: (value) {
                      otpController.text = value;
                      verifyCode(); // Auto-submit
                    },
                  ),
                  SizedBox(height: 20),
                  AppButton(
                    label: 'Verify',
                    isLoading: isLoading,
                    onPressed: verifyCode,
                    width: double.infinity,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        codeSent = false;
                        otpController.clear();
                      });
                    },
                    child: Text('Change phone number'),
                  ),
                ],
              ),
              secondChild: SizedBox.shrink(),
              crossFadeState: codeSent 
                ? CrossFadeState.showFirst 
                : CrossFadeState.showSecond,
              duration: Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }
}
```

---

## Customization Examples

### Custom Styled Success Message

```dart
Container(
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: theme.colorScheme.primaryContainer,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: theme.colorScheme.primary.withOpacity(0.3),
    ),
  ),
  child: Row(
    children: [
      Icon(
        Icons.check_circle_outline,
        color: theme.colorScheme.primary,
        size: 24,
      ),
      SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¡Código enviado!',
              style: theme.textTheme.titleMedium,
            ),
            SizedBox(height: 4),
            Text(
              'Revisa tu teléfono ${phoneNumber}',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    ],
  ),
)
```

### Custom Error Message

```dart
Container(
  padding: EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: theme.colorScheme.error.withOpacity(0.1),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(
      color: theme.colorScheme.error.withOpacity(0.3),
    ),
  ),
  child: Row(
    children: [
      Icon(
        Icons.error_outline,
        color: theme.colorScheme.error,
        size: 20,
      ),
      SizedBox(width: 8),
      Expanded(
        child: Text(
          errorMessage,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.error,
          ),
        ),
      ),
    ],
  ),
)
```

---

## Best Practices

### 1. Always Handle Loading States
```dart
AppButton(
  label: 'Send Code',
  isLoading: isLoading, // ← Important!
  onPressed: isLoading ? null : sendCode,
)
```

### 2. Use E164 Format for API Calls
```dart
PhoneNumberInput(
  onChanged: (phoneE164) {
    // phoneE164 is already in E164 format: "+15551234567"
    // Perfect for API calls
    apiService.sendVerificationCode(phoneE164);
  },
)
```

### 3. Auto-Submit on OTP Completion
```dart
OtpCodeInput(
  onCompleted: (value) {
    // Automatically verify when all digits are entered
    verifyCode(value);
  },
)
```

### 4. Provide Resend Option
```dart
TextButton(
  onPressed: isLoading ? null : resendCode,
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(Icons.refresh, size: 18),
      SizedBox(width: 8),
      Text('Resend code'),
    ],
  ),
)
```

### 5. Allow Phone Number Changes
```dart
TextButton(
  onPressed: () {
    setState(() {
      codeSent = false;
      otpController.clear();
      errorMessage = '';
    });
  },
  child: Text('Change phone number'),
)
```

---

## Accessibility

Both widgets support:
- ✅ Keyboard navigation
- ✅ Focus management
- ✅ Large tap targets (48x48 minimum)
- ✅ Clear labels
- ✅ Error states
- ✅ Theme colors for contrast

---

## Troubleshooting

### Phone Number Not Formatting
**Issue:** Phone number appears as plain text
**Solution:** Make sure you're using the `onChanged` callback and storing the E164 value

### OTP Auto-Submit Not Working
**Issue:** OTP doesn't submit when complete
**Solution:** Use `onCompleted` callback, not just `onChanged`

### Theme Colors Not Applied
**Issue:** Widgets don't match app theme
**Solution:** Make sure your app has a proper `ThemeData` with `colorScheme` defined

### Focus Issues
**Issue:** Focus doesn't move between OTP fields
**Solution:** This is handled automatically by the widget. Make sure you're not interfering with focus management.

---

## Migration from Old Code

### Before (Plain TextField)
```dart
TextField(
  controller: phoneController,
  keyboardType: TextInputType.phone,
  decoration: InputDecoration(
    labelText: 'Phone Number',
  ),
)
```

### After (PhoneNumberInput)
```dart
PhoneNumberInput(
  labelText: 'Phone Number',
  onChanged: (phoneE164) {
    phoneController.text = phoneE164;
  },
)
```

### Before (Plain TextField for OTP)
```dart
TextField(
  controller: otpController,
  keyboardType: TextInputType.number,
  maxLength: 6,
  decoration: InputDecoration(
    labelText: 'Verification Code',
  ),
)
```

### After (OtpCodeInput)
```dart
OtpCodeInput(
  length: 6,
  onChanged: (value) {
    otpController.text = value;
  },
  onCompleted: (value) {
    // Auto-submit
    verifyCode(value);
  },
)
```
