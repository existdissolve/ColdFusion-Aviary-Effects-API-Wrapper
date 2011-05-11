// set some global variables for remembering some values; hacky, but it works
var renderoptions = "";
var originalimage = "http://cfgloss.com/aviary/images/ostrich.jpg";

/*****************************************************************************
	ShowUploadForm: This function creates an ExtJS window with the upload
					form inside
*****************************************************************************/
function ShowUploadForm() {
	var win = new Ext.Window({
		title: 		"Choose an image to upload",
		width:		300,
		height:		110,
		contentEl: 	"upload-hidden",
		padding:	10,
		frame:		true,
		closeAction:"hide",
		autoDestroy:false,
		modal:true,
		fbar: [
			{xtype:"spacer"},
			{
				text: "Upload",
				handler: SaveFile
			}
		]
	}).show(this);
}
/*****************************************************************************
	SaveFile: Posts selected image for upload via AJAX
*****************************************************************************/
function SaveFile() {
	// make sure a file was selected for upload
	if(document.getElementById("file").value=="") {
		Ext.Msg.alert("Stop","Hey, choose a file please!");
		return false;
	}
	// make the ajax request
	Ext.Ajax.request({
		url:		"com/aviary.cfc",
		form:		"upload-form",
		isUpload:	true,
		method: 	"POST",
		params:		{field:"file",method:"savefile",returnformat:"json"},
		success: 	UploadFile
	});
	Ext.WindowMgr.hideAll();
	Ext.Msg.wait("Your file is being uploaded...","Working");
}
/*****************************************************************************
	UploadFile: When a file is successfully uploaded, UploadFile is invoked, 
				and proceeds to trigger the Aviary upload() api method
	ARGUMENTS: 	req (obj, required): the response object from SaveFile
				opts(obj, required): object containing params of request
*****************************************************************************/
function UploadFile(req,opts) {
	var file = Ext.decode(req.responseText);
	Ext.Ajax.request({
		url:		"handler.cfm",
		method: 	"POST",
		params:		{file:file,method:"upload"},
		success: 	function(req){
			var img = req.responseText;
			originalimage = img;
			RefreshImage(img);
			Ext.WindowMgr.hideAll();
		}
	});
}
/*****************************************************************************
	GetRenderOptions: Simple...takes the id of a filter, and fires off
					  renderoptions() api method via ajax
	ARGUMENTS: 	filter (int, required): the filter for which to get rendering
										options
*****************************************************************************/
function GetRenderOptions(filter) {
	var args = {
		backgroundcolor: "0xFF000000",
		format: "jpg",
		quality: 100,
		scale: 1,
		filepath: originalimage,
		filterid: 24,
		cols: 3,
		rows: 3,
		cellwidth: 128,
		cellheight: 128,
		calltype: "filteruse",
		filterid: filter,
		method: "renderoptions",
		returnformat: "json"
	};
	Ext.Msg.wait("Getting filter grid...","Please wait");
	Ext.Ajax.request({
		url:		"handler.cfm",
		method: 	"POST",
		params:		args,
		success: 	RenderOptions
	});
}
/*****************************************************************************
	RenderOptions: When GetRenderOptions() completes, this function is fired
				   to refresh the "grid" display of possible render options	
	ARGUMENTS: 	req (obj, required): the response object from GetRenderOptions
				opts(obj, required): object containing params of request
*****************************************************************************/
function RenderOptions(req,opts) {
	var renders = Ext.decode(req.responseText);
	var grid = Ext.get("gridwrapper");
	grid.dom.style.backgroundImage = "url("+renders.image+")";
	grid.removeClass("x-hidden");
	renderoptions = renders.renders;
	Ext.WindowMgr.hideAll();
}
/*****************************************************************************
	ApplyOptions: Takes user render option selection, and fires render() api
				  method via ajax
	ARGUMENTS: 	opt (int, required): the quadrant of the grid which was chosen
*****************************************************************************/
function ApplyOptions(opt) {
	var opts = renderoptions[opt];
	args = {
		backgroundcolor: "0xFF000000",
		format: "jpg",
		quality: 100,
		scale: 1,
		filepath: originalimage,
		filterid: 24,
		cols: 0,
		rows: 0,
		cellwidth: 0,
		cellheight: 0,
		calltype: "filteruse",
		filterid: Ext.getCmp("filterselect").getValue(),
		method: "render",
		renderparameters: Ext.encode(opts),
		returnformat: "json"
	};
	Ext.Msg.wait("Filter is being applied...","A few more seconds");
	Ext.Ajax.request({
		url:		"handler.cfm",
		method: 	"POST",
		params:		args,
		success: 	function(req) {
			RefreshImage(req.responseText);
			Ext.WindowMgr.hideAll();
		}
	});
}
/*****************************************************************************
	RefreshImage: Handles updating the src of the main image
	ARGUMENTS: 	img (string, required): the path of the new image
*****************************************************************************/
function RefreshImage(img) {
	var image = Ext.getDom("main-image");
	image.src = img;
}
// when ExtJS is ready, convert filter select box to ExtJS select box (looks nicer, IMO)
Ext.onReady(function() {
	var converted = new Ext.form.ComboBox({
		triggerAction: 'all',
		transform:'filterlistselect',
		width:270,
		mode: "local",
		id: "filterselect",
		forceSelection:true,
		listeners: {
			// setup listener on the "select" event to fire off GetRenderOptions()
			select: function(combo,record,index) {
				GetRenderOptions(record.data.value);
			}
		}
	});
});