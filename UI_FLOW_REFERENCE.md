# Notes App UI Flow - Visual Reference

## Header Layout (main_shell.dart)

```
┌─────────────────────────────────────────────────────────────────┐
│ [Menu] All Notes                    [🔍] [Filter] [Sort] [More] │
│                                                                   │
│ [Search Field (expanded)]                                        │
└─────────────────────────────────────────────────────────────────┘
```

## Filter Popover Flow

```
User clicks Filter icon
         ↓
Dialog opens with FilterContent
         ↓
    ┌─────────────────────┐
    │ Filter              │
    ├─────────────────────┤
    │ ○ is                │
    │ ○ is not            │
    │ ○ contains          │
    │ ○ has any value     │
    │                     │
    │ [Text field]        │
    │                     │
    │ [Apply] [Cancel]    │
    └─────────────────────┘
         ↓ Click Apply
      NotesCubit.applyFilter(operator, value)
         ↓
      _rebuildVisible()
         ↓
      emit NotesLoaded(visibleNotes)
```

## Sort Popover Flow

```
User clicks Sort icon
         ↓
Dialog opens with SortContent
         ↓
    ┌──────────────────────────┐
    │ Sort                     │
    ├──────────────────────────┤
    │ ○ Recently Updated       │
    │ ○ Oldest First           │
    │ ○ Title (A-Z)            │
    │ ○ Title (Z-A)            │
    │ ○ Pinned First           │
    │                          │
    │ [Apply Sort] [Cancel]    │
    └──────────────────────────┘
         ↓ Click Apply Sort
      NotesCubit.sortNotes(sortBy)
         ↓
      _rebuildVisible()
         ↓
      emit NotesLoaded(visibleNotes)
```

## Search Flow with Debounce

```
User types in search field
         ↓
Timer starts (300ms debounce)
         ↓
User keeps typing
         ↓
Timer resets
         ↓
No more typing for 300ms
         ↓
Timer fires: NotesCubit.searchNotes(query)
         ↓
_rebuildVisible() applies query
         ↓
emit NotesLoaded(visibleNotes)
```

## Data Pipeline (_rebuildVisible)

```
_allNotes (never modified)
     ↓
Apply search query
[title.contains(query) OR content.contains(query) OR category.contains(query)]
     ↓
Apply filter
[filterOperator matches category values]
     ↓
Apply sort
[by recently updated / oldest first / title A-Z / title Z-A / pinned first]
     ↓
visible = [filtered, sorted notes]
     ↓
emit NotesLoaded(visible, allNotes, query, filterOperator, filterValue, sortBy)
```

## State Management

```
NotesState
├── NotesInitial
├── NotesLoading
├── NotesLoaded
│   ├── notes: List<Note> (visible after filtering/sorting)
│   ├── allNotes: List<Note> (never modified)
│   ├── query: String? (current search)
│   ├── filterOperator: String? (is, is not, contains, has any value)
│   ├── filterValue: String? (filter value)
│   └── sortBy: NoteSortBy (sort criteria)
├── NotesError
└── NotesOperationInProgress
```

## NotesCubit Public API

```
loadNotes()                           → Load all notes
searchNotes(String query)             → Apply search query (300ms debounce)
applyFilter(String op, String val)    → Apply filter (instant)
clearFilter()                         → Clear active filter
sortNotes(NoteSortBy sortBy)          → Sort notes (instant)
resetFilters()                        → Reset all filters
createNote(...)                       → Create new note
updateNote(...)                       → Update existing note
deleteNote(String id)                 → Delete note
togglePinNote(String id)              → Toggle pin state
```

## Component Hierarchy

```
main_shell.dart
├── _NotesHeaderActions (stateful)
│   ├── Search TextField
│   ├── Search Icon (toggle)
│   ├── _FilterMenuAnchor (stateful)
│   │   └── FilterContent (uses PopoverPanel)
│   └── _SortMenuAnchor (stateful)
│       └── SortContent (uses PopoverPanel)
└── NotesListPage
    └── _NotesView
        └── BlocBuilder<NotesCubit>
            └── _buildNotesGrid
                └── GridView(NotesListItem)
```

## Key Features

✅ **Single Source of Truth**
  - _allNotes never modified
  - All operations filter/sort from _allNotes
  - Clean state management

✅ **Compact Popovers**
  - 280px width
  - Apply/Cancel buttons
  - Consistent styling

✅ **Keyboard Support**
  - Enter to apply filter
  - Escape to close popover

✅ **Search Debounce**
  - 300ms delay
  - Prevents excessive rebuilds

✅ **UX Polish**
  - Prefilled last values
  - Temporary selection in sort
  - Clear all filters
  - Pinned badge preserved
  - Note colors preserved

✅ **Production Ready**
  - No errors
  - Clean architecture
  - Proper disposal
  - String constants
