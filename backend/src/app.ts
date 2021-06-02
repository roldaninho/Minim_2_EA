import express from 'express';
import cors from 'cors'
import morgan from 'morgan';
import path from 'path'

const app = express();

import indexRoutes from './routes/index'


//settings
app.set('port', process.env.PORT || 4000); // definim la variable PORT 



// Middlewares
app.use(morgan('dev'));
app.use(express.json());
app.use(cors());


//Routes
app.use('/',indexRoutes); //Configurem qui sera l'autoritat de les rutes que arribin amb /app

export default app;