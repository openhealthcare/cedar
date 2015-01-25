var app = angular.module('cedar', ['angularTreeview', 'ui.ace', 'ui.bootstrap']);

app.controller("NewRuleCtrl", function( $scope, $http, $modalInstance ) {

    $scope.editing = {}
    $scope.$modalInstance = $modalInstance;

    $scope.createNewRule = function() {

        $http.post("/api/v0.1/rules/", {rule: $scope.editing.name, path: ""}).then(
            function(response) {
                if (! response.data.success) {
                    alert("Warn that the name is already in use");
                } else {
                    $modalInstance.close(response.data);
                }

        });

    };

});

app.controller('EditorCtrl', function($scope, $http, $modal){

    $scope.current = null;
    $scope.treedata = [];


    $http.get('/api/v0.1/rules/').then(function(response){
        $scope.loadTreeData(response.data);
    });


    $scope.loadTreeData = function(data) {
        var treeview = [];
        console.log(data);
        var dirs = _.keys(data);
        _.each(dirs, function(dirname){
            var dir = {
                label: dirname,
                id: dirname,
                children: _.map(data[dirname], function(behaviourfile){

                    return {
                        label : behaviourfile,
                        id : dirname + "/" + behaviourfile,
                        children: []
                    }
                })
            };
            treeview.push(dir);
        });

        $scope.treedata = treeview;
    };

    $scope.add_to_tree = function(folder, filename) {
        var parent = _.find($scope.treedata, function(cell){
            return cell.label == folder;
        });
        var newObj = {
            label : filename,
            id : folder + "/" + filename,
            children: []
        };
        parent.children.push(newObj);
        parent.children = _.sortBy(parent.children, function(node){ return node.label });
        return newObj;
    }

    $scope.new_rule = function(){
        $modal.open({
            controller: "NewRuleCtrl",
            templateUrl: "new_rule_popup",
        }).result.then(function(obj){
            var newObj = $scope.add_to_tree(obj.folder, obj.name);

            // select and load....
            $scope.behaviours.currentNode = newObj;
        });
    };


    $scope.save_contents = function(){
        $http.post('/api/v0.1/rules/contents/' + $scope.current,
                   {contents: $scope._session.getValue()}).then(function(response){
            console.log(response);
        });
    };

    $scope.get_contents = function(path){
    	$http.get('/api/v0.1/rules/contents/' + path).then(function(response){
    	    console.log(response);
    	    $scope._session.setValue(response.data);
    	});
    };

    $scope.aceLoaded = function(_editor){
    	$scope._session = _editor.getSession();
    	$scope._renderer = _editor.renderer;
    };

    $scope.$watch('behaviours.currentNode', function(selected, old){
    	console.log('node selected: ');
    	console.log(selected);
    	if(selected){
            $scope.current = selected.id;
    	    $scope.get_contents(selected.id);
    	}
    });

});


