class Document {
  final int? id;
  final String title;
  final int categoryId;
  final String locationRoom;
  final String locationArea;
  final String locationBox;
  final String? note;
  final String? nfcId;
  final String? imagePath;
  final String? referenceNumber;
  final bool isPrivate;
  final String? date; // Fecha de caducidad (opcional)
  final int? reminderDays;
  final String createdAt;
  final String updatedAt;

  const Document({
    this.id,
    required this.title,
    required this.categoryId,
    required this.locationRoom,
    required this.locationArea,
    required this.locationBox,
    this.note,
    this.nfcId,
    this.imagePath,
    this.referenceNumber,
    this.isPrivate = false,
    this.date,
    this.reminderDays,
    required this.createdAt,
    required this.updatedAt,
  });

  Document copyWith({
    int? id,
    String? title,
    int? categoryId,
    String? locationRoom,
    String? locationArea,
    String? locationBox,
    String? note,
    String? nfcId,
    String? imagePath,
    String? referenceNumber,
    bool? isPrivate,
    String? date,
    int? reminderDays,
    String? createdAt,
    String? updatedAt,
  }) {
    return Document(
      id: id ?? this.id,
      title: title ?? this.title,
      categoryId: categoryId ?? this.categoryId,
      locationRoom: locationRoom ?? this.locationRoom,
      locationArea: locationArea ?? this.locationArea,
      locationBox: locationBox ?? this.locationBox,
      note: note ?? this.note,
      nfcId: nfcId ?? this.nfcId,
      imagePath: imagePath ?? this.imagePath,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      isPrivate: isPrivate ?? this.isPrivate,
      date: date ?? this.date,
      reminderDays: reminderDays ?? this.reminderDays,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Document &&
        other.id == id &&
        other.title == title &&
        other.categoryId == categoryId &&
        other.locationRoom == locationRoom &&
        other.locationArea == locationArea &&
        other.locationBox == locationBox &&
        other.note == note &&
        other.nfcId == nfcId &&
        other.imagePath == imagePath &&
        other.referenceNumber == referenceNumber &&
        other.isPrivate == isPrivate &&
        other.date == date &&
        other.reminderDays == reminderDays &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        title,
        categoryId,
        locationRoom,
        locationArea,
        locationBox,
        note,
        nfcId,
        imagePath,
        referenceNumber,
        isPrivate,
        date,
        reminderDays,
        createdAt,
        updatedAt,
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'categoryId': categoryId,
      'locationRoom': locationRoom,
      'locationArea': locationArea,
      'locationBox': locationBox,
      'note': note,
      'nfcId': nfcId,
      'imagePath': imagePath,
      'referenceNumber': referenceNumber,
      'isPrivate': isPrivate ? 1 : 0,
      'date': date,
      'reminderDays': reminderDays,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      id: map['id'],
      title: map['title'],
      categoryId: map['categoryId'],
      locationRoom: map['locationRoom'],
      locationArea: map['locationArea'],
      locationBox: map['locationBox'],
      note: map['note'],
      nfcId: map['nfcId'],
      imagePath: map['imagePath'],
      referenceNumber: map['referenceNumber'],
      isPrivate: map['isPrivate'] == 1,
      date: map['date'],
      reminderDays: map['reminderDays'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  @override
  String toString() => 'Document(id: \$id, title: \$title)';
}
