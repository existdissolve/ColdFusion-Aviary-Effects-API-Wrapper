<cfscript>
	Aviary = new com.aviary(api_key=application.api_key,secret=application.secret,response_format="json");
	// switch call to api, depending on requested method
	switch(form.method) {
		// upload
		case "upload": 
			result = Aviary.upload(file=form.file);
			writeoutput(result);
			break;
		// renderoptions
		case "renderoptions":
			// setup argument collection
			args = {
				backgroundcolor=form.backgroundcolor,
				format=form.format,
				quality=form.quality,
				scale=form.scale,
				filepath=form.filepath,
				filterid=form.filterid,
				cols=form.cols,
				rows=form.rows,
				cellwidth=form.cellwidth,
				cellheight=form.cellheight,
				calltype=form.calltype
			};
			// make intial api call
			result = Aviary.renderoptions(argumentcollection=args);
			// return serialized version of CF array
			writeoutput(result);
			break;
		// render
		case "render":
			// setup argument collection
			args = {
				backgroundcolor=form.backgroundcolor,
				format=form.format,
				quality=form.quality,
				scale=form.scale,
				filepath=form.filepath,
				filterid=form.filterid,
				cols=form.cols,
				rows=form.rows,
				cellwidth=form.cellwidth,
				cellheight=form.cellheight,
				calltype=form.calltype,
				renderparameters = form.renderparameters
			};
			// make initial api call
			result = Aviary.render(argumentcollection=args);
			// return 
			writeoutput(result);
			break;
		// get filters...maybe someday?
		case "getfilters":
			break;
	}
</cfscript>