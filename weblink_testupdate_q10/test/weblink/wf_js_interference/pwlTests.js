/*------------------------------------------------------------------------
 MODIFICATIONS:

 14-Dec-04 $$1  ALS  Moved from rdweb to the system.
 04-Jan-05 $$2  ALS  Added ProE Command fns to write exception in trail file.
 08-Mar-05 K-03-20 JCN  $$3   Fixed Material data printout  
 28-Oct-06 L-01-19 shajoshi  $$4   Updated forceTrailOOS()  
 31-May-07 L-01-31 JCN  $$5   New exception descriptions
 19-Oct-08 L-03-18 SRV  $$6   Added fileUrl var in open_ function as to
 				support Mozilla browser SPR 1542439
 26-Dec-13 P-20-45 gshmelev $$7 checked 'trident' to recognize IE
 11-Feb-14 P-20-48 gshmelev $$8  added pfcIsChrome
 13-Mar-14  P-20-49  rkumbhare  $$9  Updated for open_.
 13-Jul-15  P-30-12  rkumbhare  $$10  Updated for fix of regfail.
 09-Dec-20  P-80-32  ychavhan   $$11  Fetched and submitting locally.
 08-Oct-24  Q-10-55  aphatak    $$12  Disabled window.* calls
-------------------------------------------------------------------------*/

count =1;
var jlApp;
var win;

function pfcTimeout(funcDelay) {
    setTimeout(funcDelay, 1000);
}

function CloseResults ()
{
        closewin_ ();
}

function pfcIsWindows ()
{
  if (navigator.userAgent.toString().toLowerCase().indexOf("trident") != -1)
  {
    return true;
  }
  else
    return false;
}

function pfcIsChrome ()
{
  var ua = navigator.userAgent.toString().toLowerCase();
  var val = ua.indexOf("chrome/"); // Chrome
  if (val > -1)
  {
    return true;
  }
  else
    return false;
}


function pfcIsMozilla ()
{
    if(pfcIsWindows())
	return false;
    if(pfcIsChrome())
	return false;

    return true;
}

function pfcCreate (className)
{

  if (pfcIsWindows())
    return new ActiveXObject ("pfc."+className);
  else if (pfcIsChrome())
    return pfcCefCreate (className);
  else if (pfcIsMozilla())
  {
    netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
    ret = Components.classes ["@ptc.com/pfc/" + className + ";1"].createInstance();
    return ret;
  }
}

function isProEEmbeddedBrowser ()
{
  if (top.external && top.external.ptc)
    return true;
  else
    return false;
}


function pfcGetProESession ()
{
  if (!isProEEmbeddedBrowser ())
    {
      throw new Error ("Not in embedded browser.  Aborting...");
    }

 
  // Security code
  if (pfcIsMozilla())
    netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");

 
  var glob = pfcCreate ("MpfcCOMGlobal");

  return glob.GetProESession();
}

function pfcGetScript ()
{
  if (!isProEEmbeddedBrowser ())
    {
      throw new Error ("Not in embedded browser.  Aborting...");
    }

  // Security code
  if (pfcIsMozilla())
    netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");

  var glob = pfcCreate ("MpfcCOMGlobal");
  return glob.GetScript();
}

function pfcGetExceptionDescription (err)
{
 if (pfcIsWindows())
    errString = err.description;
 else if (pfcIsChrome())
    errString = window.pfcCefGetLastException().message;
 else if (pfcIsMozilla())
    errString = err.message;
 return errString;
}

function pfcGetExceptionType (err)
{
  errString = pfcGetExceptionDescription (err);

  // This should remove the XPCOM prefix ("XPCR_C")
  if (errString.search ("XPCR_C") < 0)
  {
	errString = errString.replace ("Exceptions::", "");
	semicolonIndex = errString.search (";");
	if (semicolonIndex > 0)
		errString = errString.substring (0, semicolonIndex);
	return (errString);
  }
  else
      return (errString.replace("XPCR_C", ""));
}

function GetSession ()
{
	return pfcCreate ("MpfcCOMGlobal").GetProESession();
}

