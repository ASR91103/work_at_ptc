#ifndef PTTEST_DEBUG
#line 3 "otk_detailing_03p90.cxx"
#endif

/*=============================================================================

Description: Added OTK test to verify API ProDtlsyminstSurffinGet.

HISTORY:
Date         Build      Modifier      Rev#   Changes
--------------------------------------------------------------------
30-Aug-24     Q-10-54   sshrivastava  $$1   Created.
23-May-25     Q-10-58   sarsewar      $$2   Updated for API ProDtlsyminstSolidSymGet.

=============================================================================*/

#include <pfcGlobal.h>
#include <wfcSession.h>
#include <pfcExceptions.h>
#include <pfcCommand.h>
#include <fstream>
#include <OtkTUtils.h>
#include <ProDtlsyminst.h>

//*****************************************************************************
ofstream infoFiledetail03p90;

ProError drawing_visit_action_03p90(ProDtlitem* dtlitem, ProError status, ProAppData data)
{
	if (dtlitem->type == PRO_SYMBOL_INSTANCE)
	{
		
		ProSurfFinish surf_fin;
		
		status = ProDtlsyminstSurffinGet((ProDtlsyminst*)dtlitem, &surf_fin);
		PT_TEST_LOG("ProDtlsyminstSurffinGet", status, (status != PRO_TK_NO_ERROR && status != PRO_TK_E_NOT_FOUND));

		if (status == PRO_TK_NO_ERROR)
		{
			infoFiledetail03p90 << "Annotation id: " << dtlitem->id << " type: " << dtlitem->type << " corresponding surface finish id: " << surf_fin.id << " type: " << surf_fin.type << endl;
		}
		if (status == PRO_TK_E_NOT_FOUND)
		{	
			ProDtlsyminst sld_sym;
			status = ProDtlsyminstSolidSymGet((ProDtlsyminst*) dtlitem, &sld_sym);
			PT_TEST_LOG("ProDtlsyminstSolidSymGet", status, (status != PRO_TK_NO_ERROR && status != PRO_TK_E_NOT_FOUND));
			if(status == PRO_TK_NO_ERROR){
				infoFiledetail03p90 << " Symbol Instance id: " << dtlitem->id << " type: " << dtlitem->type << " corresponding solid symbol instance id: " << sld_sym.id << " type: " << sld_sym.type << endl;
			}
			
		}
		

	}
	return PRO_TK_NO_ERROR;
}
//*****************************************************************************
ProError otk_detailing_03p90(
	int argc,
	char* argv[],
	char* proe_vsn,
	char* build,
	wchar_t err_buff[])
{
	ProError status = PRO_TK_NO_ERROR;
	ProMdlName modelName = L"surface-finish-test.drw";
	ProMdl drawing;
	int sheet = -1;


	if (argc < 1)
	{
		tkout << "Usage: " << endl;
		tkout << "+tkgrp:detailing +tkid:03p90" << endl;
		return PRO_TK_BAD_INPUTS;
	}
	try
	{
		infoFiledetail03p90.open("detail_03p90_info.inf", ios::out);

		status = ProMdlnameRetrieve(modelName, PRO_MDLFILE_DRAWING, &drawing);
		PT_TEST_LOG_SUCC("ProMdlnameRetrieve");

		status = ProDrawingCurrentSheetGet((ProDrawing)drawing, &sheet);
		PT_TEST_LOG_SUCC("ProDrawingCurrentSheetGet");

		status = ProDrawingDtlsyminstVisit((ProDrawing)drawing, sheet, drawing_visit_action_03p90, NULL, NULL);
		PT_TEST_LOG_SUCC("ProDrawingDtlsyminstVisit");
	}
	xcatchbegin
		xcatchcip(Ex)
	{
		ofstream exceptionFile;
		exceptionFile.open("ExceptionCatch.inf", ios::out);
		exceptionFile << "Exception:" << endl << Ex << endl;
		exceptionFile.close();
	}
	xcatchend
		infoFiledetail03p90.close();
	PTCompareOptions* opts = PTQAAllocCompareOptions();
	opts->abs_eps = 0.001;
	opts->rel_eps = 0.001;
	OtkTestFileCompare("detail_03p90_info.inf", "detail_03p90_info.qcr", opts);
	PTQAFreeCompareOptions(opts);
	return PRO_TK_NO_ERROR;
}
