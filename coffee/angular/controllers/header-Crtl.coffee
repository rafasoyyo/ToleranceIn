
###
# Header controller
# @memberOf Angular
# @namespace Controller
# @module header-Ctrl
# @see rafa
###

tolerantApp.controller('header-Ctrl', ['$scope', '$uibModal', ($scope, $uibModal)->

	###
	# Open login and register modal
	# @memberOf header-Ctrl
	# @method $scope.loginModal
	# @param none
	# @return none
	###
	$scope.loginModal = ->

		modalInstance = $uibModal.open({
			animation: true
			templateUrl: '/templates/loginModal.html'
			controller: 'loginModal-Ctrl'
			windowClass : 'login-modal'
			size: 'md'
		})

])