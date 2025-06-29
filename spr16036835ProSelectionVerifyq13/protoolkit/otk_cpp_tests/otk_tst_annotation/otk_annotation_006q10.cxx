#ifndef PTTEST_DEBUG
#line 3 "otk_annotation_006q10.cxx"
#endif

/*=============================================================================
 
Description: Test for SPR 16036835

  Trail name: otk_annotation_006q10_spr16036835/_dll.txt

  Steps taken by trail:
    1. 	Open Creo.
    2. 	Open part file prt0001.prt
    3. 	OTK_CPP_TESTS -> Button1
			a.In button1 action function, ProSelectionVerify(...) and ProSelectionModelitemGet(...) returns -2.
    4. 	close part file.
    5.	Erase not displayed.
    6.  Open Drawing file test.drw
    7.	OTK_CPP_TESTS -> Button1
			a.In button1 action function, ProSelectionVerify(...) and ProSelectionModelitemGet(...) returns -1.
    8. 	Close Pro/E
HISTORY:
Date          Build     Modifier  Rev#  Changes
--------------------------------------------------------------------
10-Apr-25     Q-13-03   sarsewar  $$1  Created.

=============================================================================*/

#include <pfcGlobal.h>
#include <wfcSession.h>
#include <pfcExceptions.h>
#include <pfcCommand.h>
#include <fstream>
#include <OtkTUtils.h>

//*****************************************************************************
class CommandCallbackannot006q101 : public virtual pfcUICommandActionListener
{
public :
  void OnCommand();
};

//*****************************************************************************
ProError otk_annotation_006q10 (
                          int argc,
                          char* argv[],
                          char *proe_vsn,    
                          char *build,              
                          wchar_t err_buff[])
{

  if (argc < 1)
  {
    tkout << "Usage: " << endl;
    tkout << "+tkgrp:annotation +tkid:006q10 +tk:<model name>" << endl;
		tkout << "... +tkgrp:annotation +tkid:006q10 +tk:<model name> " << endl;
    return PRO_TK_BAD_INPUTS;
  }
  try 
  {
		wfcWSession_ptr Session = wfcWSession::cast(pfcGetProESession() );
		OtkUtilLogFunction("wfcWSession::cast");
		Session->RibbonDefinitionfileLoad("otk_cpp_tests.rbn");

		CommandCallbackannot006q101* listner1 = new CommandCallbackannot006q101();

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
void CommandCallbackannot006q101::OnCommand()
{ 

  try    
  {

    ProError status;
	ProMdl mdl;

	status = ProMdlCurrentGet((ProMdl*)&mdl);
	PT_TEST_LOG_SUCC("ProMdlCurrentGet");
	
	//fprintf(msg_fp, "  + Retrieved Server Version : ( %s ) \n", temp_string);
	
	ProSelection sels;
	status = ProSelectionAlloc(NULL, NULL, &sels);
	PT_TEST_LOG_SUCC("ProSelectionAlloc");
	
	status = ProSelectionVerify(sels);
	PT_TEST_LOG("ProSelectionVerify", status, (status != PRO_TK_GENERAL_ERROR && status != PRO_TK_BAD_INPUTS));
	
	ProModelitem mdlitem;
	status = ProSelectionModelitemGet(sels, &mdlitem);
	PT_TEST_LOG("ProSelectionModelitemGet", status, (status != PRO_TK_GENERAL_ERROR && status != PRO_TK_BAD_INPUTS));

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
}
