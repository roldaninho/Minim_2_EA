import { User } from './../models/user';
import { UserService } from '../services/userService';
import { Component, OnInit } from '@angular/core';
import { NgForm } from "@angular/forms";
import { HttpErrorResponse } from '@angular/common/http';
import { Router } from '@angular/router';

@Component({
  selector: 'app-list',
  templateUrl: './list.component.html',
  styleUrls: ['./list.component.css'],
  providers: [UserService],
})
export class ListComponent implements OnInit {

  constructor(private router: Router, private userService: UserService) { }

  users: User[];
  user: User;
  currentUser: User;
  //isAdmin: Boolean;
  
  ngOnInit(): void {
    
    //this.isAdmin=false;
    /*this.isAdminst(id);*/
    this.getUsers();
  }

  updateInfo(){
    this.userService.getUsers().subscribe(users=>{this.users = users});
  }

  public institutionSelect(user){
    this.currentUser = user;
  }

  /*public deleteUser(username: string) {
    if (confirm("Are you sure you want to delete it?")) {
      this.userService.deleteUser(username).subscribe((res) => {
        this.getUsers();
      });
    }
  }*/

  public deleteUser(_username: String){
    
    if (confirm("Are you sure you want to delete it?")) {
      console.log(_username);
      this.userService.deleteUser(_username).subscribe((res) => {

        this.updateInfo();
      });
    /*user = this.currentUser;
    this.userService.deleteUser(this.currentUser)
      .subscribe (res => {
        console.log('Res' + res);
        this.updateInfo();
      },      
      err => {
        console.log(err);
        ListComponent.handleError(err);
      });*/
  }
}

  public getUsers() {
    this.userService.getUsers().subscribe((res) => {
      this.users = res;
      console.log(this.users);
    });
  }

  /*public isAdminst(_id: String){
    this.userService.isAdminst(_id).subscribe((res) => {
      let code = res.toString();
      if (code=='200'){
          this.isAdmin=true;
      }
    });

  }
  */


  private static handleError(err: HttpErrorResponse) {
    if ( err.status === 500 ) {
      alert('Ha ocurrido un error al crear la lista de usuarios');
    }
  }

}
