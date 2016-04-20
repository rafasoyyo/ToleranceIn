
###
# Home controller
# @namespace Angular.Controller
# @module home-Ctrl
###

tolerantApp.controller('home-Ctrl', ['$scope', '$items', ($scope, $items)->
    ###
    # Description
    # @memberOf home-Ctrl
    # @method $scope.get_all
    # @param algo
    # @param algo2
    # @return algo2
    # @returnprop algo2
    ###
    $scope.get_all = ->
        $items.get_all().then(
                                (res)-> 
                                        console.log res
                                        $scope.all = res.all
                                        $scope.productos  = res.productos
                                        $scope.lugares    = res.lugares
                                        $scope.afecciones = res.afecciones
                            ,
                                (err)-> console.error err
                            )
    $scope.get_all()

])