import {Schema,model,Document} from 'mongoose';

const schema = new Schema({
    name: String,
    subjects: Array,
}, {collection: 'degrees'});

interface IDegree extends Document {
    name: String;
    subjects: Array<String>;
}

export default model<IDegree>('Degree',schema);