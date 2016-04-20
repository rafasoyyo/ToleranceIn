express  = require 'express'
router   = express.Router()
colors   = require 'colors'
# async    = require 'async'
# passport = require 'passport'

user  = require '../models/userModel'
lugar = require '../models/lugarModel'
afeccion = require '../models/afeccionModel'
producto = require '../models/productoModel'

files = require '../utils/files'


# PÁGINA CON TODOS LOS PRODUCTOS DEL USUARIO
router.get '/:username/all', user.isAuthenticated, (req, res, next)->
    res.render 'profile/items',
        title   : 'Express'
        pageName: 'Items'
        user    : req.user


# PÁGINA CON FORMULARIO DE PERFIL DEL USUARIO
router.route '/:username/profile'

    .get user.isLogged, (req, res, next)-> 
        res.render 'profile/perfil',
            title   : 'Perfil - ToleranceIn'
            pageName: 'Perfil'
            user    : req.user
        
    .post user.isLogged, files.saveFile('./public/images/users').single('displayImage'), (req, res, next) ->

                # console.log req.body
                # console.log req.file

                user.findOneAndUpdate(  {username: req.user.username}
                                        { $set: {           
                                                    nombre      : req.body.nombre
                                                    apellidos   : req.body.apellidos
                                                    ciudad      : req.body.ciudad
                                                    image       : if req.file and req.file.path then req.file.path else req.user.image
                                                    # intereses   : req.body.intereses
                                                }
                                        }
                                        { new : true }
                                        (err, resp)->
                                            if err 
                                                console.log err 
                                                if err then res.status(400).send('Cannot save user')
                                            console.log resp
                                            res.render 'profile/perfil',
                                                title   : 'Perfil - ToleranceIn'
                                                pageName: 'Perfil'
                                                user    : resp
                                    )



module.exports = router
