mongoose = require 'mongoose'
Schema   = mongoose.Schema

comentarioSchema = new Schema({
                                autor  : { type : Schema.ObjectId, ref: 'user', default: "57042cdb9302bc86384b3f57" }
                                mensaje: { type : String }
                                created: { type : Date   }
                    })

module.exports = comentarioSchema