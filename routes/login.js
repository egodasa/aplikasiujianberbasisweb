var express = require('express');
var router = express.Router();
let jwt = require('jsonwebtoken')

router.post('/cek',(req, res, next)=>{
	let username = req.body.username
    let password = req.body.password
    let hasil = {}
    let query = db('lap_user').select()
	query.where({username:username,password:password}).
	then(function(rows){
		hasil.status = true;
		if(rows.length != 0){
			let token = jwt.sign(rows[0], 'Panther G 7.5cm kwk 42L/70', {
				expiresIn: 86400 // expires in 24 hours
				});
			rows[0].token = token
		}else rows[0].token = null
		hasil.data = rows;
		hasil.current_row = rows.length;
        res.json(hasil);
		}).
	catch(function(err){
		hasil.status = false
		hasil.error = err;
		res.status(503).json(hasil);
		});
	});
    
module.exports = router;
