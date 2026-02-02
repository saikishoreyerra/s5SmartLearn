/// ViewModel for ForgotPasswordPage. Handles change-password action.
class ForgotPasswordViewModel {
  Future<bool> changePassword({
    required String current,
    required String newPassword,
    required String reEnter,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return true;
  }
}
