#ifndef PTTEST_DEBUG
#line 3 "otk_intf3d_074q11.cxx"
#endif

/*=============================================================================
 
Description: Test for SPR 15893357

Before SPR 15893357 fix, API ProIntf3DFileWriteWithDefaultProfile() was
 ignoring the config.pro option "intf3d_out_create_export_log NO" 
 and .log file for export was getting created. 
 After SPR fix, with above config API ProIntf3DFileWriteWithDefaultProfile() 
 is not created .log file for export.
 
  Trail name: otk_intf3d_074q11_spr15893357/_dll.txt

  Steps taken by trail:
    1.Launch Creo.
    2.open the part 
    3.Run the TK application
	4.Close xtop 
  
HISTORY:
Date          Build     Modifier  Rev#  Changes
--------------------------------------------------------------------
10-Feb-25     Q-12-51   sarsewar  $$1  Created.

=============================================================================*/

#include <pfcGlobal.h>
#include <wfcSession.h>
#include <pfcExceptions.h>
#include <pfcCommand.h>
#include <fstream>
#include <OtkTUtils.h>

//*****************************************************************************
class CommandCallbackintf3d074q111 : public virtual pfcUICommandActionListener
{
public :
  void OnCommand();
};

//*****************************************************************************
ProError otk_intf3d_074q11 (
                          int argc,
                          char* argv[],
                          char *proe_vsn,    
                          char *build,              
                          wchar_t err_buff[])
{
  ProError status;

  if (argc < 1)
  {
    tkout << "Usage: " << endl;
    tkout << "+tkgrp:intf3d +tkid:074q11 +tk:<model name>" << endl;
		tkout << "... +tkgrp:intf3d +tkid:074q11 +tk:<model name> " << endl;
    return PRO_TK_BAD_INPUTS;
  }
  try 
  {
		wfcWSession_ptr Session = wfcWSession::cast(pfcGetProESession() );
		OtkUtilLogFunction("wfcWSession::cast");
		Session->RibbonDefinitionfileLoad("otk_cpp_tests.rbn");

		CommandCallbackintf3d074q111* listner1 = new CommandCallbackintf3d074q111();

		/* Create command */
    pfcUICommand_ptr InputCommand1 = Session->UICreateCommand("Button1", listner1 );
		OtkUtilLogFunction("wfcWSession::UICreateCommand");
    InputCommand1->Designate ("otk_cpp_tests_message.txt", "Button1", "Button1", "Button1");
		OtkUtilLogFunction("pfcUICommand::Designate");
  }
  xcatchbegin
  xcatchcip (Ex)
  {
    ofstream exceptionFile;
    exceptionFile.open("ExceptionCatch.inf",ios::out);
    exceptionFile << "Exception:" << endl  << Ex << endl;
    exceptionFile.close();    
  }
  xcatchend    
	return PRO_TK_NO_ERROR;
}

/*=====================================================================================*/
void CommandCallbackintf3d074q111::OnCommand()
{ 
	ofstream infoFileintf3d074q11;
	if ( otkTestQcrgenMode == OtkTestRunModeGet() )
	  infoFileintf3d074q11.open("intf3d_074q11_info.qcr",ios::out);
	else
	  infoFileintf3d074q11.open("intf3d_074q11_info.inf",ios::out);
  try    
  {

    ProMdl mdl;
	ProError status=PRO_TK_NO_ERROR;
	ProMdlType type;
	ProPath directory_path = L"";
	ProLine filter = L"*.log*";
	ProFileListOpt listing_option = PRO_FILE_LIST_ALL;
	ProPath* p_file_name_array = NULL;
    ProPath* p_subdir_name_array= NULL;
	int num_files = 0;
	
	ProArrayAlloc (0, sizeof (ProPath), 1, (ProArray*)&p_file_name_array);
    ProArrayAlloc (0, sizeof (ProPath), 1, (ProArray*)&p_subdir_name_array);


	status = ProMdlCurrentGet(&mdl);
	PT_TEST_LOG_SUCC("ProMdlCurrentGet");
	if (status == PRO_TK_NO_ERROR)
	{	
		status = ProIntf3DFileWriteWithDefaultProfile((ProSolid)mdl, PRO_INTF_EXPORT_STEP, 
			L"MyExportedFile");
		PT_TEST_LOG_SUCC("ProIntf3DFileWriteWithDefaultProfile"); 
	
		ProStringToWstring (directory_path, "./");
	
		// called API ProFilesList() to make sure .log* is not created in cwd
		status = ProFilesList(directory_path, filter, listing_option, &p_file_name_array, &p_subdir_name_array);
		PT_TEST_LOG_SUCC("ProFilesList");
	 
		status= ProArraySizeGet (p_file_name_array, &num_files);
		PT_TEST_LOG_SUCC("ProArraySizeGet");
		
		if(num_files>=1)
		{
			infoFileintf3d074q11<< "The number of Log files are: "<< num_files << endl;
		}
		else
		{
			infoFileintf3d074q11<< "Log file is not created for export action (as expected)"<< endl;
		}		
  
		status = ProArrayFree((ProArray*)&p_file_name_array);
		PT_TEST_LOG_SUCC("ProArrayFree");
  
		status = ProArrayFree((ProArray*)&p_subdir_name_array);
		PT_TEST_LOG_SUCC("ProArrayFree");
  	
	}
	return;

  }
  xcatchbegin
  xcatchcip (Ex)
  {
    ofstream filept;
    filept.open("exception_thrown.inf",ios::out); //We want exception to be written in the file
    filept << "Exception:" << endl  << Ex << endl;
    filept.close();
  }
  xcatchend	
	infoFileintf3d074q11.close();
	PTCompareOptions* opts = PTQAAllocCompareOptions ();  
	opts->abs_eps = 1.0;
	opts->rel_eps = 0.1;
	OtkTestFileCompare("intf3d_074q11_info.inf", "intf3d_074q11_info.qcr", opts);
	PTQAFreeCompareOptions(opts);
}
