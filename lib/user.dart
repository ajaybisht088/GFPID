class User {
	int id;
	String username;
	String userpassword;
  String useremail;
  String usersecretkey;

	User({this.id, this.username, this.userpassword, this.useremail, this.usersecretkey});
	// User();
	User.fromMap(dynamic obj) {
		print(obj);
	  this.id = obj['id'];
	  // print(this._id);
		this.username = obj['username'];
		// print(this._username);
		this.userpassword = obj['userpassword'];
		// print(this._userpassword);
		this.useremail = obj['useremail'];
		// print(this._useremail);
		this.usersecretkey = obj['usersecretkey'];
		// print(this._usersecretkey);
		// return
	}
  // int get id => _id;
	// String get username => _username;
	// String get userpassword => _userpassword;
  // String get useremail => _useremail;
  // String get usersecretkey => _usersecretkey;

	Map<String, dynamic> toMap() {
		var map = new Map<String, dynamic>();
		map["id"] = id;
		map["username"] = username;
		map["userpassword"] = userpassword;
    map["useremailuser"] = useremail;
    map["usersecretkey"] = usersecretkey;
		return map;
	}
}