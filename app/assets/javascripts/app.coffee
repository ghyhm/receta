receta = angular.module('receta',[
  'templates',
  'ngRoute',
  'ngResource',
  'controllers',
])

receta.config([ '$routeProvider',
  ($routeProvider)->
    $routeProvider
      .when('/',
        templateUrl: "index.html"
        controller: 'RecipesController'
      ).when('/recipes/new',
        templateUrl: "form.html"
        controller: 'RecipeController'
      ).when('/recipes/:recipeId',
        templateUrl: "show.html"
        controller: 'RecipeController'
      ).when('/recipes/:recipeId/edit',
        templateUrl: "form.html"
        controller: 'RecipeController'
      )
])

controllers = angular.module('controllers',[])
