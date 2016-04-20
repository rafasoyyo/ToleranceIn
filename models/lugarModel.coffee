mongoose = require 'mongoose'
Schema   = mongoose.Schema
comentarioSchema = require './commentModel'

lugarSchema = new Schema({
                            # index     : { unique : true }
                            clase       : { type : "string", default: "lugar" }
                            nombre      : { type : "string", unique : true, required: true}
                            descripcion : { type : "string" }
                            direccion   : { type : "string" }
                            telefono    : { type : "string" }
                            web         : { type : "string" }
                            especialidad: { type : "string" }
                            tipo        : { type : "string" }
                            image       : { type : "string" }
                            etiquetas   : { type : "array"  , trim: true    }
                            validado    : { type : "boolean", default: false}
                            visitas     : { type : "number" , min: 0        }
                            revisor     : { type : Schema.ObjectId, ref: 'user'}
                            autor       : { type : Schema.ObjectId, ref: 'user', default: '57042cdb9302bc86384b3f57'}
                            comentarios : [ comentarioSchema ]
                }, {timestamps: true})


lugarModel = mongoose.model('lugar', lugarSchema)

module.exports = lugarModel