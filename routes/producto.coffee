
router   = require('express').Router()
moment   = require 'moment'
user     = require '../models/userModel'
producto = require '../models/productoModel'
colors   = require 'colors'

files = require '../utils/files'

router.route '/'
    # RETURN JSON WITH ALL PRODUCTS
    .get user.isAuthenticated , (req, res, next) ->

        producto.find (err, results)->
            if err then return res.status(500).end()

            resp = []
            opts = [{ path: 'autor'}]  
            results.forEach (item)->          
                producto.populate item, opts, (err, data)->
                    resp.push data
                    if results.length is resp.length then return res.json resp
            

    # SAVE PRODUCT
    .post user.isAuthenticated , files.saveFile('./public/images/items').single('displayImage'), (req, res, next) ->

        console.log req.file

        new_product = new producto({
            nombre      : req.body.name
            descripcion : req.body.description
            recomendado : req.body.recomended
            norecomendado: req.body.notrecomended
            etiquetas   : req.body.tags.split(',') 
            tipo        : req.body.tipo 
            image       : if req.file and req.file.path then req.file.path else null
        })

        if req.user 
            new_product.autor = req.user_id
            if req.user.rol isnt 'user' 
                new_product.validado = true
                new_product.revisor  = req.user_id

        new_product.save (err, product)->
            if err then res.status(500).send( err.message)
            console.log '42' , product
            res.redirect 'product/' + product.nombre



router.route '/:slug'
    # SEE PRODUCT VIEW
    .get user.isAuthenticated , (req, res, next) ->

        producto.findOne  {nombre: req.params.slug} , (err, result)->
            if err or not result then return res.status(500).end()

            # num_visita = if isNaN(result.visitas) then 1 else result.visitas + 1
            producto.findOneAndUpdate {_id: result._id } , {visitas: result.visitas + 1}, (err)->                  
                if err then console.log colors.red(err) 

                opts = [{ path: 'autor'}, { path: 'revisor'}, { path: 'comentarios.autor' }]            
                producto.populate result, opts, (err, resp)->  
                    if err then return res.status(500).end() 

                    resp.comentarios = resp.comentarios.sort (a, b)->
                                                        r = new Date(a.created).getTime() - new Date(b.created).getTime()
                                                        return r < 0 ? true : false

                    # console.log colors.red(resp.comentarios)
                    res.render 'item/producto',
                        title   : resp.nombre + ' - ToleranceIn'
                        pageName: 'Produto'
                        user    : req.user
                        item    : resp



router.route '/edit/:slug'
    # EDIT PRODUCT VIEW
    .get user.isAuthenticated , (req, res, next) ->
        producto.findOne {nombre: req.params.slug} , (err, product)->
            if err then return res.status(500).end()
            res.render 'producto/edit',
                title   : 'Edit - ToleranceIn'
                pageName: 'EditProduct'
                user    : req.user
                producto: product


    # PRODUCT CREATION
    .post user.isAdmin, (req, res, next) -> 

        new_product = 
                    nombre      : req.body.name
                    descripcion : req.body.description
                    recomendado : req.body.recomended
                    norecomendado: req.body.notrecomended
                    etiquetas   : req.body.tags.split(',') 
                    tipo        : req.body.tipo 
                    revisor     : req.user._id
                    validado    : true

        producto.findOneAndUpdate {nombre: req.body.name} , new_product, (err, product)->
            if err then res.status(500).send( err.message)
            res.redirect 'product/' + product.nombre



router.route '/comment/:id'
    .get (req, res, next) -> 

        producto.findById(req.params.id).populate([{ path: 'comentarios.autor' }]).exec (err, product)-> 
        # producto.findById req.params.id, (err, product)->
            if err then return res.status(500).send( err.message)
            res.status(200).json({comentarios: product.comentarios})

router.route '/comment'
    # PRODUCT COMMENT
    .post user.isAuthenticated, (req, res, next) -> 
        
        new_comment = {
                        autor: if req.user then req.user._id else '57042cdb9302bc86384b3f57'
                        mensaje: req.body.comentario
                        created: Date.now()
        }

        producto.findByIdAndUpdate req.body.id, {$push: {"comentarios": new_comment }}, {new: true}, (err, producto)->
            if err then res.status(500).send( err.message)
            console.log producto.comentarios
            res.status(200).json({comentario: new_comment})


###
router.route '/'
    # PRODUCT CREATION
    .post user.isAuthenticated, (req, res, next) -> 

        console.log req.body 

        new_product = {
            nombre      : req.body.name
            descripcion : req.body.description
            recomendado : req.body.recomended
            norecomendado: req.body.notrecomended
            etiquetas   : req.body.tags.split(',') 
            tipo        : req.body.tipo 
        }

        producto.findOneAndUpdate( {nombre: req.body.name} , new_product, {new: true, upsert: true}, (err, product)->
            if err 
                console.log err
                res.status(500).send( err.message)

            console.log product
            res.redirect 'product/edit/' + product._id
        )


#     .post user.isAdmin, (req,res,next)->
#     # EDIT PRODUCT         
#         new_product = {
#             nombre      : req.body.name
#             description : req.body.description
#             recomendado : req.body.recomended
#             norecomendado: req.body.notrecomended
#             etiquetas   : req.body.tags.split(',') 
#             tipo        : req.body.tipo 
#         }

#         new_product.findAndUpdate( req.params.slug , new_product, (err, product)->
#             if err 
#                 console.log err
#                 res.status(500).send( err.message)

#             console.log product

#             res.render 'creation/index',
#                 title   : 'Express'
#                 pageName: 'Creation'
#                 user    : req.user 
#         )

#     .delete user.isAuthenticated, (req,res,next)->

###

module.exports = router
