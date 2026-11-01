class ServerModel {
  String type; // CCCAM / IPTV
  String host;
  String port;
  String user;
  String pass;
  String desKey;

  ServerModel({required this.type, required this.host, required this.port, required this.user, required this.pass, this.desKey = '01 02 03 04 05 06 07 08 09 10 11 12 13 14'});

  Map<String,String> toGnFormat() {
    if(type == 'CCCAM'){
      return {
        'protocol': 'cccam',
        'host': host,
        'port': port,
        'user': user,
        'pass': pass,
      };
    } else {
      return {
        'protocol': 'iptv',
        'host': host,
        'port': port,
        'user': user,
        'pass': pass,
      };
    }
  }

  String toOscamLine() {
    if(type == 'CCCAM'){
      return 'C: $host $port $user $pass';
    } else {
      return '$host:$port/get.php?username=$user&password=$pass&type=m3u_plus';
    }
  }
}
