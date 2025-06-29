#ifndef PTTEST_DEBUG
#line 3 "otk_model_39q10.cxx"
#endif

/*=============================================================================

Description: Test for SPR 16077445

  Trail name: otk_model_39q10_spr16077445/_dll.txt

  Steps taken by trail:
    1. Open Creo.
    2. Open part file prt0001.prt .
    3. create a drawing from the part file prt0001.prt.
    a. In button1 action function we are regenerating a solid which works successfully by returning 0.
    b. In case of drawing, added Negative test case to return PRO_TK_BAD_INPUTS as it was doing in Creo 8.0.12.0, 9.0.10.0.
  4. Close Pro/E.

HISTORY:
Date          Build     Modifier  Rev#  Changes
--------------------------------------------------------------------
04-Apr-25     Q-13-02   sarsewar  $$1  Created.

=============================================================================*/

#include <pfcGlobal.h>
#include <wfcSession.h>
#include <pfcExceptions.h>
#include <pfcCommand.h>
#include <fstream>
#include <OtkTUtils.h>

//*****************************************************************************
class CommandCallbackmodel39q101 : public virtual pfcUICommandActionListener
{
public:
  void OnCommand();
};

//*****************************************************************************
ProError otk_model_39q10(
    int argc,
    char *argv[],
    char *proe_vsn,
    char *build,
    wchar_t err_buff[])
{
  if (argc < 1)
  {
    tkout << "Usage: " << endl;
    tkout << "+tkgrp:model +tkid:39q10 +tk:<model name>" << endl;
    tkout << "... +tkgrp:model +tkid:39q10 +tk:<model name> " << endl;
    return PRO_TK_BAD_INPUTS;
  }
  try
  {
    wfcWSession_ptr Session = wfcWSession::cast(pfcGetProESession());
    OtkUtilLogFunction("wfcWSession::cast");
    Session->RibbonDefinitionfileLoad("otk_cpp_tests.rbn");

    CommandCallbackmodel39q101 *listner1 = new CommandCallbackmodel39q101();

    /* Create command */
    pfcUICommand_ptr InputCommand1 = Session->UICreateCommand("Button1", listner1);
    OtkUtilLogFunction("wfcWSession::UICreateCommand");
    InputCommand1->Designate("otk_cpp_tests_message.txt", "Button1", "Button1", "Button1");
    OtkUtilLogFunction("pfcUICommand::Designate");
  }
  xcatchbegin
  xcatchcip(Ex)
  {
    ofstream exceptionFile;
    exceptionFile.open("ExceptionCatch.inf", ios::out);
    exceptionFile << "Exception:" << endl
                  << Ex << endl;
    exceptionFile.close();
  }
  xcatchend return PRO_TK_NO_ERROR;
}

/*=====================================================================================*/
void CommandCallbackmodel39q101::OnCommand()
{
  try
  {

    ProError status;
    ProMdl mdl;

    status = ProMdlCurrentGet((ProMdl *)&mdl);
    PT_TEST_LOG_SUCC("ProMdlCurrentGet");

    ProSolid sol;
    status = ProDrawingCurrentsolidGet((ProDrawing)mdl, &sol);
    PT_TEST_LOG_SUCC("ProDrawingCurrentsolidGet");

    /*Supposed to regenerate a solid and to fail in case of drawing with error code*/
    status = ProSolidRegenerate(sol, PRO_REGEN_NO_FLAGS);
    PT_TEST_LOG_SUCC("ProSolidRegenerate");

    /*
      Function was crashing in Creo 10.0.0.0, 10.0.8.0, 11.0.3.0  and onwords in case of drawing
      It should return PRO_TK_BAD_INPUTS as it was doing in Creo 8.0.12.0, 9.0.10.0 in case of drawing.
    */
    // Added Negative test case to validate this
    status = ProSolidRegenerate((ProSolid)mdl, PRO_REGEN_NO_FLAGS);
    PT_TEST_LOG("ProSolidRegenerate", status, status != PRO_TK_BAD_INPUTS);

    return;
  }
  xcatchbegin
  xcatchcip(Ex)
  {
    ofstream filept;
    filept.open("exception_thrown.inf", ios::out); // We want exception to be written in the file
    filept << "Exception:" << endl
           << Ex << endl;
    filept.close();
  }
  xcatchend
}
