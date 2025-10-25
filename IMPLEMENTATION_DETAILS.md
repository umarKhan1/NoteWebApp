# Implementation Details - Notes App Refactoring

## Overview
This document provides implementation details for the refactored Notes app UI, focusing on the filter/sort popover system and state management.

## 1. Core Architecture

### NotesCubit - Single Source of Truth Pattern

The NotesCubit maintains multiple lists and properties:

```dart
// Private state
List<Note> _allNotes = [];      // Original, never modified
String _query = '';              // Current search query
String? _filterOperator;         // Current filter operator
String? _filterValue;            // Current filter value
NoteSortBy _sortBy = NoteSortBy.recentlyUpdated;
```

### Data Pipeline (_rebuildVisible)

The `_rebuildVisible()` method is the core of the filtering/sorting system:

1. **Start with all notes**: `var visible = List<Note>.from(_allNotes);`
2. **Apply search query**: Filter by title, content, or category
3. **Apply filter operator**: Match filter criteria (is, is not, contains, has any value)
4. **Apply sort**: Sort by selected criteria
5. **Emit state**: `emit(NotesLoaded(notes: visible, ...))`

Key principle: **Never modify `_allNotes`**

## 2. Filter System

### Filter Operators

- `is` - Exact match with category
- `is not` - Does not match category
- `contains` - Title or content contains value
- `has any value` - Category exists (any value)

### Filter Implementation

```dart
void applyFilter(String operator, String value) {
  _filterOperator = operator;
  _filterValue = value;
  _rebuildVisible();
}

void clearFilter() {
  _filterOperator = null;
  _filterValue = null;
  _rebuildVisible();
}
```

### FilterContent Widget

Located in `filter_content.dart`, this widget:
- Shows radio group for operator selection
- Conditionally shows TextField based on operator
- Supports keyboard input (Enter to apply)
- Calls `onApply(operator, value)` when Apply clicked
- Calls `onCancel()` when Cancel clicked
- Prefills with `initialOperator` and `initialValue`

## 3. Sort System

### Sort Options

- `recentlyUpdated` - Most recent first (default)
- `oldestFirst` - Oldest notes first
- `titleAtoZ` - Alphabetical A-Z
- `titleZtoA` - Reverse alphabetical Z-A
- `pinnedFirst` - Pinned notes first, then by recent

### Sort Implementation

```dart
void sortNotes(NoteSortBy sortBy) {
  _sortBy = sortBy;
  _rebuildVisible();
}
```

### SortContent Widget

