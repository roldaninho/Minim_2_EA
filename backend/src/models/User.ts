import {Schema,model,Document} from 'mongoose';

const schema = new Schema({
    _id: String,
    username: String,
    password: String,
    fullname: String,
    description: String,
    university: String,
    degree: String,
    role: String,
    subjectsDone: Array,
    subjectsRequested: Array,
    recommendations: String,
    isAdmin: Boolean,
    phone: String,
    followers: Array,
    following: Array,
    profilePhoto: String,
    //Coins: Number
}, {collection: 'users'});

interface IUser extends Document {
    _id: string,
    username: string;
    password: string;
    fullname: string;
    description: string,
    university: string,
    degree: string,
    role: string,
    subjectsDone: Array<string>,
    subjectsRequested: Array<string>,
    recommendations: string,
    isAdmin: Boolean;
    phone: string,
    followers: Array<string>;
    following: Array<string>;
    profilePhoto: String;
    //Coins: Number
}

export default model<IUser>('User',schema);