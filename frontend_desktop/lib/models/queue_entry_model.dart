enum QueueEntryStatus {
  /// بالانتظار — يظهر على شاشة العرض
  waiting,

  /// استدعاء البنچ / التخدير — برتقالي في الإدارة، يبقى على شاشة العرض
  anesthesia,

  /// استدعاء العملية — أخضر في الإدارة، يختفي من شاشة العرض
  surgery,

  /// تأجيل (لم يحضر) — أحمر في الإدارة، يختفي من شاشة العرض
  postponed,
}

extension QueueEntryStatusX on QueueEntryStatus {
  String get value {
    switch (this) {
      case QueueEntryStatus.waiting:
        return 'waiting';
      case QueueEntryStatus.anesthesia:
        return 'anesthesia';
      case QueueEntryStatus.surgery:
        return 'surgery';
      case QueueEntryStatus.postponed:
        return 'postponed';
    }
  }

  /// يظهر على شاشة العرض العامة
  bool get isVisibleOnDisplay {
    switch (this) {
      case QueueEntryStatus.waiting:
      case QueueEntryStatus.anesthesia:
        return true;
      case QueueEntryStatus.surgery:
      case QueueEntryStatus.postponed:
        return false;
    }
  }

  String get labelAr {
    switch (this) {
      case QueueEntryStatus.waiting:
        return 'انتظار';
      case QueueEntryStatus.anesthesia:
        return 'بنج';
      case QueueEntryStatus.surgery:
        return 'عملية';
      case QueueEntryStatus.postponed:
        return 'تأجيل';
    }
  }

  static QueueEntryStatus fromValue(String? raw) {
    switch (raw) {
      case 'anesthesia':
      case 'called': // توافق النسخ القديمة
        return QueueEntryStatus.anesthesia;
      case 'surgery':
      case 'done': // توافق النسخ القديمة
        return QueueEntryStatus.surgery;
      case 'postponed':
        return QueueEntryStatus.postponed;
      case 'waiting':
      default:
        return QueueEntryStatus.waiting;
    }
  }
}

class QueueEntry {
  final String id;
  final int number;
  final String name;
  final QueueEntryStatus status;
  /// رقم هاتف الزبون (محلي مثل 07xxxxxxxxx) للتواصل عبر واتساب
  final String phone;

  const QueueEntry({
    required this.id,
    required this.number,
    required this.name,
    this.status = QueueEntryStatus.waiting,
    this.phone = '',
  });

  bool get hasPhone => digitsOnly.isNotEmpty;

  String get digitsOnly => phone.replaceAll(RegExp(r'[^\d]'), '');

  /// رقم واتساب بصيغة دولية بدون + (العراق 964)
  String get whatsAppNumber {
    var digits = digitsOnly;
    if (digits.isEmpty) return '';
    if (digits.startsWith('00')) digits = digits.substring(2);
    if (digits.startsWith('0')) digits = '964${digits.substring(1)}';
    if (digits.startsWith('7') && digits.length == 10) {
      digits = '964$digits';
    }
    return digits;
  }

  QueueEntry copyWith({
    int? number,
    String? name,
    QueueEntryStatus? status,
    String? phone,
  }) {
    return QueueEntry(
      id: id,
      number: number ?? this.number,
      name: name ?? this.name,
      status: status ?? this.status,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'number': number,
        'name': name,
        'status': status.value,
        'phone': phone,
      };

  factory QueueEntry.fromJson(Map<String, dynamic> json) {
    return QueueEntry(
      id: json['id']?.toString() ?? '',
      number: json['number'] is int
          ? json['number'] as int
          : int.tryParse('${json['number']}') ?? 0,
      name: json['name']?.toString() ?? '',
      status: QueueEntryStatusX.fromValue(json['status']?.toString()),
      phone: (json['phone'] ?? json['phoneNumber'] ?? '').toString(),
    );
  }
}
