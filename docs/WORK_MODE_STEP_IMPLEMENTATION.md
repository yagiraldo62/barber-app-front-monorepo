# Work Mode Step Implementation Summary

## Overview
Added a new step to the ProfileForm to allow artists to select whether they want to work as an independent artist or be associated with an organization.

## Changes Made

### 1. New Step Widget
**File**: `apps/bartoo-business/lib/app/modules/profiles/widgets/forms/steps/work_mode_step.dart`

Created a new step widget with:
- Two selectable cards: "Artista Independiente" and "Asociado a Organización"
- Visual feedback with icons, colors, and checkmarks
- Clear descriptions for each work mode option
- Responsive design following Material Design principles

### 2. Updated ProfileFormStep Enum
**File**: `apps/bartoo-business/lib/app/modules/profiles/controllers/forms/profile_form_controller.dart`

```dart
enum ProfileFormStep { workMode, name, title, description, categories, photo }
```

Added `workMode` as the first step in the profile creation flow.

### 3. Controller Updates
**File**: `apps/bartoo-business/lib/app/modules/profiles/controllers/forms/profile_form_controller.dart`

#### New Properties:
```dart
final isIndependentArtist = Rx<bool?>(null);
```

#### New Methods:
```dart
void setWorkMode(bool independent) {
  isIndependentArtist.value = independent;
}
```

#### Updated nextStep() Method:
Added case for `ProfileFormStep.workMode` with validation to ensure a work mode is selected before proceeding.

#### Updated upsertProfile() Method:
Now passes `independentArtist` value when creating or updating profiles.

### 4. Form Widget Updates
**File**: `apps/bartoo-business/lib/app/modules/profiles/widgets/forms/profile_form.dart`

- Imported the new `WorkModeStep` widget
- Added the work mode step as the first step in the steps array
- Configured proper conditions for step visibility

### 5. Provider Updates
**File**: `packages/core/lib/modules/profile/providers/profile_provider.dart`

#### Updated createProfile():
```dart
Future<ProfileModel?> createProfile({
  // ... existing parameters
  bool? independentArtist,
})
```
- Added optional `independentArtist` parameter
- Conditionally includes `independent_artist` in the request body

#### Updated updateProfile():
```dart
Future<ProfileModel?> updateProfile(
  // ... existing parameters
  {
    bool? independentArtist,
  }
)
```
- Added optional named parameter for `independentArtist`
- Conditionally includes `independent_artist` in the request body

### 6. Repository Updates
**File**: `packages/core/lib/modules/profile/repository/profile_repository.dart`

#### Updated create():
```dart
Future<ProfileModel> create({
  // ... existing parameters
  bool? independentArtist,
})
```
- Passes `independentArtist` to the provider's `createProfile` method

#### Updated update():
```dart
Future<ProfileModel?> update(
  // ... existing parameters
  {
    bool? independentArtist,
  }
)
```
- Passes `independentArtist` to the provider's `updateProfile` method

## User Flow

### Creation Mode
1. **Work Mode Selection** (NEW)
   - User sees two options: Independent Artist or Associated to Organization
   - Must select one option before continuing
   - Visual feedback shows selected option

2. **Name Step**
   - Enter business name

3. **Title Step**
   - Enter professional title

4. **Description Step**
   - Enter profile description

5. **Categories Step**
   - Select service categories

6. **Photo Step**
   - Upload profile photo

### Edit Mode
- All steps shown at once, including work mode
- User can modify work mode selection
- Changes are saved when form is submitted

## API Integration

### Request Body (Create/Update)
```json
{
  "name": "Artist Name",
  "title": "Professional Title",
  "description": "Description",
  "categories_id": ["cat-id-1", "cat-id-2"],
  "type": "artist",
  "independent_artist": true  // NEW FIELD
}
```

### Response
The `independent_artist` field is stored in `profile_settings` and accessible via:
```dart
profile.independentArtist  // bool?
```

## UI/UX Features

### Work Mode Cards
- **Independent Artist Card**
  - Icon: Person icon
  - Title: "Artista Independiente"
  - Description: "Trabajo de forma independiente, gestiono mi propio negocio y agenda"

- **Associated to Organization Card**
  - Icon: Business icon
  - Title: "Asociado a Organización"
  - Description: "Trabajo asociado a una o más organizaciones que gestionan la agenda"

### Visual Feedback
- Selected card shows:
  - Primary color border (2px width)
  - Primary color background tint
  - Check circle icon
  - Primary colored text
  - Icon with primary color

- Unselected card shows:
  - Outline border (1px width)
  - Transparent background
  - No check icon
  - Default text color
  - Icon with default color

## Validation
- User must select a work mode before proceeding
- Error message shown if trying to continue without selection: "Debes seleccionar una modalidad de trabajo"

## Backward Compatibility
- `independentArtist` is an optional field (nullable)
- Existing profiles without this field will have `null` value
- API accepts `null` values (field is not required)

## Testing Considerations

### Test Cases
1. ✅ Create new profile with independent artist mode
2. ✅ Create new profile with organization-associated mode
3. ✅ Edit existing profile and change work mode
4. ✅ Validation: Cannot proceed without selecting work mode
5. ✅ Edit mode: All steps visible including work mode
6. ✅ API: `independent_artist` field sent correctly
7. ✅ API: Field is optional and handles null values

## Future Enhancements
- Could add tooltip or help text for each work mode
- Could add conditional steps based on work mode selection
- Could integrate with availability/scheduling features differently based on work mode
- Could show different onboarding flows based on selection

## Related Files Modified
1. `work_mode_step.dart` - New file
2. `profile_form_controller.dart` - Updated
3. `profile_form.dart` - Updated
4. `profile_provider.dart` - Updated
5. `profile_repository.dart` - Updated

## Notes
- Follows existing form architecture pattern
- Uses reactive state management with GetX
- Consistent with other steps in ProfileForm
- Material Design 3 compliant
- Accessible and responsive design
