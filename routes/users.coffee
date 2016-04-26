express  = require 'express'
router   = express.Router()
colors   = require 'colors'
# async    = require 'async'
# passport = require 'passport'

user  = require '../models/userModel'
lugar = require '../models/lugarModel'
afeccion = require '../models/afeccionModel'
producto = require '../models/productoModel'
finder   = require '../models/finder'

files = require '../utils/files'


# PÁGINA CON TODOS LOS PRODUCTOS DEL USUARIO
router.route '/:username/all'
    .get user.isLogged, (req, res, next)-> 
        finder.find_user_items req.user._id, (err, user_items)->
            if err 
                console.log err
                res.status(400).json({error: err})

            res.render 'profile/items',
                title   : 'Items - ToleranceIn'
                pageName: 'Items'
                user    : req.user
                items   : user_items


# PÁGINA CON TODOS LOS FAVORITOS DEL USUARIO
router.route '/:username/favorites'
    .get user.isLogged, (req, res, next)-> 
        finder.find_user_favs req.user._id, (err, user_favs)->
            if err 
                console.log err
                res.status(400).json({error: err})

            console.log user_favs
            res.render 'profile/items',
                title   : 'Favoritos - ToleranceIn'
                pageName: 'Favoritos'
                user    : req.user
                items   : user_favs


# PÁGINA CON TODOS LOS LUGARES DEL USUARIO
router.route '/:username/places'
    .get user.isLogged, (req, res, next)->         
        # opts = [ { path: req.user,    options: { limit: 100 , sort: {'visitas': 1}} } ]
        user.findById(req.user._id).populate('lugares').exec (err, user_products)->
                if err 
                    console.log err
                    return res.status(400).json({error: err})

                console.log req.user
                console.log user_products.lugares
                res.render 'profile/items',
                    title   : 'Lugares - ToleranceIn'
                    pageName: 'Lugares'
                    user    : req.user
                    items   : user_products.lugares


# PÁGINA CON TODOS LOS PRODUCTOS DEL USUARIO
router.route '/:username/products'
    .get user.isLogged, (req, res, next)->         
        # opts = [ { path: req.user,    options: { limit: 100 , sort: {'visitas': 1}} } ]
        user.findById(req.user._id).populate('productos').exec (err, user_products)->
                if err 
                    console.log err
                    return res.status(400).json({error: err})

                console.log req.user
                console.log user_products.productos
                res.render 'profile/items',
                    title   : 'Productos - ToleranceIn'
                    pageName: 'Productos'
                    user    : req.user
                    items   : user_products.productos


# PÁGINA CON FORMULARIO DE PERFIL DEL USUARIO
router.route '/:username/profile'

    .get user.isLogged, (req, res, next)-> 
        res.render 'profile/perfil',
            title   : 'Perfil - ToleranceIn'
            pageName: 'Perfil'
            user    : req.user
        
        
    .post user.isLogged, files.saveFile('./public/images/users', 'displayImage'), (req, res, next) ->

                user.findOneAndUpdate(  {username: req.user.username}
                                        { $set: {           
                                                    nombre      : req.body.nombre
                                                    apellidos   : req.body.apellidos
                                                    ciudad      : req.body.ciudad
                                                    intereses   : req.body.alergias
                                                    image       : if req.file and req.file.path then req.file.path else req.user.image
                                                    # intereses   : req.body.intereses
                                                }
                                        }
                                        { new : true }
                                        (err, resp)->
                                            if err 
                                                console.log err 
                                                return res.status(400).send('Cannot save user')
                                            # console.log resp
                                            res.render 'profile/perfil',
                                                title   : 'Perfil - ToleranceIn'
                                                pageName: 'Perfil'
                                                user    : resp
                                    )


# GUARDAR FAV
router.route '/:username/save_fav'

    .post user.isLogged, (req, res, next) ->
        switch req.body.clase
            when 'producto' 
                if req.user.productoFAV.indexOf(req.body.item) is -1
                    update = {$push: { productoFAV: req.body.item } } 
                    option = 'added'
                else 
                    update = {$pull: { productoFAV: req.body.item } } 
                    option = 'removed'


        user.findByIdAndUpdate( req.user._id, update, (err, updated_user)->
            if err 
                console.log err
                res.status(400).json({error: err})
            res.status(200).json({user: updated_user, option: option })
        )





module.exports = router