function open_ (filename, windowname, options)
{

	var session = GetSession();
 	var wd = session.GetCurrentDirectory ();

	var fileUrl = "file://" + filename;
	filename = wd + filename;
	
	var d = void null;
	/*if (pfcIsMozilla() || pfcIsChrome())
	{
	  win = window.open (fileUrl, windowname);
   	  var d = win.document;

	}*/
     
	jlApp = session.StartJLinkApplication ("jlinkwrite", 
								"com.ptc.jlinktools.pfcWriteOutputTask",
								"start",
								"stop",
								void null,
								void null, true);

	args = pfcCreate ("pfcArguments");

	var aValue = pfcCreate ("MpfcArgument").CreateStringArgValue (filename);
	args.Append (pfcCreate ("pfcArgument").Create ("FileName", aValue));	

	jlApp.ExecuteTask ("PFCTOOL-OPEN", args);

	return d;
}

function CreateTableHeader (doc)
{

	write_ (doc, "<HTML> <HEAD> <TITLE> Material Information </TITLE> </HEAD>");
   	write_ (doc, "<BODY> ");

	write_ (doc, "<TABLE border = '1'> <TR> <TH>  S.No </TH> <TH> Function Name  </TH> <TH> Error Status </TH> <TH> Error Code </TH> <TH> Error String </TH>  <TH> Object Info </TH>" );

}

function write_(doc, str)
{
	/* if (pfcIsChrome() || pfcIsMozilla())
		doc.write (str);
	*/

	args = pfcCreate ("pfcArguments");

	aValue = pfcCreate ("MpfcArgument").CreateStringArgValue (str);

	args.Append (pfcCreate ("pfcArgument").Create ("STRING", aValue));	

	jlApp.ExecuteTask ("PFCTOOL-WRITE", args);
}

function close_ (doc)
{
	args = pfcCreate ("pfcArguments");

	jlApp.ExecuteTask ("PFCTOOL-CLOSE", args);
}

function CloseTable (doc)
{
	write_ (doc, "</TABLE>");
        write_ (doc, "</BODY>    </HTML>");
}

function WriteSequence (doc, seq)
{
        write_ (doc, "<P> Total Elements  : " +seq.Count );
	write_ (doc, "<UL>");
        for (i=0; i<seq.Count; i++)
	    write_ (doc, "<LI> Element [ " + i + "] : " + seq.Item(i) + "</LI>" );
	write_ (doc, "</UL> </p>" );
}

function WriteFeatSequence (doc, seq)
{
        write_ (doc, "<P> Total Elements  : " +seq.Count );
	write_ (doc, "<UL>");
        for (i=0; i<seq.Count; i++)
        {	
   	    var feat_item = seq.Item(i);
	    write_ (doc, "<LI> Element [ " + i + "].Id : " + feat_item.Id + "</LI>" );
        }
	write_ (doc, "</UL> </p>" );
}

function WritePoint3DArray (doc, arr)
{
	write_ (doc, "<UL>");
        for (i=0; i<3; i++)
	    write_ (doc, "<LI> Element [ " + i + "] : " + arr.Item(i) + "</LI>" );
	write_ (doc, "</UL> </p>" );
}

function writeParamValue (doc,  parameter)
{

   if (parameter != void null)
   {
       param_val = parameter.Value;
       if (param_val != void null)
       {
           write_ (doc, "Name of Parameter : " + param.Name + "<br>");
           paramtypeobj = pfcCreate ("pfcParamValueType");
           paramval_discr = param_val.discr;

           switch ( paramval_discr)
 	   {

		case paramtypeobj.PARAM_STRING:
			write_ (doc, "<LI> String Value : " + param_val.StringValue +"</LI>");
		        break;

		case paramtypeobj.PARAM_INTEGER:
			write_ (doc, "<LI> Integer Value : " + param_val.IntValue + "</LI>");
			break;

		case paramtypeobj.PARAM_BOOLEAN:
			write_ (doc, "<LI> Boolean Value : " + param_val.BoolValue + "</LI>");
			break

		case paramtypeobj.PARAM_DOUBLE:
			write_ (doc, "<LI> Double Value  : " + param_val.DoubleValue + "</LI>" );
			break;

		case paramtypeobj.PARAM_NOTE:
			write_ (doc, "<LI> Note Value    :"  + param_val.NoteId + "</LI>");
			break;
	   }       
       }
   }

}	


