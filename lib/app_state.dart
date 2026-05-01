import 'models.dart';

class AppState {
  User? currentUser;

  final List<User> registeredUsers = [];

  final MedicalInfo medicalInfo = MedicalInfo(
    memberId: 'MHB-0945-0291',
    planName: 'SmartHealth Classic',
    dateOfBirth: '1990-04-11',
    bloodType: 'O+',
    allergies: 'None',
    conditions: 'Asthma',
    phone: '+27 82 123 4567',
    email: 'user@smarthealth.com',
  );

  final List<Claim> claims = [
    Claim(
      id: 'CL-1021',
      date: '2026-04-05',
      description: 'Pharmacy visit',
      amount: 325.00,
      status: ClaimStatus.approved,
      documentName: 'prescription.pdf',
      documentUrl: 'https://storage.smarthealth.app/documents/prescription.pdf',
    ),
    Claim(
      id: 'CL-1087',
      date: '2026-04-20',
      description: 'Specialist consultation',
      amount: 685.50,
      status: ClaimStatus.processing,
      documentName: 'invoice.jpg',
      documentUrl: 'https://storage.smarthealth.app/documents/invoice.jpg',
    ),
  ];

  final List<AppNotification> notifications = [
    AppNotification(
      id: 'NT-001',
      title: 'Claim approved',
      message: 'Your pharmacy claim CL-1021 has been approved.',
      date: '2026-04-06',
      read: true,
    ),
    AppNotification(
      id: 'NT-002',
      title: 'Claim received',
      message: 'We have received your claim CL-1087 and are reviewing it.',
      date: '2026-04-20',
    ),
  ];

  bool register({required String name, required String email, required String password}) {
    final existing = registeredUsers.where((user) => user.email == email).isNotEmpty;
    if (existing) {
      return false;
    }

    final newUser = User(name: name, email: email, password: password);
    registeredUsers.add(newUser);
    currentUser = newUser;
    return true;
  }

  bool login({required String email, required String password}) {
    final match = registeredUsers.where((user) => user.email == email && user.password == password);
    if (match.isEmpty) {
      return false;
    }

    currentUser = match.first;
    return true;
  }

  void logout() {
    currentUser = null;
  }

  bool get isSessionValid => currentUser != null;

  String verifySession() {
    if (!isSessionValid) {
      throw StateError('Session is invalid. Please login again.');
    }

    return currentUser!.email;
  }

  String uploadDocument(String documentName) {
    final safeName = documentName.trim().replaceAll(' ', '_');
    return 'https://storage.smarthealth.app/documents/$safeName';
  }

  Claim createClaimRequest({
    required String description,
    required double amount,
    required String documentName,
    required String documentUrl,
  }) {
    final id = 'CL-${1000 + claims.length + 1}';
    final now = DateTime.now();

    return Claim(
      id: id,
      date: '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
      description: description,
      amount: amount,
      status: ClaimStatus.submitted,
      documentName: documentName,
      documentUrl: documentUrl,
    );
  }

  Claim saveClaimData(Claim claim) {
    claims.insert(0, claim);
    return claim;
  }

  AppNotification triggerNotification(Claim claim) {
    final now = DateTime.now();
    final notification = AppNotification(
      id: 'NT-${100 + notifications.length + 1}',
      title: 'Claim submitted',
      message: 'Your claim ${claim.id} has been submitted and is under review.',
      date: '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
    );

    notifications.insert(0, notification);
    return notification;
  }

  Claim submitNewClaim({
    required String description,
    required double amount,
    required String documentName,
    required String documentUrl,
  }) {
    verifySession();
    final request = createClaimRequest(
      description: description,
      amount: amount,
      documentName: documentName,
      documentUrl: documentUrl,
    );
    final savedClaim = saveClaimData(request);
    triggerNotification(savedClaim);
    return savedClaim;
  }

  void markAllNotificationsRead() {
    for (final note in notifications) {
      note.read = true;
    }
  }
}
