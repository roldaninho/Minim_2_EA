import {Request, Response} from 'express'
import User from '../models/User'
import FeedPublication from '../models/feedPublication'
import Comments from '../models/comments'

import jwt from 'jsonwebtoken'


export async function createComment (req: any, res: Response){
    const Btoken = req.headers['authorization'];

    if(typeof Btoken !== undefined){
        req.token = Btoken;
        jwt.verify(req.token, 'mykey', async(error: any, authData: any) => {
            if(error){
                return res.status(205).send({message: 'Authorization error'});
            } else {
                
                let {feedId, username, publicationDate, content} = req.body;
                let newComment = new Comments;
                newComment.feedId = feedId;
                newComment.content= content;
                newComment.publicationDate= publicationDate;
                newComment.username=username;

                newComment.likes= [];
                try{

                    let result = await newComment.save();
                    return res.status(200).send({message: "Comment Publicado correctamente"});
                } catch {
                    return res.status(500).send({message: "Internal server error"});
                }
            }
        });
    } else {
        return res.status(204).send({message: 'Unauthorized'});
    }

}

export async function deleteComment (req: any, res: Response){
    const Btoken = req.headers['authorization'];

    if(typeof Btoken !== undefined){
        req.token = Btoken;
        jwt.verify(req.token, 'mykey', async(error: any, authData: any) => {
            if(error){
                return res.status(205).send({message: 'Authorization error'});
            } else {
                try{
                    await Comments.findOneAndRemove({_id: req.params.id});
                    return res.status(200).send({message: "Comment correctly deleted"});
                } catch {
                    return res.status(500).send({message: "Internal server error"});
                }
            }
        });
    } else {
        return res.status(204).send({message: 'Unauthorized'});
    }
    
}


export async function getComments (req: any, res: Response){
    const Btoken = req.headers['authorization'];
    let feedId = req.body;

    if(typeof Btoken !== undefined){
        req.token = Btoken;
        jwt.verify(req.token, 'mykey', async(error: any, authData: any) => {
            if(error){
                return res.status(205).send({message: 'Authorization error'});
            } else {

                try{
                    var comments = await Comments.find({feedId: feedId})
                    

                    if (comments.length !=0){
                        return res.status(200).header('Content Type - application/json').send(comments);

                    }else
                        return res.status(404).send({message: "Your friends haven't posted yet"});
                } catch {
                    return res.status(500).send({message: "Internal server error"});
                }
            }
        });
    } else {
        return res.status(204).send({message: 'Unauthorized'});
    }

}

export async function updateComment (req: any, res: Response){
    let{_id, Content } = req.body;
    const Btoken = req.headers['authorization'];
    const updateData = {
        content: Content,
    }

    if(typeof Btoken !== undefined){
        req.token = Btoken;
        jwt.verify(req.token, 'mykey', async(error: any, authData: any) => {
            if(error){
                return res.status(205).send({message: 'Authorization error'});
            } else {
                try {
                    await Comments.findByIdAndUpdate({_id: _id}, updateData)
                    return res.status(200).send({message: 'Comment correctly updated'});
                } catch {
                    return res.status(201).send({message: "Comment couldn't be updated"});
                }
            }
        });
    } else {
        return res.status(204).send({message: 'Unauthorized'});
    }

}

export async function updateLikesComment (req: any, res: Response){
    let{usernameLiking, _id} = req.body;
    const Btoken = req.headers['authorization'];
    const action = req.headers['action'];


    if(typeof Btoken !== undefined){
        req.token = Btoken;
        jwt.verify(req.token, 'mykey', async(error: any, authData: any) => {
            if(error){
                return res.status(205).send({message: 'Authorization error'});
            } else {
                try {
                    const comment = await Comments.findById({_id: _id});
                    let liking = comment?.likes
                    if (action=='add'){
                        liking?.push(usernameLiking)
                        await Comments.findByIdAndUpdate({_id: _id}, {likes: liking})
                        return res.status(200).send({message: 'CommentLikes correctly updated'});
                    }else
                        liking?.splice(liking?.findIndex(usernameLiking),1);
                        await Comments.findByIdAndUpdate({_id: _id}, {likes: liking})
                        return res.status(200).send({message: 'CommentLikes correctly updated'});

                } catch {
                    return res.status(201).send({message: "CommentLikes couldn't be updated"});
                }
            }
        });
    } else {
        return res.status(204).send({message: 'Unauthorized'});
    }

}

