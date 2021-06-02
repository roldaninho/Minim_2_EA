import {Router} from 'express';
import {createUser, loginUser, deleteUser, getUsers,/*, getAdmin*/
updateUser, getUser, getAdmin, getUniversities, getDegrees, getSubjects, updateFollowers, getUserImage} from '../controllers/user.controller'
import { getOffer, getOffers, updateOffer, deleteOffer, createOffer, updateBuys, updateLikesOffer, getAllOffers} from '../controllers/offer.controller'
import { getFeed, getFeeds, updateFeed, deleteFeed, createFeed, updateLikesFeed, getAllFeeds, createSugerencia, deleteSugerencia, getSugerencia, getSugerencias, getAllSugerencias, updateSugerencia } from '../controllers/feedPublication.controller'
import { createComment, deleteComment, getComments, updateComment, updateLikesComment } from '../controllers/comments.controller';

const router = Router();
    


router.route('/User/newUser/').post(createUser);
    
router.route('/User/loginUser/').post(loginUser);

router.route('/User/deleteUser/:username').delete(deleteUser);

router.route('/User/getUsers').get(getUsers);

router.route('/User/getUser/:username').get(getUser);

router.route('User/getAdmin/:id').get(getAdmin);

//profile update
router.route('/User/updateUser').post(updateUser);

//Offer Crud
router.route('/Offer/newOffer').post(createOffer);

router.route('/Offer/deleteOffer/:id').delete(deleteOffer);

router.route('/Offer/getOffer/:username').get(getOffer);

//router.route('/Offer/getOffers').post(getOffers);

router.route('/Offer/getAllOffers').get(getAllOffers);

router.route('/Offer/updateOffer').post(updateOffer);

//Feed Crud
router.route('/Feed/newFeed').post(createFeed);

router.route('/Feed/deleteFeed/:id').delete(deleteFeed);

router.route('/Feed/getFeed/:username').get(getFeed);

router.route('/Feed/getFeeds').post(getFeeds);

router.route('/Feed/getAllFeeds').get(getAllFeeds);

router.route('/Feed/updateFeed').post(updateFeed);

router.route('/User/getUserImage/:username').get(getUserImage);

//Sugerencia Crud

router.route('/Sugerencia/newSugerencia').post(createSugerencia);

router.route('/Sugerencia/deleteSugerencia/:id').delete(deleteSugerencia);

router.route('/Sugerencia/getSugerencia/:username').get(getSugerencia);

router.route('/Sugerencia/getSugerencias').post(getSugerencias);

router.route('/Sugerencia/getAllSugerencias').get(getAllSugerencias);

router.route('/Sugerencia/updateSugerencia').post(updateSugerencia);


//Get Universities/Faculties/Degrees/Subjects

router.route('/Data/getUniversities').get(getUniversities);

router.route('/Data/getDegrees/:school').get(getDegrees);

router.route('/Data/getSubjects/:degree').get(getSubjects);

//Explore Feed

//Comments
router.route('/Post/newComment').post(createComment);

router.route('/Post/deleteComment/:id').delete(deleteComment);

router.route('/Post/getComments').get(getComments);

router.route('/Post/updateComment').post(updateComment);


//Likes, Buys & following

router.route('/Feed/updateLikes/:action').post(updateLikesFeed);

router.route('/User/Offers/updateLikes').post(updateLikesOffer);

router.route('/User/Comments/updateLikes').post(updateLikesComment);

router.route('/Offer/updateBuys').post(updateBuys);

router.route('/User/updateFollowers').post(updateFollowers);


//router.route('/User/loginUser/').put(loginUser); //Forgot password

export default router;