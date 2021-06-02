import app from './app';
import {startConnection} from './database';
import {Server, Socket} from 'socket.io';
import { createServer } from "http";

const  http = createServer(app);
const io = new Server(http, { cors: { origin: '*' } });

async function main(){
    startConnection();

    io.on('connection', (socket: Socket) => {
        //Get the chatID of the user and join in a room of the same chatID
        let chatID = socket.handshake.query.chatID
        socket.join("" + chatID)
    
        //Leave the room if the user closes the socket
        socket.on('disconnect', () => {
            socket.leave("" + chatID)
        })
    
        //Send message to only a particular user
        socket.on('send_message', message => {
            let receiverChatID = message.receiverChatID
            let senderChatID = message.senderChatID
            let content = message.content
    
            //Send message to only that particular room
            socket.in(receiverChatID).emit('receive_message', {
                'content': content,
                'senderChatID': senderChatID,
                'receiverChatID':receiverChatID,
            })
        })
    });
    await app.listen(app.get('port'));

    console.log('Server on port',app.get('port'))
    console.log('Cors-enabled for all origins')
}

main();