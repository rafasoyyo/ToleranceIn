var tolerantApp;

tolerantApp = angular.module('tolerantApp', ['ngResource', 'ngSanitize', 'ngAnimate', 'ui.bootstrap']);

tolerantApp.controller('header-Ctrl', [
  '$scope', '$uibModal', function($scope, $uibModal) {
    return $scope.loginModal = function() {
      var modalInstance;
      return modalInstance = $uibModal.open({
        animation: true,
        templateUrl: 'templates/loginModal.html',
        controller: 'loginModal-Ctrl',
        windowClass: 'login-modal',
        size: 'md'
      });
    };
  }
]);

tolerantApp.controller('loginModal-Ctrl', [
  '$scope', '$uibModalInstance', '$User', function($scope, $uibModalInstance, $User) {
    $scope.login_submit = function() {
      if ($scope.login_form.$valid) {
        console.log($scope.login);
        return $http.post('/users/login', $scope.login).then(function(res) {
          console.log(res);
          return location.reload();
        }, function(err) {
          return console.error(err);
        });
      }
    };
    return $scope.register_submit = function() {
      if ($scope.register_form.$valid) {
        console.log($scope.register);
        return $User.login().then(function(res) {
          console.log(res);
          return location.reload();
        }, function(err) {
          return console.error(err);
        });
      }
    };
  }
]);

tolerantApp.factory('$User', ["$resource", function($resource) {
  return {
    login: function(data) {
      return $resource('/users/register', data).post().$promise;
    }
  };
}]);
