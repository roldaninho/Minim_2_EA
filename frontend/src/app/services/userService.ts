import { Injectable } from '@angular/core';
import {UrlApi} from "./UrlApi";
import { HttpClient } from '@angular/common/http';
import {User} from '../models/user'

@Injectable({
  providedIn: 'root'
})
export class UserService {
  selectedUser: User;
  users: User[];
  url: UrlApi;

  constructor(private http: HttpClient) {
    this.selectedUser = new User();
    this.url = new UrlApi();
  }

  loginUser(user: User){
    return this.http.post(this.url.urlUser + '/loginUser/', user);
  }

  newUser(user: User){
    return this.http.post(this.url.urlUser + '/newUser/', user);
  }
  
  deleteUser(_username: String){
    return this.http.delete(this.url.urlUser + '/deleteUser' + `/${_username}`);
  }

  getUsers(){
    return this.http.get<User[]>(this.url.urlUser + '/getUsers/');
  }
  
  //isAdminst(_id: String){
   // return this.http.get<User>(this.url.urlUser +'/getAdmin'+`/${_id}`);
  //}
}