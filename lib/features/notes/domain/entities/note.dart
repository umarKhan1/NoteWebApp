/// Note entity representing a user's note
class Note {
  /// Unique identifier for the note
  final String id;
  
  /// Title of the note
  final String title;
  
  /// Content/body of the note
  final String content;
  
  /// Date when the note was created
  final DateTime createdAt;
  
  /// Date when the note was last updated
  final DateTime updatedAt;
  
  /// Category or tag for the note
  final String? category;
  
  /// Whether the note is pinned
  final bool isPinned;
  
  /// Color identifier for the note (optional)
  final String? color;
  
  /// Base64 encoded image data for the note (optional, single image only)
  final String? imageBase64;
  
  /// Original image filename (optional)
  final String? imageName;

  /// Creates an instance of [Note]
  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.category,
    this.isPinned = false,
    this.color,
    this.imageBase64,
    this.imageName,
  });

  /// Creates a copy of this note with the given fields replaced with new values
  Note copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? category,
    bool? isPinned,
    String? color,
    String? imageBase64,
    String? imageName,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
      isPinned: isPinned ?? this.isPinned,
      color: color ?? this.color,
      imageBase64: imageBase64 ?? this.imageBase64,
      imageName: imageName ?? this.imageName,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Note &&
        other.id == id &&
        other.title == title &&
        other.content == content &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.category == category &&
        other.isPinned == isPinned &&
        other.color == color &&
        other.imageBase64 == imageBase64 &&
        other.imageName == imageName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        content.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        category.hashCode ^
        isPinned.hashCode ^
        color.hashCode ^
        imageBase64.hashCode ^
        imageName.hashCode;
  }

  @override
  String toString() {
    return 'Note(id: $id, title: $title, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, category: $category, isPinned: $isPinned, color: $color, imageBase64: ${imageBase64 != null ? 'present' : 'null'}, imageName: $imageName)';
  }

  /// Converts the Note to a JSON map for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'category': category,
      'isPinned': isPinned,
      'color': color,
      'imageBase64': imageBase64,
      'imageName': imageName,
    };
  }

  /// Creates a Note instance from a JSON map
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      category: json['category'] as String?,
      isPinned: json['isPinned'] as bool? ?? false,
      color: json['color'] as String?,
      imageBase64: json['imageBase64'] as String?,
      imageName: json['imageName'] as String?,
    );
  }
}
