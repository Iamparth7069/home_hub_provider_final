import 'package:get_storage/get_storage.dart';

class StorageService{
  static final StorageService _instance = StorageService._internal();
  late GetStorage _storage;
  static String registerStatus = "Register";
  static String profileDetailsStatus = "RegisterDetails";
  static String loginStatus = "LoginStatus";
  static String userId = "Userid";
  static String mcfToken = "fcmToken";
  static String nameMe = "Name";
  static String email = "email";
  static String password = "password";
  factory StorageService() {
    return _instance;
  }
  StorageService._internal() {
    _initStorage();
  }

  void _initStorage() async {
    await GetStorage.init(); // Initialize GetStorage
    _storage = GetStorage(); // Create an instance of GetStorage
  }

  Future<void> loginStatusCheck(bool value) async {
    await _storage.write(loginStatus, value);
  }

  dynamic getLoginStatus() {
    return _storage.read(loginStatus) ?? false;
  }

  setRegisterStatus(bool value) async {
    await _storage.write(registerStatus, value);
  }

  dynamic getRegisterStatus() {
    return _storage.read(registerStatus) ?? false;
  }

  setProfileDataStatus(bool value) async {
    await _storage.write(profileDetailsStatus, value);
  }

  dynamic getProfileDataStatus() {
    return _storage.read(profileDetailsStatus) ?? false;
  }


  Future<void> removeDAta() async {
    await _storage.erase();
  }

  UpdateUserId(String Userid) async {
    await _storage.write(userId, Userid);
  }
  String getUserid(){
    return _storage.read(userId) ?? "";
  }

  updateServices(String fcmToken) async {
    await _storage.write(mcfToken, fcmToken);
  }
  String getFcmtoken(){
    return _storage.read(mcfToken) ?? "";
  }


  UpdateUserName(String name) async {
    await _storage.write(nameMe, name);
  }

  String getName(){
    return _storage.read(nameMe) ?? "";
  }

  setEmail(String email) async {
    await _storage.write(email, email);
  }

  String getEmail(){
    return _storage.read(email) ?? "";
  }
  setPassword(String setPassword) async {
    await _storage.write(password, setPassword);
  }

  String getPassword(){
    return _storage.read(password) ?? "";
  }
}