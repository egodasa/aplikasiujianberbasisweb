var express = require('express');
var router = express.Router();
var validator = require('../validator/validator')
let pk = "id_user"
let tbl = "tbuser"
let md5=require('md5')
router.get('/:id?',(req, res, next)=>{
	var id = req.params.id || 0;
	var limit = parseInt(req.query.limit) || null;
	var offset = parseInt(req.query.offset) || null;
	var hasil = {};
    let query = {
        show : null,
        count : null,
        tmp : null
    }
    if(id == 0){
        query.count = db('lap_user').select('id_user')
        query.tmp = db('lap_user').select()
        //query.tmp = db('lap_user').select().where(req.query)
    }else{
        query.count = db('lap_user').select().where('id_user',id)
        query.tmp = db('lap_user').select().where('id_user',id)
    }
    if(limit == null && offset == null) {
        query.show = query.tmp
    }
    else {
        query.show = query.tmp.limit(limit).offset(offset)
    }
	query.show.then(function(rows){
        hasil.kode = 0;
		hasil.status = true;
		hasil.data = rows;
		hasil.current_row = rows.length;
		return query.count
		}).
	then((rows)=>{
        let code
		hasil.row = rows.length
        if(rows.length == 0) code = 204
        else code = 200
		res.status(code).json(hasil);
		}).
	catch(function(err){
        hasil.kode = 1;
		hasil.status = false
		hasil.error = err;
		res.status(503).json(hasil);
		});
	});


router.post('/',(req,res,next)=>{
	var data = req.body;
	var hasil = {};
    
	req.checkBody(validator.user);
	req.getValidationResult().then(function(result){
	result.useFirstErrorOnly();
	var pesan = result.mapped();
	if(result.isEmpty() == false){
        
		hasil.status = false;
		hasil.error = pesan;
		res.status(422).json(hasil); 
	}
	else{
        data.password = md5(data.password)
		db('tbuser').insert({
            username : data.username,
            password : data.password,
            id_juser : data.id_juser
            }).
		then(function(){
			hasil.status = true;
			res.json(hasil);
			}).
		catch(function(err){
            
			hasil.status = false;
			hasil.error = err;
			res.status(503).json(hasil);
			});
	}
	});
});
router.delete('/:id',(req,res,next)=>{
	var id = " "+req.params.id;
	var hasil = {};
	db(tbl).where(pk,id).del().
	then(function(){
		hasil.status = true;
		res.json(hasil);
		}).
	catch(function(err){
		hasil.status = false;
		hasil.error = err;
		res.status(503).json(hasil);
		});
	});
router.put('/:id',(req,res,next)=>{
	var data = req.body;
	var id = req.params.id;
	var hasil = {};
    
	req.checkBody(validator.edit_user);
	req.getValidationResult().then(function(result){
	result.useFirstErrorOnly();
	var pesan = result.mapped();
	if(result.isEmpty() == false){
		hasil.status = false,
		hasil.error = pesan;
		res.status(422).json(hasil);
	}
	else{
        data.password = md5(data.password)
		db('tbuser').where(pk,id).update({
            password : data.password
            }).
		then(function(){
			hasil.status = true;
			res.json(hasil);
			}).
		catch(function(err){
			hasil.status = false;
			hasil.error = err;
			res.status(503).json(hasil);
			});
	}
	});
});

module.exports = router;
