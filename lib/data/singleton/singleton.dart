
class SingleToneValue {


  String ? status;
  String ? driverID;
  int ? vehicleTypeId;
  int ? serviceTypeId;
  // StreamSubscription<LocationData>? stream;
  // String  code=Constants.countryCode;
  String ? number;
  bool ? orderPlaced=true;
  double  currentLat=33.781640;
  double  currentLng=72.351953;
  double?  user2Lat;
  double?  user2Lng;

  double? user2Height;
  double? currentHeight;
  String  onlineOffline='offline';
  double  pickLat=0.0;
  double  pickLng=0.0;
  String user2Name='';
  String currentName='';
  double  dropLat=0.0;
  double  dropLng=0.0;
  String ? dropAddress;
  String ? deviceToken;


  SingleToneValue._privateConstructor();

  static SingleToneValue get instance => _instance;

  static final SingleToneValue _instance = SingleToneValue._privateConstructor();

  factory SingleToneValue() {
    return _instance;
  }
}