Located in `sort_content.dart`, this widget:
- Shows radio list for sort options
- Temporary selection (doesn't apply until Apply clicked)
- Calls `onApply(sortBy)` when Apply clicked
- Calls `onCancel()` when Cancel clicked
- Prefills with `initialSort`

## 4. Popover System

### PopoverPanel Widget

Base component for both filter and sort popovers:

```dart
PopoverPanel(
  title: 'Filter Notes',
  primaryButtonLabel: 'Apply Filter',
  onApply: () { /* apply logic */ },
  onCancel: () { /* cancel logic */ },
  content: /* filter/sort content widget */,
)
```

Features:
- Fixed 280px width
- Title at top
- Custom content in middle
- Apply/Cancel buttons at bottom
- Box shadow for depth
- Rounded corners (12px)

### Dialog Integration

Popovers are shown as Dialog with transparent background:

```dart
showDialog(
  context: context,
  builder: (context) => Dialog(
    backgroundColor: Colors.transparent,
    child: PopoverPanel(
      title: 'Filter Notes',
      content: FilterContent(...),
      onApply: () { Navigator.pop(context); },
      onCancel: () { Navigator.pop(context); },
    ),
  ),
)
```

## 5. Search with Debounce

### Implementation in main_shell.dart

```dart
Timer? _searchDebounce;

void _onSearchChanged(String query) {
  _searchDebounce?.cancel();
  _searchDebounce = Timer(const Duration(milliseconds: 300), () {
    context.read<NotesCubit>().searchNotes(query);
  });
}
```

Features:
- 300ms debounce delay
- Cancels previous timer if user continues typing
- Prevents excessive rebuilds
- Improves performance with large note lists

### Search Flow

1. User types in search field
2. `onChanged` callback fires
3. Timer starts/resets
4. After 300ms of no typing: `searchNotes(query)` called
5. `_rebuildVisible()` filters by query
6. `NotesLoaded` emitted with filtered notes

## 6. State Management (NotesLoaded)

```dart
class NotesLoaded extends NotesState {
  final List<Note> notes;           // Visible notes after filtering/sorting
  final List<Note> allNotes;        // All original notes
  final String? query;              // Current search query
  final String? filterOperator;     // Current filter operator
  final String? filterValue;        // Current filter value
  final NoteSortBy sortBy;          // Current sort option
}
```

This state provides:
- UI with everything needed to display filtered/sorted notes
- Information about current filters for UI indicators
- Original notes list for reset operations

## 7. User Experience Flows

### Apply Filter Flow

```
1. User clicks filter icon
2. FilterContent popover opens
3. User selects operator (radio button)
4. User enters value in TextField (if needed)
5. User clicks "Apply Filter"
6. NotesCubit.applyFilter(operator, value) called
7. _rebuildVisible() applies filter
8. NotesLoaded(visible notes, ...) emitted
9. UI updates with filtered notes
10. Dialog closes
```

### Cancel Filter Flow

```
1. User has filter active
2. User clicks filter icon
3. FilterContent popover opens (prefilled with current filter)
4. User clicks "Cancel"
5. Dialog closes (state unchanged)
6. Visible notes remain same
```

### Clear Filter Flow

```
1. User clicks filter icon
2. FilterContent popover opens
3. User clicks cancel, or clicks X
4. NotesCubit.clearFilter() called
5. _rebuildVisible() with no filter
6. All notes displayed again
7. Dialog closes
```

## 8. Keyboard Support

### Filter Content

- `TextField.onSubmitted`: Enter key triggers `_applyFilter()`
- `autofocus: true`: TextField gets focus when popover opens
- Radio buttons: Tab navigation works

### Main Search

- Auto-focus on search field expansion
- Clear button available for quick reset
- Enter key: depends on app context

## 9. Edge Cases Handled

### Empty Filter Value
- "has any value" operator doesn't require value
- Other operators require non-empty value

### No Categories
- Filter UI shows "No categories found" if none exist
- Search/sort still work

### Empty Notes List
- Shows "No notes" state
- Filter/sort/search UI still available

### Concurrent Operations
- Debounce prevents timer conflicts
- Each operation rebuilds from _allNotes

## 10. Performance Considerations

### Search Debounce
- 300ms delay prevents excessive rebuilds
- Important for real-time search with large lists

### Immutable Lists
- Never modify _allNotes directly
- Create new lists for filtering
- Allows Flutter to detect changes

### Efficient Sorting
- Sorts visible list only (already filtered)
- Different sort implementations optimized per type

## 11. Testing Checklist

- [ ] Load notes displays all notes
- [ ] Search filters by title/content/category
- [ ] Filter with "is" operator works
- [ ] Filter with "is not" operator works
- [ ] Filter with "contains" operator works
- [ ] Filter with "has any value" operator works
- [ ] Sort by Recently Updated works
- [ ] Sort by Oldest First works
- [ ] Sort by Title A-Z works
- [ ] Sort by Title Z-A works
- [ ] Sort by Pinned First works (pinned first, then by recent)
- [ ] Filter + Sort combination works
- [ ] Search + Filter combination works
- [ ] Clear filter shows all notes again
- [ ] Pinned badge preserved during operations
- [ ] Note colors preserved during operations
- [ ] Keyboard support (Enter to apply)
- [ ] Cancel doesn't change state
- [ ] Popover closes after Apply
- [ ] Popover closes after Cancel
- [ ] Prefilled values in popover
- [ ] Search debounce works (no excessive API calls)

## 12. Common Issues & Solutions

### Issue: Filter not applying
- Check `_rebuildVisible()` is called
- Verify operator and value are set correctly
- Check filter logic in switch statement

### Issue: Sort not working
- Verify `NoteSortBy` enum value is passed correctly
- Check sort logic matches sort option
- Ensure list is not empty

### Issue: Search too slow
- Check debounce is implemented (300ms)
- Reduce debounce time if needed
- Consider pagination for very large lists

### Issue: Popover not showing
- Verify Dialog is built correctly
- Check BuildContext is valid
- Ensure theme is passed to FilterContent/SortContent

## 13. Future Enhancements

Possible improvements:
- Save filter preferences per user
- Add advanced filter builder
- Multi-select sort criteria
- Filter history dropdown
- Sort/filter presets
- Export filtered results
- Share filtered view
- Scheduled filters
