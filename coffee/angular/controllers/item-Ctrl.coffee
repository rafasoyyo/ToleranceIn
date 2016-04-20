
tolerantApp.controller('item-Ctrl', ['$scope', '$filter', '$timeout', '$items', ($scope, $filter, $timeout, $items)->

	# console.log $scope
	
	iteartor = 5
	$scope.limited = iteartor
	$scope.see_comment = ->
		$scope.limited = $scope.limited + iteartor
	
	$scope.get_comment = ->
		if $scope.clase is 'product'
			$items.product_comment_get($scope.ident).then( 
														(res)-> $scope.comments = $filter('orderBy')(res.comentarios, 'created', true)
													,
														(error)-> console.error error
													)
	
	$scope.post_comment = ->
		if $scope.clase is 'product'
			$items.product_comment_post($scope.comment).then(
								(res)-> 
										console.log res
										$scope.product_comment.$setPristine()
										$scope.comment = null
										$scope.get_comment()
							,
								(err)-> console.error err
							)

	$timeout( $scope.get_comment ,1)

])