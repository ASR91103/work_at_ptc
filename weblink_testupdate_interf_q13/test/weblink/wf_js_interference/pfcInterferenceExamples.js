/*
   HISTORY

14-NOV-02   J-03-38   ##1   JCN      Adapted from J-Link examples.
07-MAR-03   K-01-03   ##2   JCN      UNIX support
16-Dec-04   K-03-15   $$1   ALS      Moved from rdweb to the system.
19-Feb-2014   P-20-48 $$2 gshmelev used pfcIsMozilla
09-Dec-20   P-80-32   $$3 ychavhan   Fetched and submitting locally.
08-Oct-24   Q-12-36   $$4 aphatak    Disabled window.* calls
18-Apr-25   Q-13-04   $$5 aphatak    Updated for edge browser.
*/

/*
   This method allows a user to evaluate the assembly for a presence of any
   interferences. Upon finding one, this method will highlight the interfering
   surfaces, compute and highlight the interference volume.
*/

function write_doc (doc, savable, str)
{
   if (savable == "true" )
   {
       write_ (doc, str);
   }
   /*else
   {
       doc.writeln (str);
   }*/
}

function showInterferences(doc)
{
  if (pfcIsMozilla())
    netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");

/*--------------------------------------------------------------------*\ 
  Get the current assembly 
\*--------------------------------------------------------------------*/  
  var session = pfcGetProESession ();
  var assembly = session.CurrentModel;

  var newWin;
  var save = "true";

  /*if (doc == void null)
  {
     if (pfcIsWindows())
     {
	  save = "true";

          newWin.resizeTo (300, screen.height/2.0);
          newWin.moveTo (screen.width-300, 0);

     }
     else
     {
          newWin = window.open ('', "_LS", "scrollbars");
          doc = newWin.document;
	  save = "false";
     }
	 
  }*/



  if (assembly.Type != pfcCreate ("pfcModelType").MDL_ASSEMBLY)
    throw new Error (0, "Current model is not an assembly");
  
/*--------------------------------------------------------------------*\ 
  Calculate the assembly interference
\*--------------------------------------------------------------------*/
  var gblEval = 
    pfcCreate ("MpfcInterference").CreateGlobalEvaluator(assembly);
  
  var gblInters = gblEval.ComputeGlobalInterference(true);


  
  if (gblInters != void null)
    {
      var size = gblInters.Count;
      
/*--------------------------------------------------------------------*\ 
  For each interference object display the interfering surfaces
  and compute the interference volume
\*--------------------------------------------------------------------*/
      session.CurrentWindow.SetBrowserSize (0.0);
      session.CurrentWindow.Repaint();
//      alert ("Interferences detected, highlighting each instance.");
      for (var i = 0; i < size; i++)
	{
	  var gblInter=0;
		if ( pfcIsEdge() ) 
		{
			gblInter = gblInters.Item [i];
		}
		else
		{
			gblInter = gblInters.Item (i);
		}
	  
	  var selectPair = gblInter.SelParts;
	  var sel1 = selectPair.Sel1;
	  var sel2 = selectPair.Sel2;
	  sel1.Highlight(pfcCreate ("pfcStdColor").COLOR_HIGHLIGHT);
	  sel2.Highlight(pfcCreate ("pfcStdColor").COLOR_HIGHLIGHT);

          var model1 = sel1.SelModel;
          var model2 = sel2.SelModel;

          if (model1 != void null && model2 != void null)
          {
               write_doc (doc, save, "<h3> Interference is between the following model: </h3>");
               write_doc (doc, save, "Model 1 : " + model1.InstanceName + " <br>");
               write_doc (doc, save, "Model 2 : " + model2.InstanceName + " <br>");

               var intfvolume = gblInter.Volume;
               var volume     = intfvolume.ComputeVolume();

               write_doc (doc, save, "Interference Volume : " + volume + " <br>");
          }
	  
	  var vol = gblInter.Volume;
	  var totalVolume = vol.ComputeVolume();
	  vol.Highlight(pfcCreate ("pfcStdColor").COLOR_PRESEL_HIGHLIGHT);
// alert ("Interference " + (i + 1) + " = " + totalVolume);
	  
	  sel1.UnHighlight();
	  sel2.UnHighlight();			
	}
    }
}
