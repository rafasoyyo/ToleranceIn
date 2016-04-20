var tolerantApp;

tolerantApp = angular.module('tolerantApp', ['ngResource', 'ngSanitize', 'ngAnimate', 'ui.bootstrap']);

tolerantApp.controller('body-Ctrl', ['$scope', function($scope) {}]);

tolerantApp.controller('header-Ctrl', [
  '$scope', '$uibModal', function($scope, $uibModal) {
    return $scope.loginModal = function() {
      var modalInstance;
      return modalInstance = $uibModal.open({
        animation: true,
        templateUrl: '/templates/loginModal.html',
        controller: 'loginModal-Ctrl',
        windowClass: 'login-modal',
        size: 'md'
      });
    };
  }
]);

tolerantApp.controller('home-Ctrl', [
  '$scope', '$items', function($scope, $items) {
    $scope.get_all = function() {
      return $items.get_all().then(function(res) {
        console.log(res);
        $scope.all = res.all;
        $scope.productos = res.productos;
        $scope.lugares = res.lugares;
        return $scope.afecciones = res.afecciones;
      }, function(err) {
        return console.error(err);
      });
    };
    return $scope.get_all();
  }
]);

tolerantApp.controller('item-Ctrl', [
  '$scope', '$filter', '$timeout', '$items', function($scope, $filter, $timeout, $items) {
    var iteartor;
    iteartor = 5;
    $scope.limited = iteartor;
    $scope.see_comment = function() {
      return $scope.limited = $scope.limited + iteartor;
    };
    $scope.get_comment = function() {
      if ($scope.clase === 'product') {
        return $items.product_comment_get($scope.ident).then(function(res) {
          return $scope.comments = $filter('orderBy')(res.comentarios, 'created', true);
        }, function(error) {
          return console.error(error);
        });
      }
    };
    $scope.post_comment = function() {
      if ($scope.clase === 'product') {
        return $items.product_comment_post($scope.comment).then(function(res) {
          console.log(res);
          $scope.product_comment.$setPristine();
          $scope.comment = null;
          return $scope.get_comment();
        }, function(err) {
          return console.error(err);
        });
      }
    };
    return $timeout($scope.get_comment, 1);
  }
]);

tolerantApp.controller('loginModal-Ctrl', [
  '$scope', '$uibModalInstance', '$account', function($scope, $uibModalInstance, $account) {
    $scope.login_submit = function() {
      $scope.error_login = false;
      console.log($scope.login);
      if ($scope.login_form.$valid) {
        return $account.login($scope.login).then(function(res) {
          console.log(res);
          return location.reload();
        }, function(err) {
          console.error(err);
          if (err.status === 401) {
            return $scope.error_login = 'Usuario o contraseña incorrectos';
          } else {
            return $scope.error_login = 'Error de acceso';
          }
        });
      }
    };
    $scope.register_submit = function() {
      $scope.error_register = false;
      if ($scope.register_form.$valid) {
        return $account.register($scope.register).then(function(res) {
          console.log(res);
          return location.reload();
        }, function(err) {
          console.error(err);
          if (err.data.id) {
            switch (err.data.id) {
              case 1:
                return $scope.error_register = 'El nombre de usuario es necesario';
              case 2:
                return $scope.error_register = 'Nombre de usuario en uso';
              case 3:
                return $scope.error_register = 'Email en uso';
              default:
                return $scope.error_register = 'Error de acceso';
            }
          } else {
            return $scope.error_register = 'Error de acceso';
          }
        });
      }
    };
    $scope.$watchCollection('register', function(fin, ini) {
      $scope.error_register = false;
      $scope.checkin = {
        status: false,
        value: false
      };
      if (typeof fin !== 'undefined') {
        console.log($scope);
        if (fin.password && fin.repeat) {
          $scope.register_form.register_repeat.$setValidity("unmatch", fin.password === fin.repeat);
        } else {
          $scope.register_form.register_repeat.$setValidity("unmatch", true);
        }
        if ((!fin.nickname) || (typeof ini !== 'undefined' && fin.nickname === ini.nickname)) {
          return false;
        }
        $scope.checkin = {
          status: true,
          value: false
        };
        return $account.available({
          username: fin.nickname
        }).then(function(res) {
          console.log(res);
          return $scope.checkin.value = "<i class=\"fa fa-check txt-green\"></i>\n<span class=\"txt-green txt-sbold small\">Este nombre de usuario está disponible</span>";
        }, function(err) {
          console.error(err);
          return $scope.checkin.value = "<i class=\"fa fa-times txt-red\"></i>\n<span class=\"txt-red txt-sbold small\">Este nombre de usuario ya está en uso</span>";
        });
      }
    });
    return $scope.password_recover = function() {
      if (!$scope.login || !$scope.login.username) {
        $scope.recover_ok = null;
        return $scope.error_login = 'Escribe tu nombre de usuario o tu email';
      }
      return $account.recover({
        username: $scope.login.username
      }).then(function(res) {
        console.log(res);
        $scope.recover_ok = 'Se ha enviado un email con las instrucciones al correo asociado a esta cuenta.';
        return $scope.error_login = null;
      }, function(err) {
        console.error(err);
        if (err.data.id) {
          switch (err.data.id) {
            case 1:
              return $scope.error_login = 'No hay cuentas registradas con estos datos.';
            default:
              return $scope.error_login = 'Error de acceso';
          }
        } else {
          return $scope.error_register = 'Error de acceso';
        }
      });
    };
  }
]);

tolerantApp.factory('$account', [
  '$resource', function($resource) {
    return {
      login: function(data) {
        return $resource('/account/login').save(data).$promise;
      },
      logout: function(data) {
        return $resource('/account/logout').get().$promise;
      },
      register: function(data) {
        return $resource('/account/register').save(data).$promise;
      },
      available: function(data) {
        return $resource('/account/available').save(data).$promise;
      },
      recover: function(data) {
        return $resource('/account/recover').save(data).$promise;
      }
    };
  }
]);

tolerantApp.factory('$items', [
  '$resource', function($resource) {
    return {
      get_all: function(data) {
        return $resource('/all').get().$promise;
      },
      product_comment_get: function(data) {
        return $resource('/product/comment/' + data).get().$promise;
      },
      product_comment_post: function(data) {
        return $resource('/product/comment').save(data).$promise;
      }
    };
  }
]);
