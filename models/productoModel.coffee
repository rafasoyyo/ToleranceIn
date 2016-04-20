mongoose = require 'mongoose'
Schema   = mongoose.Schema
comentarioSchema = require './commentModel'

productoSchema = new Schema({
                            # index     : { unique : true }
                            clase       : { type : "string", default: "producto" }
                            nombre      : { type : "string", unique : true, required: true}
                            descripcion : { type : "string" }
                            tipo        : { type : "string" }
                            image       : { type : "string" }
                            recomendado : { type : "object" }
                            norecomendado:{ type : "object" }
                            etiquetas   : { type : "array"  , trim: true    }
                            validado    : { type : "boolean", default: false}
                            visitas     : { type : "number" , min: 0        }
                            lugar       : { type : Schema.ObjectId, ref: 'lugar' }
                            revisor     : { type : Schema.ObjectId, ref: 'user'  }
                            autor       : { type : Schema.ObjectId, ref: 'user', default: "57042cdb9302bc86384b3f57" }
                            comentarios : [ comentarioSchema ]
                }, {timestamps: true})


productoSchema.post 'init', (result)->
    if result.image and result.image.match('public') isnt null
        result.image = result.image.split('public')[1]


productoModel = mongoose.model('producto', productoSchema)

module.exports = productoModel

productoModel.filter = (req, res, next)->
    productoModel.find({nombre: req.body.search}, (err, result)->
                if err then req.producto = {err : err, result: null}
                else req.producto = {err: null, result: result}
                next()
            )

productoModel.verified = (req, res, next)->
    productoModel.find({ validado : true }, (err, result)->
                if err then req.producto = {err : err, result: null}
                else req.producto = {err: null, result: result}
                next()
            )

productoModel.All = (req, res, next)->
    productoModel.find((err, result)->
                if err then req.producto = {err : err, result: null}
                else req.producto = {err: null, result: result}
                next()
            )