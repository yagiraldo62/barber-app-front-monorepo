# SelectedScope Migration Summary

## Changes Applied

### 1. Created `SelectedScope` Sealed Class
**File**: `packages/core/lib/modules/auth/classes/selected_scope.dart`

This sealed class allows a single scope that can be either:
- `ProfileScope` - Contains a `ProfileModel` (artist or organization profile)
- `LocationMemberScope` - Contains a `LocationMemberModel` (member of an organization location)

**Benefits**:
- ✅ Type-safe union type (similar to TypeScript's `ProfileModel | LocationMemberModel`)
- ✅ Compile-time exhaustiveness checking with pattern matching
- ✅ Clean API with clear intent
- ✅ JSON serialization/deserialization support

### 2. Updated `AuthStorageRepository`
**File**: `packages/core/lib/modules/auth/repository/auth_storage_repository.dart`

**Changes**:
- Replaced `ArtistModel` import with `SelectedScope` import
- Updated `setSelectedScope()` to accept `SelectedScope?` instead of `ArtistModel?`
- Renamed `getSelectedArtist()` to `getSelectedScope()` returning `SelectedScope?`
- Updated `getAuthState()` to use `SelectedScope`
- Updated `setAuthState()` to use `SelectedScope`

### 3. Updated `AuthState` Class
**File**: `packages/core/lib/modules/auth/classes/auth_state.dart`

**Changes**:
- Replaced `ArtistModel` import with `SelectedScope` import
- Changed `selectedScope` field to `selectedScope`
- Updated constructor parameter from `selectedScope` to `selectedScope`
- Updated `toJson()` to serialize `selected_scope` instead of `selected_artist`

### 4. Updated `StorageManager` Constants
**File**: `packages/utils/lib/storage_manager.dart`

**Changes**:
- Renamed constant from `SELECTED_ARTIST` to `SELECTED_SCOPE`

## Usage Examples

### Creating a Scope

```dart
// For a profile (artist or organization owner)
final profile = ProfileModel(id: '123', name: 'My Studio');
final scope = ProfileScope(profile);

// For a location member
final member = LocationMemberModel(id: '456', role: LocationMemberRole.manager);
final scope = LocationMemberScope(member);
```

### Pattern Matching (Recommended)

```dart
void handleScope(SelectedScope scope) {
  switch (scope) {
    case ProfileScope(:final profile):
      print('Profile: ${profile.name}');
      
    case LocationMemberScope(:final locationMember):
      print('Member at: ${locationMember.organization?.name}');
  }
}
```

### Using if-case

```dart
if (scope case ProfileScope(:final profile)) {
  // Work with profile
} else if (scope case LocationMemberScope(:final locationMember)) {
  // Work with location member
}
```

### Storing and Retrieving

```dart
// Store
final authRepo = AuthStorageRepository();
await authRepo.setSelectedScope(ProfileScope(myProfile));

// Retrieve
final scope = await authRepo.getSelectedScope();

// Use pattern matching
if (scope case ProfileScope(:final profile)) {
  print('Current profile: ${profile.name}');
}
```

## Migration Notes

### For Existing Code Using `ArtistModel`

Replace:
```dart
ArtistModel? artist = await authRepo.getSelectedArtist();
if (artist != null) {
  print(artist.name);
}
```

With:
```dart
SelectedScope? scope = await authRepo.getSelectedScope();
if (scope case ProfileScope(:final profile)) {
  print(profile.name);
}
```

### For Existing Code Setting Artist

Replace:
```dart
await authRepo.setSelectedScope(artistModel);
```

With:
```dart
await authRepo.setSelectedScope(ProfileScope(profileModel));
```

## Next Steps

1. Search for all usages of `selectedScope` in your codebase and update them to use `selectedScope`
2. Update any UI components that display artist information to use pattern matching
3. Update any business logic that checks artist status to handle both scope types
4. Consider the usage example file for reference (can be deleted after migration)

## Files Modified

- ✅ `packages/core/lib/modules/auth/classes/selected_scope.dart` (created)
- ✅ `packages/core/lib/modules/auth/classes/auth_state.dart` (updated)
- ✅ `packages/core/lib/modules/auth/repository/auth_storage_repository.dart` (updated)
- ✅ `packages/utils/lib/storage_manager.dart` (updated)
- ℹ️ `packages/core/lib/modules/auth/classes/selected_scope_usage_example.dart` (example - can be deleted)
