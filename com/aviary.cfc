component displayname="Aviary Effects API Wrapper" output="false" accessors="true" {
	property  	name="api_key" type="string" getter="true" setter="true" hint="The api key for our application";
	property 	name="secret" type="string" getter="true" setter="true" hint="Application secret key for hashing authentication signature";
	property 	name="hardware_version" type="numeric" getter="true" setter="true" default="1.0" hint="Hardware version for API";
	property 	name="software_version" type="string" getter="true" setter="true" default="ColdFusion" hint="Software utilizing API";
	property 	name="app_version" type="numeric" getter="true" setter="true" default="1.0" hint="Version of Application";
	property 	name="platform" type="string" getter="true" setter="true" default="web" hint="Platform accessing API";
	property 	name="version" type="numeric" getter="true" setter="true" default="0.2" hint="Version of API";		
	property 	name="baseparams"type="struct"getter="true"setter="true"hint="Structure for holding frequently used params used in every api request";
	property 	name="endpoints"type="struct"getter="true"setter="true"hint="Structure for holding frequently used params used in every api request";
	
	/**
	* @hint Returns initialized instance of component.
	* @description Returns initialized instance of component.
	* @output false
	**/		
	public any function init
		(
			required string api_key,
			required string secret,
			numeric hardware_version = 1.0,
			string software_version = "ColdFusion",
			string platform = "web",
			numeric version = 0.2,
			numeric app_version = 1.0
		) 
	{
		this.setapi_key(arguments.api_key);
		this.setsecret(arguments.secret);
		
		this.setapp_version(arguments.app_version);
		this.sethardware_version(arguments.hardware_version);
		this.setsoftware_version(arguments.software_version);
		this.setplatform(arguments.platform);
		this.setversion(arguments.version);
		
		this.setbaseparams({
			"api_key" 			= this.getapi_key(),
			"hardware_version"	= this.gethardware_version(),
			"software_version"	= this.getsoftware_version(),
			"app_version"		= this.getapp_version(),
			"platform"			= this.getplatform(),
			"version"			= this.getversion()
		});
		this.setendpoints({
			"base" 		= "http://cartonapi.aviary.com/services/",
			"getfilters"= "filter/getfilters",
			"gettime"	= "util/getTime",
			"upload"	= "ostrich/upload",
			"render"	= "ostrich/render"
		});
		return (this);
	}
	
	/**
	* @hint Returns Aviary API server time (Unix).
	* @description Returns timestamp used by Aviary's server. Not terribly useful, however, since it requires a matching timestamp to retrieve in the first place...
	* @output false
	**/
	public string function gettime() {
		signature = createsig();
		baseparams= this.getbaseparams();
		endpoints = this.getendpoints();
		
		req = new http();
		req.setmethod("POST");
		req.seturl(endpoints.base & endpoints.gettime);
		
		req.addparam(name="api_key",value=baseparams.api_key,type="formfield");
		req.addparam(name="platform",value=baseparams.platform,type="formfield");
		req.addparam(name="hardware_version",value=baseparams.hardware_version,type="formfield");
		req.addparam(name="software_version",value=baseparams.software_version,type="formfield");
		req.addparam(name="app_version",value=baseparams.app_version,type="formfield");
		req.addparam(name="ts",value=baseparams.ts,type="formfield");
		req.addparam(name="version",value=baseparams.version,type="formfield");
		req.addparam(name="api_sig",value=signature,type="formfield");
		
		result = req.send().getprefix();
		return result.filecontent;
	}
	
	/**
	* @hint Returns a list of valid filters.
	* @description Returns a list of valid filters. The values in these returned filters can be used in renderoptions
	* @output false
	**/
	public string function getfilters(numeric verbose = 1) {
		signature = createsig(extraparams=arguments);
		baseparams= this.getbaseparams();
		endpoints = this.getendpoints();
		
		req = new http();
		req.setmethod("POST");
		req.seturl(endpoints.base & endpoints.getfilters);
		
		req.addparam(name="api_key",value=baseparams.api_key,type="formfield");
		req.addparam(name="platform",value=baseparams.platform,type="formfield");
		req.addparam(name="hardware_version",value=baseparams.hardware_version,type="formfield");
		req.addparam(name="software_version",value=baseparams.software_version,type="formfield");
		req.addparam(name="app_version",value=baseparams.app_version,type="formfield");
		req.addparam(name="ts",value=baseparams.ts,type="formfield");
		req.addparam(name="version",value=baseparams.version,type="formfield");
		req.addparam(name="verbose",value=arguments.verbose,type="formfield");
		req.addparam(name="api_sig",value=signature,type="formfield");
		
		result = req.send().getprefix();
		return result.filecontent;
	}
	
	/**
	* @hint Uploads file to ColdFusion server.
	* @description Uploads file to ColdFusion server, in case you want to store it before passing it off Aviary
	* @output false
	**/
	remote string function savefile(required string field) {
		savedfile = "";
		uploadfile = fileupload(gettempdirectory(),arguments.field,"image/*","overwrite");
		if(uploadfile.filewassaved) {
			savedfile = uploadfile.serverdirectory & "/" & uploadfile.serverFile;
		}
		return savedfile;
	}
	
	/**
	* @hint Uploads file to Aviary's servers.
	* @description Uploads file to Aviary's servers and returns an XML dump containing original filename, Aviary's custom name, etc.
	* @output false
	**/	
	public string function upload(required string file,numeric verbose = 1) {
		extraparams = {verbose=arguments.verbose};
		signature = createsig(extraparams);
		baseparams= this.getbaseparams();
		endpoints = this.getendpoints();
		
		req = new http();
		req.setmethod("POST");
		req.setmultipart(true);
		req.seturl(endpoints.base & endpoints.upload);
		
		req.addparam(name="api_key",value=baseparams.api_key,type="formfield");
		req.addparam(name="platform",value=baseparams.platform,type="formfield");
		req.addparam(name="hardware_version",value=baseparams.hardware_version,type="formfield");
		req.addparam(name="software_version",value=baseparams.software_version,type="formfield");
		req.addparam(name="app_version",value=baseparams.app_version,type="formfield");
		req.addparam(name="ts",value=baseparams.ts,type="formfield");
		req.addparam(name="version",value=baseparams.version,type="formfield");
		req.addparam(name="verbose",value=arguments.verbose,type="formfield");
		req.addparam(name="api_sig",value=signature,type="formfield");
		req.addparam(name="file",file=arguments.file,type="file");
		
		result = req.send().getprefix();
		return result.filecontent;
	}
	
	/**
	* @hint Sets configuration options on file.
	* @description Sets configuration options on file
	* @output false
	**/
	public string function renderoptions
		(
			required string backgroundcolor,
			required string format,
			required numeric quality,
			required numeric scale,
			required string filepath,
			required numeric filterid,
			required numeric cols,
			required numeric rows,
			required numeric cellwidth,
			required numeric cellheight,
			required string calltype
		)
	{	
		signature = createsig(arguments);
		baseparams= this.getbaseparams();
		endpoints = this.getendpoints();
		
		req = new http();
		req.setmethod("POST");
		req.seturl(endpoints.base & endpoints.render);
		
		req.addparam(name="api_key",value=baseparams.api_key,type="formfield");
		req.addparam(name="platform",value=baseparams.platform,type="formfield");
		req.addparam(name="hardware_version",value=baseparams.hardware_version,type="formfield");
		req.addparam(name="software_version",value=baseparams.software_version,type="formfield");
		req.addparam(name="app_version",value=baseparams.app_version,type="formfield");
		req.addparam(name="ts",value=baseparams.ts,type="formfield");
		req.addparam(name="version",value=baseparams.version,type="formfield");
		
		req.addparam(name="backgroundcolor",value=arguments.backgroundcolor,type="formfield");
		req.addparam(name="format",value=arguments.format,type="formfield");
		req.addparam(name="quality",value=arguments.quality,type="formfield");
		req.addparam(name="scale",value=arguments.scale,type="formfield");
		req.addparam(name="filepath",value=arguments.filepath,type="formfield");
		req.addparam(name="filterid",value=arguments.filterid,type="formfield");
		req.addparam(name="cols",value=arguments.cols,type="formfield");
		req.addparam(name="rows",value=arguments.rows,type="formfield");
		req.addparam(name="cellwidth",value=arguments.cellwidth,type="formfield");
		req.addparam(name="cellheight",value=arguments.cellheight,type="formfield");
		req.addparam(name="calltype",value=arguments.calltype,type="formfield");
		
		req.addparam(name="api_sig",value=signature,type="formfield");
		
		result = req.send().getprefix();
		return result.filecontent;
	}
	
	/**
	* @hint Applies configuration options on file.
	* @description Applies configuration options on file; can take result from renderoptions and apply to image for consistent, predictable results
	* @output false
	**/
	public string function render
		(
			required string backgroundcolor,
			required string format,
			required numeric quality,
			required numeric scale,
			required string filepath,
			required numeric filterid,
			required numeric cols,
			required numeric rows,
			required numeric cellwidth,
			required numeric cellheight,
			required string calltype,
			array renderparameters = arraynew(1)
		)
	{	
		arguments.renderparameters = trim(createrenderparameterxml(arguments.renderparameters));
		signature = createsig(arguments);
		baseparams= this.getbaseparams();
		endpoints = this.getendpoints();
		
		req = new http();
		req.setmethod("POST");
		req.seturl(endpoints.base & endpoints.render);
		
		req.addparam(name="api_key",value=baseparams.api_key,type="formfield");
		req.addparam(name="platform",value=baseparams.platform,type="formfield");
		req.addparam(name="hardware_version",value=baseparams.hardware_version,type="formfield");
		req.addparam(name="software_version",value=baseparams.software_version,type="formfield");
		req.addparam(name="app_version",value=baseparams.app_version,type="formfield");
		req.addparam(name="ts",value=baseparams.ts,type="formfield");
		req.addparam(name="version",value=baseparams.version,type="formfield");
		
		req.addparam(name="backgroundcolor",value=arguments.backgroundcolor,type="formfield");
		req.addparam(name="format",value=arguments.format,type="formfield");
		req.addparam(name="quality",value=arguments.quality,type="formfield");
		req.addparam(name="scale",value=arguments.scale,type="formfield");
		req.addparam(name="filepath",value=arguments.filepath,type="formfield");
		req.addparam(name="filterid",value=arguments.filterid,type="formfield");
		req.addparam(name="cols",value=arguments.cols,type="formfield");
		req.addparam(name="rows",value=arguments.rows,type="formfield");
		req.addparam(name="cellwidth",value=arguments.cellwidth,type="formfield");
		req.addparam(name="cellheight",value=arguments.cellheight,type="formfield");
		req.addparam(name="calltype",value=arguments.calltype,type="formfield");
		if(arguments.renderparameters != "") {
			req.addparam(name="renderparameters",value=arguments.renderparameters,type="formfield");
		}
		
		req.addparam(name="api_sig",value=signature,type="formfield");
		
		result = req.send().getprefix();
		return result.filecontent;
	}	
	
	/**
	* @hint Custom formatting method for upload api method.
	* @description This method takes the xml string returned from upload() and returns a CF string of the new image url
	* @output false
	**/
	public string function formatupload(required string str) {
		root = xmlparse(str).response.response.files;
		result = root.xmlchildren[1].getattribute("url");
		return result;
	}
	
	/**
	* @hint Custom formatting method for getfilters api method.
	* @description This method takes the xml string returned from getfilters() and returns a CF array of filter labels and unique ids
	* @output false
	**/
	public array function formatfilters(required string str) {
		filters = [];
		root = xmlparse(str).response.filters;
		for(i=1;i<=arraylen(root.xmlchildren);i++) {
			item = {
				"label" = root.xmlchildren[i].getattribute("label"),
				"id" = root.xmlchildren[i].getattribute("uid"),
				"description" = root.xmlchildren[i].description.xmltext
			};
			arrayappend(filters,item);
		}
		return filters;
	}
	
	/**
	* @hint Custom formatting method for renderoptions api method.
	* @description This method takes the xml string returned from renderoptions() and returns a CF array of renders and parameters
	* @output false
	**/	
	public struct function formatrenderoptions(required string str) {
		root = xmlparse(str).response.ostrichrenderresponse;
		image = root.url.xmltext;
		renders = [];
		renderlist = root.renders.xmlchildren;
		for(i=1;i<=arraylen(renderlist);i++) {
			render = [];
			parameterlist = renderlist[i].xmlchildren[1].xmlchildren;
			for(x=1;x<=arraylen(parameterlist);x++) {
				item = {
					"id" 	= parameterlist[x].getattribute("id"),
					"value"	= parameterlist[x].getattribute("value"),
					"uid"	= parameterlist[x].getattribute("uid")
				};
				arrayappend(render,item);
			}	
			arrayappend(renders,render);
		}
		result = {"image"=image,"renders"=renders};
		return result;
	}
	
	/**
	* @hint Custom formatting method for render api method.
	* @description This method takes the xml string returned from render() and returns the final image url
	* @output false
	**/
	public string function formatrender(required string str) {
		root = xmlparse(str).response.ostrichrenderresponse;
		result = root.url.xmltext;
		return result;
	}
	
	/**
	* @hint Helper function for creating hashed signature.
	* @description This hashing function combines base params required for each request along with method-specific parameters, returns hashed signature
	* @output false
	**/
	private string function createsig(extraparams={}) {
		signature	= this.getsecret();
		baseparams	= this.getbaseparams();
		baseparams.ts = createunixtimestamp();
		structappend(baseparams,arguments.extraparams);
		params = baseparams;
		paramlist = listsort(structkeylist(params),"textnocase");
		for(i=1;i<=listlen(paramlist);i++) {
			if(params[listgetat(paramlist,i)] != "") {
				signature = signature & lcase(listgetat(paramlist,i));
				signature = signature & params[listgetat(paramlist,i)];
			}
		}
		return lcase(hash(signature));
	}
	
	/**
	* @hint Returns Unix-formatted timestamp.
	* @description Returns Unix formatted timestamp that matches format required by Aviary's authentication method
	* @output false
	**/
	private string function createunixtimestamp() {
		time = createobject("java","java.util.Date").init();
		stamp= time.gettime()/1000;
		return ceiling(stamp);
	}
	
	/**
	* @hint Helper to format valid xml string for renderoptions().
	* @description Helper to format valid xml string for renderoptions()
	* @output false
	**/
	private string function createrenderparameterxml(required array renderparameters) {
		getpagecontext().getcfoutput().clearall();
		str = createobject('java','java.lang.StringBuffer').init();
		if(arraylen(arguments.renderparameters)) {
			str.append('<parameters>');
			for(i=1;i<=arraylen(arguments.renderparameters);i++) {
				str.append('<parameter id="#arguments.renderparameters[i].id#" value="#arguments.renderparameters[i].value#" />');	
			}
			str.append("</parameters>");
		}
		return trim(str.tostring());
	}
}