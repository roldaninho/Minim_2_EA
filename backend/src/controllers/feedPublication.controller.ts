import {Request, Response} from 'express'
import User from '../models/User'
import FeedPublication from '../models/feedPublication'

import jwt from 'jsonwebtoken'


export async function createFeed (req: any, res: Response){
    const Btoken = req.headers['authorization'];

    if(typeof Btoken !== undefined){
        req.token = Btoken;
        jwt.verify(req.token, 'mykey', async(error: any, authData: any) => {
            if(error){
                return res.status(205).send({message: 'Authorization error'});
            } else {
                let {content, username, date} = req.body;
                let newFeed = new FeedPublication();
                newFeed.content= content;
                newFeed.publicationDate= date;
                newFeed.username=username;
                newFeed.likes= [];
                newFeed.comments= [];
                try{
                    let feedMod = await newFeed.save();
                    return res.status(200).header('Content Type - application/json').send(feedMod);
                } catch {
                    return res.status(500).send({message: "Internal server error"});
                }
            }
        });
    } else {
        return res.status(204).send({message: 'Unauthorized'});
    }

}

export async function deleteFeed (req: any, res: Response){
    const Btoken = req.headers['authorization'];

    if(typeof Btoken !== undefined){
        req.token = Btoken;
        jwt.verify(req.token, 'mykey', async(error: any, authData: any) => {
            if(error){
                return res.status(205).send({message: 'Authorization error'});
            } else {
                try{
                    await FeedPublication.findOneAndRemove({_id: req.params.id});
                    return res.status(200).send({message: "Feed correctly deleted"});
                } catch {
                    return res.status(500).send({message: "Internal server error"});
                }
            }
        });
    } else {
        return res.status(204).send({message: 'Unauthorized'});
    }
}

export async function getFeed (req: any, res: Response){
    const Btoken = req.headers['authorization'];
    let username= req.params.username;

    if(typeof Btoken !== undefined){
        req.token = Btoken;
        jwt.verify(req.token, 'mykey', async(error: any, authData: any) => {
            if(error){
                return res.status(205).send({message: 'Authorization error'});
            } else {
                const userfound = await User.findOne({username: username});
                try{
                    if(userfound != null){
                        const feeds = await FeedPublication.find({username: username})
                        if (feeds!=null){
                            return res.status(200).header('Content Type - application/json').send(feeds);
                        }else
                        return res.status(204).send({message: "U have no feeds my dear"});
            
                    } else {
                        return res.status(404).send({message: "User not found"});
                    }
                } catch {
                    return res.status(500).send({message: "Internal server error"});
                }
            }
        });
    } else {
        return res.status(204).send({message: 'Unauthorized'});
    }


}


export async function getFeeds (req: any, res: Response){
    const Btoken = req.headers['authorization'];
    var following = req.body;
    const feeds: any[]=[];
    

    if(typeof Btoken !== undefined){
        req.token = Btoken;
        jwt.verify(req.token, 'mykey', async(error: any, authData: any) => {
            if(error){
                return res.status(205).send({message: 'Authorization error'});
            } else {

                try{
                    let cont= 0
                    while(cont<following.length){
                        let username= following[cont]
                        var feed= await FeedPublication.find({username: username})
                        if (feed!= null){
                            let cont2= 0
                            while(cont2<feed.length){
                                feeds.push(feed[cont2])
                                cont2++
                            }

                        }
                        cont++
                    }
                    

                    if (feeds.length !=0){
                        return res.status(200).header('Content Type - application/json').send(feeds);

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

export async function getAllFeeds (req: any, res: Response){
    const Btoken = req.headers['authorization'];
    if(typeof Btoken !== undefined){
        req.token = Btoken;
        jwt.verify(req.token, 'mykey', async(error: any, authData: any) => {
            if(error){
                return res.status(205).send({message: 'Authorization error'});
            } else {
                try{
                        const feeds = await FeedPublication.find();
                        if (feeds!=null){
                            return res.status(200).header('Content Type - application/json').send(feeds);
                        }else
                            return res.status(204).send({message: "There aren't any feeds my dear"});
                } catch {
                    return res.status(500).send({message: "Internal server error"});
                }
            }
        });
    } else {
        return res.status(204).send({message: 'Unauthorized'});
    }
}

export async function updateFeed (req: any, res: Response){
    let{username, Content } = req.body;
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
                    await User.findOneAndUpdate({username: username}, updateData);
                    return res.status(200).send({message: 'Feed correctly updated'});
                } catch {
                    return res.status(201).send({message: "Feed couldn't be updated"});
                }
            }
        });
    } else {
        return res.status(204).send({message: 'Unauthorized'});
    }

}

export async function updateLikesFeed (req: any, res: Response){
    let{username, _id} = req.body;
    const Btoken = req.headers['authorization'];
    const action = req.params.action;


    if(typeof Btoken !== undefined){
        req.token = Btoken;
        jwt.verify(req.token, 'mykey', async(error: any, authData: any) => {
            if(error){
                return res.status(205).send({message: 'Authorization error'});
            } else {
                try {
                    const feed = await FeedPublication.findById({_id: _id});
                    let liking = feed?.likes
                    if (action=='add'){
                        liking?.push(username)
                        await FeedPublication.findByIdAndUpdate({_id: _id}, {likes: liking})
                        return res.status(200).send({message: 'FeedLikes correctly updated'});
                    }else{
                        liking?.splice(liking?.findIndex(findUsername),1);
                        await FeedPublication.findByIdAndUpdate({_id: _id}, {likes: liking})
                        return res.status(200).send({message: 'FeedLikes correctly updated'});
                    }
                } catch {
                    return res.status(201).send({message: "FeedLikes couldn't be updated"});
                }
            }
        });
    } else {
        return res.status(204).send({message: 'Unauthorized'});
    }

}

function findUsername(username: String, liking:any){
    for(var count=0;count<liking?.length;count++){
        if(liking[count] == username){
            return count;
        }
    }
}
