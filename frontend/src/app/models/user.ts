import { Injectable } from "@angular/core";

@Injectable()
export class User {
  _id: String;
  username: String;
  password: String;
  isAdmin: Boolean;

  constructor(_id:String = '', username:String = '', password:String = '', isAdmin:Boolean= false ) {
    this._id = _id;
    this.username = username;
    this.password = password;
    this.isAdmin = isAdmin
  }
}