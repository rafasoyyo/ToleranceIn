mongoose = require 'mongoose'
Schema   = mongoose.Schema
comentarioSchema = require './commentModel'

afeccionSchema = new Schema({
                            # index     : { unique : true }
                            clase       : { type : "string", default: "afeccion" }
                            nombre      : { type : "string", unique : true, required: true}
                            descripcion : { type : "string" }
                            sintomas    : { type : "string" }
                            enlace      : { type : "string" }
                            organismo   : { type : "string" }
                            tipo        : { type : "string" }
                            image       : { type : "string" }
                            validado    : { type : "boolean", default: false}
                            visitas     : { type : "number" , min: 0        }
                            revisor     : { type : Schema.ObjectId, ref: 'user'}
                            autor       : { type : Schema.ObjectId, ref: 'user', default: '57042cdb9302bc86384b3f57'}
                            comentarios : [ comentarioSchema ]
                }, {timestamps: true})


afeccionModel = mongoose.model('afeccion', afeccionSchema)

module.exports = afeccionModel