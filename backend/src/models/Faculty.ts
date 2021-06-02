import {Schema,model,Document} from 'mongoose';
import Degree from './Degree';

const schema = new Schema({
    name: String,
    degrees: Array,
}, {collection: 'faculties'});

interface IFaculty extends Document {
    name: String;
    degree: Array<typeof Degree>;
}

export default model<IFaculty>('Faculty',schema);