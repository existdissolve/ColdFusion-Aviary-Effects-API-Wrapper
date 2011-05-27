<cfscript>
	Aviary = new com.aviary(api_key="xxxxx",secret="xxxxx",response_format="xml");
	// switch call to api, depending on requested method
	switch(form.method) {
		// upload
		case "upload": 
			tmpresult = Aviary.upload(file=form.file);
			writeoutput(Aviary.formatupload(tmpresult));
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
			tmpresult = Aviary.renderoptions(argumentcollection=args);
			// call custom formatting method (to parse xml string into CF structure)
			result = Aviary.formatrenderoptions(tmpresult);
			// return serialized version of CF array
			writeoutput(serializejson(result));
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
				renderparameters = deserializejson(form.renderparameters)
			};
			// make initial api call
			tmpresult = Aviary.render(argumentcollection=args);
			// call custom formatting method (to parse xml string into CF object)
			result = Aviary.formatrender(tmpresult);
			// return 
			writeoutput(result);
			break;
		// get filters...maybe someday?
		case "getfilters":
			break;
	}
</cfscript>