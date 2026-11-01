import 'multi_port_manager.dart';

class GnRemoteService {
  void power() => MultiPortManager.I.sendKey('POWER');
  void volUp() => MultiPortManager.I.sendKey('VOL+');
  void volDown() => MultiPortManager.I.sendKey('VOL-');
  void chUp() => MultiPortManager.I.sendKey('CH+');
  void chDown() => MultiPortManager.I.sendKey('CH-');
  void ok() => MultiPortManager.I.sendKey('OK');
  void menu() => MultiPortManager.I.sendKey('MENU');
  void exit() => MultiPortManager.I.sendKey('EXIT');
}
