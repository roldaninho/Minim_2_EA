import {Schema,model,Document} from 'mongoose';

const schema = new Schema({
    username: String,
    publicationDate: Date,
    content: String,
    comments: Array,
    likes: Array,
}, {collection: 'sugerenciaPublications'});

interface IFeedPub extends Document {
    username: string;
    publicationDate: Date;
    content: string;
    comments: Array<string>;
    likes: Array<string>;
}

export default model<IFeedPub>('SugerenciaPublication',schema);