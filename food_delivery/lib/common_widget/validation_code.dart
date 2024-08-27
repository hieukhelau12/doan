String? validateField(String? value) {
  if (value == null || value.isEmpty) {
    return 'Vui lòng nhập đầy đủ thông tin';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Vui lòng nhập email';
  }
  final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  if (!emailRegex.hasMatch(value)) {
    return 'Email không hợp lệ';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Vui lòng nhập mật khẩu';
  }
  if (value.length < 6) {
    return 'Mật khẩu phải có ít nhất 6 ký tự';
  }
  return null;
}

String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Vui lòng nhập tên';
  }
  return null;
}

String? validatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Vui lòng nhập số điện thoại';
  }
  if (value.length < 10 || value.length > 10) {
    return 'Số điện thoại sai định dạng, vui lòng nhập lại';
  }
  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
    return 'Số điện thoại sai định dạng, vui lòng nhập lại';
  }
  return null;
}

// Validator cho mật khẩu xác nhận
String? validateConfirmPassword(String? value, String? password) {
  if (value == null || value.isEmpty) {
    return 'Vui lòng xác nhận mật khẩu';
  }
  if (value != password) {
    return 'Mật khẩu không khớp';
  }
  return null;
}
