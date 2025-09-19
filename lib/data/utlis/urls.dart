class Urls{
  static const String _baseUrl ='https://task.teamrabbil.com/api/v1';
  static const String signInUrl='$_baseUrl/login';
  static const String signUpUrl='$_baseUrl/registration';
  static  String recoveryMailUrl(String email) => '$_baseUrl/RecoverVerifyEmail/$email';
  static  String recoveryOtpUrl(String email, String pinCode) => '$_baseUrl/RecoverVerifyOTP/$email/$pinCode';
  static const String resetPasswordUrl = '$_baseUrl/RecoverResetPass';
  static const String addNewTaskUrl = '$_baseUrl/createTask';
  static const String updateProfileUrl = '$_baseUrl/profileUpdate';
  static const String taskStatusCountUrl = '$_baseUrl/taskStatusCount';
  static  String newTaskListByStatus(String status) => '$_baseUrl/listTaskByStatus/$status';
  static  String progressTaskListByStatus(String status) => '$_baseUrl/listTaskByStatus/$status';
  static  String completedTaskListByStatus(String status) => '$_baseUrl/listTaskByStatus/$status';
  static  String cancelledTaskListByStatus(String status) => '$_baseUrl/listTaskByStatus/$status';
  static  String taskStatusUpdate(String id, String status) => '$_baseUrl/updateTaskStatus/$id/$status';
  static  String deleteTask(String id) => '$_baseUrl/deleteTask/$id';
}
