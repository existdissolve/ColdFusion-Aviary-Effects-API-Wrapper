<cfscript>
	Aviary = new com.aviary(api_key="myapikey",secret="myapisecret");
	filterlist = Aviary.getfilters();
	filters = Aviary.formatfilters(filterlist);
</cfscript>
<!DOCTYPE html>
<html>
	<head>
		<title>ColdFusion Aviary API Wrapper</title>
		<!---including stupid hack for IE9's missing implementation of createContextualFragment, which breaks ExtJS--->
		<script>
			if ((typeof Range !== "undefined") && !Range.prototype.createContextualFragment){
				Range.prototype.createContextualFragment = function(html) {
					var frag = document.createDocumentFragment(), 
					div = document.createElement("div");
					frag.appendChild(div);
					div.outerHTML = html;
					return frag;
				};
			}
		</script>
		<script src="http://extjs.cachefly.net/ext-3.3.1/adapter/ext/ext-base.js"></script> 
		<script src="http://extjs.cachefly.net/ext-3.3.1/ext-all.js"></script>
		<link href="http://extjs.cachefly.net/ext-3.3.1/resources/css/ext-all.css" type="text/css" rel="stylesheet" />
		<link href="http://extjs.cachefly.net/ext-3.3.1/resources/css/xtheme-gray.css" type="text/css" rel="stylesheet" />
		<cfif islocalhost(getlocalhostip())>
			<script src="js/AviaryCF.js"></script>  
			<link href="css/style.css" type="text/css" rel="stylesheet" />
		<cfelse>
			<script src="js/min_AviaryCF.js"></script>  
			<link href="css/min_style.css" type="text/css" rel="stylesheet" />
		</cfif>
	</head>
	<body>
		<div class="header">
			CF+Aviary Effects
		</div>
		<!--begin: main content div-->
		<div id="main-content">
			<!--begin: left-content div-->
			<div id="left-content">
				<img src="images/ostrich.jpg" id="main-image"  />
				<!--width="520" height="480"-->
			</div>
			<!--end: left-content div-->
			<!--begin: right-content div-->
			<div id="right-content">
				<fieldset>
					<legend>Step 1: Upload Image</legend>
					<div class="genericwrapper">
						<div class="uploadbutton" onClick="ShowUploadForm()">CHOOSE...</div>
					</div>
				</fieldset>
				<fieldset>
					<legend>Step 2: Select a Filter</legend>
					<div class="genericwrapper">
						<select name="filter" id="filterlistselect" onChange="GetRenderOptions(this.value)">
							<cfoutput>
							<cfloop from="1" to="#arraylen(filters)#" index="i">
							<option value="#filters[i].id#" title="#filters[i].description#">#filters[i].label#</option>
							</cfloop>
							</cfoutput>
						</select>
					</div>
				</fieldset>
				<fieldset>
					<legend>Step 3: Apply Options</legend>
					<div class="genericwrapper">
						<div class="gridwrapper x-hidden" id="gridwrapper">
							<div id="grid0" onClick="ApplyOptions(0);" title="Click me to apply super-sweet effects!">&nbsp;</div>
							<div id="grid1" onClick="ApplyOptions(1);" title="Click me to apply super-sweet effects!">&nbsp;</div>
							<div id="grid2" onClick="ApplyOptions(2);" title="Click me to apply super-sweet effects!" class="unpadded">&nbsp;</div>
							<div id="grid3" onClick="ApplyOptions(3);" title="Click me to apply super-sweet effects!">&nbsp;</div>
							<div id="grid4" onClick="ApplyOptions(4);" title="Click me to apply super-sweet effects!">&nbsp;</div>
							<div id="grid5" onClick="ApplyOptions(5);" title="Click me to apply super-sweet effects!" class="unpadded">&nbsp;</div>
							<div id="grid6" onClick="ApplyOptions(6);" title="Click me to apply super-sweet effects!">&nbsp;</div>
							<div id="grid7" onClick="ApplyOptions(7);" title="Click me to apply super-sweet effects!">&nbsp;</div>
							<div id="grid8" onClick="ApplyOptions(8);" title="Click me to apply super-sweet effects!" class="unpadded">&nbsp;</div>
						</div>
					</div>
				</fieldset>
			</div>
			<!--end: right-content div-->
		</div>
		<!--end: main content div-->
		<!--begin: hidden form...gets shown in Ext window-->
		<div id="upload-hidden" class="x-hidden">
			<form name="upload-form" id="upload-form" name="post" action="index.cfm">
				<input type="file" name="file" id="file" />
			</form>
		</div>
		<!--end: hidden form...gets shown in Ext window-->
	</body>
</html>
