
fs = require 'fs'
mkdirp = require 'mkdirp'
multer  = require 'multer'

files = 
    # Create path if not exist
    folderExistOrCreate : (directory, callback)->
        fs.stat(directory, (err, data)->
            if err then mkdirp.sync(directory)
            return callback()
        )

    # Create file on given folder and create folder if not exist
    saveFile : (directory, callback)->
        console.log 'directory:-> ' + directory
        multer({ 
                storage: multer.diskStorage({
                            destination: (req, file, cb)->
                                mkdirp.sync(directory)
                                cb(null, directory)
                            filename: (req, file, cb)->  
                                cb(null, Date.now() + '-' + file.originalname )
                        }) 
            })
        

module.exports = files