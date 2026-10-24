class MockSession {
  MockSession._();

  static String? name;
  static String? phone;
  static String? email;

  static final List<Map<String, String>> technicianApplications = [];

  static void signUpCustomer({
    required String name,
    required String phone,
    required String email,
  }) {
    MockSession.name = name;
    MockSession.phone = phone;
    MockSession.email = email;
  }

  static void submitTechnicianApplication(Map<String, String> data) {
    technicianApplications.add(data);
  }

  static void clear() {
    name = null;
    phone = null;
    email = null;
  }
}