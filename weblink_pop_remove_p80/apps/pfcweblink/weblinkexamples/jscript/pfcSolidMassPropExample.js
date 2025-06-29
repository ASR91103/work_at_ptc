/*
   HISTORY
   
14-NOV-02   J-03-38   $$1   JCN      Adapted from J-Link examples.
07-MAR-03   K-01-03   $$2   JCN      UNIX support
19-Feb-14   P-20-48   $$3 gshmelev   used pfcIsMozilla
06-Dec-24   P-80-52   $$4 aphatak    Remove window funcs
*/

/* This method retrieves a MassProperty object from the provided solid
 * model. Then solid's mass, volume, and center of gravity point are printed
 */
function printMassProperties()
{
  if (pfcIsMozilla())
    netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");

  /*--------------------------------------------------------------------*\ 
    Get the session. If no model in present abort the operation. 
  \*--------------------------------------------------------------------*/
  var session = pfcGetProESession();
  var solid = session.CurrentModel;

  if (solid == void null || (solid.Type != pfcCreate("pfcModelType").MDL_PART &&
    solid.Type != pfcCreate("pfcModelType").MDL_ASSEMBLY))
    throw new Error(0, "Current model is not a part or assembly.");

  /*--------------------------------------------------------------------*\ 
    Calculate the mass properties.  Pass null to use the model 
    coordinate system.
  \*--------------------------------------------------------------------*/
  properties = solid.GetMassProperty(void null);

  /*--------------------------------------------------------------------*\ 
    Display selected results.
  \*--------------------------------------------------------------------*/
  var output = "";
  output += "<p>The solid mass is: " + properties.Mass;
  output += "<p>The solid volume is: " + properties.Volume;
  COG = properties.GravityCenter;
  output += "<hr><p>The Center Of Gravity is at ";
  output += "<table>";

  output += "<tr><td>X:</td><td>" + COG.Item(0) + "</td></tr>";
  output += "<tr><td>Y:</td><td>" + COG.Item(1) + "</td></tr>";
  output += "<tr><td>Z:</td><td>" + COG.Item(2) + "</td></tr>";

  output += "</table>";
  
  return output;
}
