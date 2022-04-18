class UserModel {
  String? userUid;
  String? email;
  String? phoneNumber;
  int? userID;

  UserModel({this.userUid, this.userID, this.email, this.phoneNumber});

     UserModel.fromMap(Map data){
       userID = data["userID"];
       email = data["email"];
       phoneNumber = data["phone"];
       userUid = data["uid"];
       
     }
   
 
}
