import 'package:intl/intl.dart';
class Utility{
  String DatefomatToReferDate(String bigTime) {
    DateTime tempDate = DateFormat("yyyy-MM-dd' 'HH:mm:ss").parse(bigTime);
    // var dateFormat = DateFormat("MM-dd-yyyy"); // you can change the format here
    var dateFormat = DateFormat.yMMMMd(); // you can change the format here
    var utcDate = dateFormat.format(tempDate); // pass the UTC time here
    var localDate = dateFormat.parse(utcDate, false).toLocal().toString();
    String createdDate = dateFormat.format(DateTime.parse(localDate));
    // print("formated date is------------$createdDate");
    return createdDate;
  }
  String DatefomatToReferDateTime(String bigTime) {
    DateTime tempDate = DateFormat("yyyy-MM-dd' 'HH:mm:ss").parse(bigTime);
    // var dateFormat = DateFormat("MM-dd-yyyy"); // you can change the format here
    var dateFormat = DateFormat.Hm(); // you can change the format here
    var utcDate = dateFormat.format(tempDate); // pass the UTC time here
    var localDate = dateFormat.parse(utcDate, false).toLocal().toString();
    String createdDate = dateFormat.format(DateTime.parse(localDate));
    // print("formated date is------------$createdDate");
    return createdDate;
  }
  String DatefomatToMonth(String bigTime) {
    DateTime tempDate = DateFormat("yyyy-MM-dd' 'HH:mm:ss").parse(bigTime);
    // var dateFormat = DateFormat("MM-dd-yyyy"); // you can change the format here
    var dateFormat = DateFormat.MMMM(); // you can change the format here
    var utcDate = dateFormat.format(tempDate); // pass the UTC time here
    var localDate = dateFormat.parse(utcDate, false).toLocal().toString();
    String createdDate = dateFormat.format(DateTime.parse(localDate));
    // print("formated date is------------$createdDate");
    return createdDate;
  }
  String DatefomatToYear(String bigTime) {
    DateTime tempDate = DateFormat("yyyy-MM-dd' 'HH:mm:ss").parse(bigTime);
    // var dateFormat = DateFormat("MM-dd-yyyy"); // you can change the format here
    var dateFormat = DateFormat.y(); // you can change the format here
    var utcDate = dateFormat.format(tempDate); // pass the UTC time here
    var localDate = dateFormat.parse(utcDate, false).toLocal().toString();
    String createdDate = dateFormat.format(DateTime.parse(localDate));
    // print("formated date is------------$createdDate");
    return createdDate;
  }
  String DatefomatToDate(String bigTime) {
    DateTime tempDate = DateFormat("yyyy-MM-dd' 'HH:mm:ss").parse(bigTime);
    // var dateFormat = DateFormat("MM-dd-yyyy"); // you can change the format here
    var dateFormat = DateFormat.d(); // you can change the format here
    var utcDate = dateFormat.format(tempDate); // pass the UTC time here
    var localDate = dateFormat.parse(utcDate, false).toLocal().toString();
    String createdDate = dateFormat.format(DateTime.parse(localDate));
    // print("formated date is------------$createdDate");
    return createdDate;
  }
  String DatefomatToTime24(String bigTime) {
    DateTime tempDate = DateFormat("yyyy-MM-dd' 'HH:mm:ss").parse(bigTime);
    // var dateFormat = DateFormat("MM-dd-yyyy"); // you can change the format here
    var dateFormat = DateFormat.Hm(); // you can change the format here
    var utcDate = dateFormat.format(tempDate); // pass the UTC time here
    var localDate = dateFormat.parse(utcDate, false).toLocal().toString();
    String createdDate = dateFormat.format(DateTime.parse(localDate));
    // print("formated date is------------$createdDate");
    return createdDate;
  }
}