function GetExceptionType (doc, exception)
{
      write_ (doc, " <LI> Exception Thrown: " + pfcGetExceptionType (exception) + "</LI>" );
	write_ (doc, " <LI> Full description: " + pfcGetExceptionDescription (exception) + " </LI>");
}
	


function closewinbtn_ ()
{
	/*if (pfcIsMozilla())
		win.close();
	*/
}

function closewin_ ()
{
	// If we're reg test mode, we should typically close the output window 
	// so as not to clutter up integ displays
      // Set "WL_KEEP_TEST_RESULTS" in the environment to prevent this.
	var session = GetSession();

	var env = session.GetEnvironmentVariable ("WL_KEEP_TEST_RESULTS");

	/*if (env == void null)
	{
		if (pfcIsMozilla())
			win.close();	
		
	}
	*/
}


function WlStatusWrite(doc, fn_name, err)
{
   if (err.Status == true)
   {
      write_ (doc,"<TR> <TD> " + (count++) + "</TD> <TD>" + fn_name + "</TD> <TD>" + err.Status + " </TD> <TD> " + err.ErrorCode  + " </TD> <TD> " +  err.ErrorString + " </TD>" ); 
      write_ (doc,"<TD>");
      ObjectInfo (doc, fn_name, err); 
      write_ (doc,"</TD> </TR>");
   }
   else
      write_ (doc,"<TR> <TD> " + (count++) + "</TD> <TD>" + fn_name + "</TD> <TD>" + err.Status + " </TD> <TD> " + err.ErrorCode  + " </TD>");
      if (err.ErrorCode == -10101)
               write_ (doc,"<TD>" + err.ErrorString + "</TD> </TR>"); 
}

  
function ObjectInfo ( doc, fn_name, err)
{
   if (fn_name == "pwlDimensionInfoGetByID" ||
		fn_name == "pwlDimensionInfoGetByName")
		  
   {
      write_ (doc,"<TD> " ); 
   
         write_ (doc,"<TABLE BORDER = '1' > ");
         write_ (doc,"<TR> <TH> Id      </TH> <TD> " + err.DimID    + "</TD>" );
         write_ (doc,"<TR> <TH> Name    </TH> <TD> " + err.DimName  + "</TD>");
         write_ (doc,"<TR> <TH> Value   </TH> <TD> " + err.DimValue + " </TD>");
         write_ (doc,"<TR> <TH> Style   </TH> <TD> " + err.DimStyle + "</TD>");
         write_ (doc,"<TR> <TH> TolType </TH> <TD> " + err.TolType  + "</TD>" );
	   write_ (doc,"</TABLE>");
   
     	write_ (doc,"</TD > </TR> ");
   }
   else if ( fn_name == "pwlMdlDimesnionsGet" ||
		   fn_name == "pwlFeatureDimensionsGet")
   {
         write_ (doc,"<p>   + No. of Dim(s) : " + err.NumDims + "</p>");
   }
   else if (fn_name == "pwlPartMaterialDataGet")
   {
      write_ (doc,"<TD> " );    

         write_ (doc,"<TABLE BORDER = '1' > ");
         write_ (doc,"<TR> <TH> YoungModulus      </TH> <TD> " + err.YoungModulus + "</TD>" );
         write_ (doc,"<TR> <TH> PoissonRatio      </TH> <TD> " + err.PoissonRatio + "</TD>");
         write_ (doc,"<TR> <TH> ShearModulus      </TH> <TD> " + err.ShearModulus + "</TD>");
         write_ (doc,"<TR> <TH> MassDensity       </TH> <TD> " + err.MassDensity  + "</TD>");
         write_ (doc,"<TR> <TH> ThermExpCoef      </TH> <TD> " + err.ThermExpCoef + "</TD>" );
         write_ (doc,"<TR> <TH> ThermExpRefTemp   </TH> <TD> " + err.ThermExpRefTemp   + "</TD>" );
         write_ (doc,"<TR> <TH> StructDampCoef    </TH> <TD> " + err.StructDampCoef    + "</TD>");
         write_ (doc,"<TR> <TH> StressLimTension  </TH> <TD> " + err.StressLimTension  + "</TD>");
         write_ (doc,"<TR> <TH> StressLimCompress </TH> <TD> " + err.StressLimCompress       + "</TD>");
         write_ (doc,"<TR> <TH> StressLimShear    </TH> <TD> " + err.StressLimShear    + "</TD>" );
         write_ (doc,"<TR> <TH> ThermConductivity </TH> <TD> " + err.ThermConductivity + "</TD>" );
         write_ (doc,"<TR> <TH> Emissivity        </TH> <TD> " + err.Emissivity        + "</TD>");
         write_ (doc,"<TR> <TH> SpecificHeat      </TH> <TD> " + err.SpecificHeat      + "</TD>");
         write_ (doc,"<TR> <TH> Hardness          </TH> <TD> " + err.Hardness          + "</TD>");    
    	
      write_ (doc,"</TABLE>");
   }
   else if (fn_name == "pwlPartMaterialGet")
   {
      write_ (doc," <p> Material Name   : " + err.MaterialName + "</p>");
   }
   else if (fn_name == "pwlPartMaterialsGet")
   {
      write_ (doc," <p> Num of Materials: " + err.NumMaterials + "</p>");
   }  	
   else if (fn_name == "pwlFamtabInstancesGet")
   {
      write_ (doc,"<p>   + No. of Instance(s) : " + err.NumInstances + "</p>");
      write_ (doc,"<TABLE BORDER = '1' > ");
      for (i=0; i<err.NumInstances; i++)
      {
	 write_ (doc,"<TR> <TH> Instance Name[" + i + "] </TH> <TD> " + err.InstanceNames.Item(i) + "</TD>" );
      }
      write_ (doc,"</TABLE>");
   }
   else if (fn_name == "pwlFamtabItemsGet")
   {
      write_ (doc,"<p>   + No. of Item(s)     : " + err.NumItems + "</p>");
      write_ (doc,"<TABLE BORDER = '1' > ");
      for (i=0; i<err.NumItems; i++)
      {
	 write_ (doc,"<TR> <TH> Item Type[" + i + "] </TH> <TD> " + err.FamItemTypes.Item(i) + "</TD>" );
	 write_ (doc,"<TR> <TH> Item [" + i + "] </TH> <TD> " + err.Items.Item(i) + "</TD>" );
      }

      write_ (doc,"</TABLE>");
   }
   else if (fn_name == "pwlFamtabInstanceValueGet")  
   {
      write_ (doc,"<TABLE BORDER = '1' > ");
         
         write_ (doc,"<TR> <TH> Type          </TH> <TD> " + err.ValueType    + "</TD>" );
         write_ (doc,"<TR> <TH> DoubleVal     </TH> <TD> " + err.DoubleVal    + "</TD>");
         write_ (doc,"<TR> <TH> IntVal        </TH> <TD> " + err.IntVal       + "</TD>");
         write_ (doc,"<TR> <TH> BooleanVal    </TH> <TD> " + err.BooleanVal   + "</TD>");
         write_ (doc,"<TR> <TH> StringVal     </TH> <TD> " + err.StringVal    + "</TD>" );
	
      write_ (doc,"</TABLE>");
   }
   else if ( fn_name == "pwlMdlFeaturesGet")
   {
      write_ (doc,"<p>   + No. of Feature(s)  : " + err.NumFeatures + "</p>");
      write_ (doc,"<TABLE BORDER = '1'> ");
      for (i=0; i<err.NumFeatures; i++)
 	{
         write_ (doc,"<TR> <TH>Feature ID["+ i + " ]</TH> <TD> " + err.FeatureIds.Item(i) + "</TD>" );
      }
      write_ (doc,"</TABLE>");
   }

   else if (fn_name == "pwlFeatureInfoGetByID" ||
	   fn_name == "pwlFeatureInfoGetByName")
   {
 
      write_ (doc,"<TABLE BORDER = '1' > ");
         write_ (doc,"<TR> <TH> FeatureType      </TH> <TD> " + err.FeatureType   + "</TD>" );
         write_ (doc,"<TR> <TH> FeatureId        </TH> <TD> " + err.FeatureID     + "</TD>");
         write_ (doc,"<TR> <TH> FeatureName      </TH> <TD> " + err.FeatureName   + "</TD>");
         write_ (doc,"<TR> <TH> FeatTypeName     </TH> <TD> " + err.FeatTypeName  + "</TD>");
      write_ (doc,"</TABLE>");
    }

   else if (fn_name == "pwlFeatureStatusGet")
   {
      write_ (doc,"<TABLE BORDER = '1'> ");

         write_ (doc,"<TR> <TH> Feature Status    </TH> <TD> " + err.FeatureStatus   + "</TD>" );
         write_ (doc,"<TR> <TH> Pattern Status    </TH> <TD> " + err.PatternStatus   + "</TD>");
         write_ (doc,"<TR> <TH> Group   Status    </TH> <TD> " + err.GroupStatus     + "</TD>");
         write_ (doc,"<TR> <TH> GroupPattern Status </TH> <TD> " + err.GroupPatternStatus  + "</TD>");

      write_ (doc,"</TABLE>");
   }

   else if (fn_name == "pwlFeatureParentsGet")
   {
    	write_ (doc," <p> Num. of Parents : " + err.NumParents  + "</p>");
      write_ (doc,"<TABLE BORDER = '1'> ");
      for (i=0; i<err.NumParents; i++)
 	{
         write_ (doc,"<TR> <TH> Parent ID </TH> <TD> " + err.ParentIDs.Item(i) + "</TD>" );
      }
      write_ (doc,"</TABLE>");
   }

   else if (fn_name == "pwlFeatureChildrenGet")
   {
      write_ (doc," <p> Num. of Children: " + err.NumChildren + "</p>");
	write_ (doc,"<TABLE BORDER = '1'> ");
      for (i=0; i<err.NumChildren; i++)
 	{
         write_ (doc,"<TR> <TH> Child ID </TH> <TD> " + err.ChildIDs.Item(i) + "</TD>" );
      }
      write_ (doc,"</TABLE>");
   }

   else if (fn_name == "pwlFeatureNameGetByID")
   {
      write_ (doc," <p> Feature Name    : " + err.FeatureName + "</p>");
   }

   else if (fn_name == "pwlAssemblyExplodeStatusGet")
   {
  	write_ (doc," <p> Explode Status  : " + err.ExplodeStatus + "</p>");
   }

   else if (fn_name == "pwlAssemblyExplodeStatesGet")
   {
      write_ (doc," <p> Num. of Explode States: " + err.NumExpldstates + "</p>");
	write_ (doc,"<TABLE BORDER = '1'> ");
      for (i=0; i<err.NumExpldstates; i++)
 	{
         write_ (doc,"<TR> <TH> State Name </TH> <TD> " + err.ExpldstateNames.Item(i) + "</TD>" );
      }
      write_ (doc,"</TABLE>");
   }
   else if (fn_name == "pwlAssemblyComponentsGet")
   {
      write_ (doc," <p> Num. of Models: " + err.NumMdls + "</p>");
      write_ (doc,"<TABLE BORDER = '1'> ");
      for (i=0; i<err.NumMdls; i++)
 	{
         write_ (doc,"<TR> <TH> Name[" + i + " ] </TH> <TD> " + err.MdlNameExt.Item(i) + "</TD>" );
 	   write_ (doc,"<TR> <TH> Id  [" + i + " ] </TH> <TD> " + err.ComponentID.Item(i) + "</TD>");
      }
      write_ (doc,"</TABLE>");
   }
   else if (fn_name == "pwlSessionMdlsGet")
   {
      write_ (doc," <p> Num. of Models: " + err.NumMdls + "</p>");
	write_ (doc,"<TABLE BORDER = '1'> ");
      for (i=0; i<err.NumMdls; i++)
 	{
         write_ (doc,"<TR> <TH> Model Name Ext : </TH> <TD> " + err.MdlNameExt.Item(i) + "</TD>" );
      }
      write_ (doc,"</TABLE>");
   }

   else if (fn_name == "pwlMdlIntralinkInfoGet")
   {
      write_ (doc,"<TABLE BORDER = '1'> ");

         write_ (doc,"<TR> <TH> Version         :    </TH> <TD> " + err.Version       + "</TD>");
         write_ (doc,"<TR> <TH> Revision        :    </TH> <TD> " + err.Revision      + "</TD>");
         write_ (doc,"<TR> <TH> Branch          :    </TH> <TD> " + err.Branch        + "</TD>");
	   write_ (doc,"<TR> <TH> Release Level   :    </TH> <TD> " + err.ReleaseLevel + "</TD>");
  
      write_ (doc,"</TABLE>");
   } 

   else if (fn_name == "pwlMdlInfoGet")
   {
      write_ (doc,"<TABLE BORDER = '1'> ");

         write_ (doc,"<TR> <TH> Model Type    </TH> <TD> " + err.MdlType   + "</TD>" );
         write_ (doc,"<TR> <TH> Top Generic Name    </TH> <TD> " + err.TopGenericName   + "</TD>");
         write_ (doc,"<TR> <TH> Imm Generic Name    </TH> <TD> " + err.ImmediateGenericName + "</TD>");
  
      write_ (doc,"</TABLE>");
   } 
   else if (fn_name == "pwlMdlDependenciesGet")
   {
      write_ (doc,"<p> Num  of Models : " + err.NumMdls   + "</p>" );
      write_ (doc,"<TABLE BORDER = '1'> ");
      for (i=0; i<err.NumMdls; i++)
      {
         write_ (doc,"<TR> <TH> Mdl Name Ext [" + i + " ] </TH> <TD> " + err.MdlNameExt.Item(i) + "</TD>");
      }
      write_ (doc,"</TABLE>");
   } 

   else if (fn_name == "pwlMdlNotesGet")
   {
      write_ (doc," <p> Num. of Notes: " + err.NumNotes + "</p>");
	write_ (doc,"<TABLE BORDER = '1'> ");
      for (i=0; i<err.NumNotes; i++)
 	{
         write_ (doc,"<TR> <TH> Note ID [" + i + " ] </TH> <TD> " + err.NoteIDs.Item(i) + "</TD>" );
      }
      write_ (doc,"</TABLE>");
   }
   else if (fn_name ==  "pwlMdlViewsGet")
   {
      write_ (doc," <p> Num. of Views: " + err.NumViews + "</p>");
	write_ (doc,"<TABLE BORDER = '1'> ");
      for (i=0; i<err.NumViews; i++)
 	{
         write_ (doc,"<TR> <TH> View Name [" + i + " ] </TH> <TD> " + err.ViewNames.Item(i) + "</TD>" );
      }
      write_ (doc,"</TABLE>");
   }

   else if (fn_name == "pwlMdlLayersGet")
   {
      write_ (doc," <p> Num. of Layers: " + err.NumLayers + "</p>");
	write_ (doc,"<TABLE BORDER = '1'> ");
      for (i=0; i<err.NumLayers; i++)
 	{
         write_ (doc,"<TR> <TH> Layer Name </TH> <TD> " + err.LayerNames.Item(i) + "</TD>" );
      }
      write_ (doc,"</TABLE>");
   }

   else if (fn_name == "pwlLayerDisplayGet")
   {  
      write_ (doc," <p> Display Type  : " + err.DisplayType + "</p>");
   }

   else if (fn_name == "pwlSolidMassPropertiesGet")
   {
    write_ (doc, "<TABLE BORDER = '1'> ");

         write_ (doc, "<TR> <TH> Volume       :    </TH> <TD> " + err.Volume       + "</TD>");
         write_ (doc, "<TR> <TH> Surface Area :    </TH> <TD> " + err.SurfaceArea  + " </TD>");
         write_ (doc, "<TR> <TH> Density      :    </TH> <TD> " + err.Density      + "</TD>");
	 write_ (doc, "<TR> <TH> Mass         :    </TH> <TD> " + err.Mass         + "</TD>");
  
      write_ (doc, "</TABLE>");
   }
   
   else if ( fn_name == "pwlSolidXSectionsGet")
   {
      write_ (doc, " <p> Num. of XSection(s): " + err.NumCrossSections + "</p>");
	write_ (doc, "<TABLE BORDER = '1'> ");
      for (i=0; i<err.NumCrossSections; i++)
 	{
         write_ (doc, "<TR> <TH> X Section Name[" + i + " ] </TH> <TD> " + err.CrossSectionNames.Item(i) + "</TD>" );
      }
      write_ (doc, "</TABLE>");
   }

   else if (fn_name == "pwlMdlSimprepsGet")
   {
      write_ (doc," <p> Num. of Simprep(s): " + err.NumSimpreps + "</p>");
	write_ (doc,"<TABLE BORDER = '1'> ");
      for (i=0; i<err.NumSimpreps; i++)
 	{
         write_ (doc,"<TR> <TH> Simpreps [" + i + " ] </TH> <TD> " + err.Simpreps.Item(i) + "</TD>" );
      }
      write_ (doc,"</TABLE>");
   }

   else if (fn_name == "pwlSimprepCurrentGet")
   {
      write_ (doc," <p> Name of Simprep : " + err.Simprep + "</p>");
   }
   else if ( fn_name == "pwlMdlParametersGet" ||
		   fn_name == "pwlFeatureParametersGet" )
   {
      write_ (doc," <p> Num. of Parameter(s): " + err.NumParams + "</p>");
	write_ (doc,"<TABLE BORDER = '1'> ");
      for (i=0; i<err.NumParams; i++)
 	{
         write_ (doc,"<TR> <TH> Parm Name[" + i + " ] </TH> <TD> " + err.ParamNames.Item(i) + "</TD>" );
      }
      write_ (doc,"</TABLE>");
   }
   else if ( fn_name == "pwlParameterDesignationVerify")
   {
      write_ (doc," <p> Is Exists: " + err.Exists + "</p>");
   }
   else if ( fn_name == "pwlParameterValueGet")
   {
      write_ (doc,"<TABLE BORDER = '1' > ");
         
         write_ (doc,"<TR> <TH> Type          </TH> <TD> " + err.ParamType         + "</TD>" );
         write_ (doc,"<TR> <TH> DoubleVal     </TH> <TD> " + err.ParamDoubleVal    + " </TD>");
         write_ (doc,"<TR> <TH> IntVal        </TH> <TD> " + err.ParamIntVal       + "</TD>");
         write_ (doc,"<TR> <TH> BooleanVal    </TH> <TD> " + err.ParamBooleanVal   + "</TD>");
         write_ (doc,"<TR> <TH> StringVal     </TH> <TD> " + err.ParamStringVal    + "</TD>" );
	
      write_ (doc,"</TABLE>");
   }
   else if (fn_name == "pwlFeatureNotesGet")
   {
      write_ (doc," <p> Num. of Notes: " + err.NumNotes + "</p>");
   }
   else if (fn_name == "pwlNoteTextGet")
   {
 	write_ (doc," <p> Num. of Text Lines: " + err.NumTextLines + "</p>");
	write_ (doc,"<TABLE BORDER = '1'> ");
      for (i=0; i<err.NumTextLines; i++)
 	{
         write_ (doc,"<TR> <TH> Note Text [" + i + " ] </TH> <TD> " + err.NoteText.Item(i) + "</TD>" );
      }
      write_ (doc,"</TABLE>");
   }
   else if (fn_name == "pwlNoteNameGet")
   {
      write_ (doc," <p> Note Name : " + err.NoteName + "</p>");
   }
   else if (fn_name == "pwlNoteURLGet")
   {
      write_ (doc," <p> Note URL : " + err.NoteURL + "</p>");
   }
   else if (fn_name == "pwlNoteOwnerGet")
   {
	write_ (doc," <p> Note Item Type : " + err.ItemType + "</p>");
      write_ (doc," <p> Note Owner ID  : " + err.NoteOwnerID + "</p>");
   }
   else if (fn_name == "pwlItemIDToName")
   {
	write_ (doc," <p> ItemName : " + err.ItemName + "</p>");
   }
   else if (fn_name == "pwlItemNameToID")
   {
      write_ (doc," <p> ItemID   : " + err.ItemID + "</p>");
   }
   else if (fn_name == "pwlEnvVariableGet")
   {
	write_ (doc," <p> Variable Value : " + err.Value + "</p>");
   }
   else
   { 
      write_ (doc," <p> Nill </p> ");   
   }
}

function ProExec(cmd) {
   try {return top.external.ptc(cmd);} catch (e) {}
   return null;
 }

 function forceTrailOOS (x) { 
// Fn to write a string in trail file should be added here.
   ProExec("0TrlOOS" + x ); 
 }
 function ProECommand(cmd) { return ProExec("1" + cmd); }


 


