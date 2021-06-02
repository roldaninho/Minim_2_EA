import {Schema,model,Document} from 'mongoose';
import Faculty from './Faculty';

const schema = new Schema({
    name: String,
    schools: Object,
}, {collection: 'universities'});

interface IUniversity extends Document {
    name: String;
    schools: Object;
}

export default model<IUniversity>('University',schema);