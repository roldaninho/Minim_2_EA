import {Schema,model,Document} from 'mongoose';

const schema = new Schema({
    feedId: String,
    username: String,
    publicationDate: Date,
    content: String,
    likes: Array,
}, {collection: 'Comments'});

interface Comment extends Document {
    feedId: String,
    username: string;
    publicationDate: Date;
    content: string;
    likes: Array<string>;
}

export default model<Comment>('CommentPublication',schema);