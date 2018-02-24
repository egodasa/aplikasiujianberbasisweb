var express = require('express');
var router = express.Router();
let jwt = require('jsonwebtoken')
let md5 = require('md5')
router.post('/',(req, res, next)=>{
	let username = req.body.username
    let password = req.body.password
    let hasil = {}
    let query = db('lap_user').select()
	query.where({username:username,password:md5(password)}).
	then(function(rows){
		hasil.status = true;
        hasil.data = {token:null}
		if(rows.length != 1){
            res.json(hasil)
        }else if(rows.length == 1){
            hasil.data.token =jwt.sign({
              data: rows[0]
            }, 'Panther A 7.5cm kwk 42 L/70', { expiresIn:  86400 });
            res.json(hasil)
        }else {
            res.json({data : {token:null}})
            }
		}).
	catch(function(err){
		hasil.status = false
		hasil.error = err;
        hasil.token = null
		res.status(503).json(hasil);
		});
	});
module.exports = router
