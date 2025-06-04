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

  Document({
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
}
