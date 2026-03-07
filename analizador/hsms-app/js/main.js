function init(){
	var menu = require("./../js/menu.js");
	menu.initMenu();

	global.$(global.window.document).ready(function(){
		if(global.gui.App.argv.length > 0){
			editor.loadFile(global.gui.App.argv[0]);
		}
	});
}