import {Schema,model,Document} from 'mongoose';

const schema = new Schema({
    username: String,
    title: String,
    description: String,
    publicationDate: Date,
    university: String,
    subject: String,
    price: Number,
    type: String,
    buys: Number,
    likes: Array
}, {collection: 'offers'});

interface IOffer extends Document {
    username: string;
    title: string;
    description: string;
    publicationDate: Date;
    university: string;
    subject: string;
    price: number;
    type: String;
    buys: number;
    likes: Array<string>;
}

export default model<IOffer>('Offer',schema);