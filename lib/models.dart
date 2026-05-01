enum ClaimStatus { submitted, processing, approved, rejected }

class User {
  User({required this.name, required this.email, required this.password});

  final String name;
  final String email;
  final String password;
}

class MedicalInfo {
  MedicalInfo({
    required this.memberId,
    required this.planName,
    required this.dateOfBirth,
    required this.bloodType,
    required this.allergies,
    required this.conditions,
    required this.phone,
    required this.email,
  });

  final String memberId;
  final String planName;
  final String dateOfBirth;
  final String bloodType;
  final String allergies;
  final String conditions;
  final String phone;
  final String email;
}

class Claim {
  Claim({
    required this.id,
    required this.date,
    required this.description,
    required this.amount,
    required this.status,
    required this.documentName,
    required this.documentUrl,
  });

  final String id;
  final String date;
  final String description;
  final double amount;
  ClaimStatus status;
  final String documentName;
  final String documentUrl;
}

class AppNotification {
  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.date,
    this.read = false,
  });

  final String id;
  final String title;
  final String message;
  final String date;
  bool read;
}
