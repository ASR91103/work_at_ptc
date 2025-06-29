#ifndef OTK_INTF3D_TESTS_H
#define OTK_INTF3D_TESTS_H

#include <OtkTUtils.h>

/*
20-Mar-10  L-05-22 gshmelev  $$1   Created.
07-Feb-11  L-05-41 sbinawad  $$2   Added OtkTIntf3D_002.
14-Feb-11  L-05-42 aphatak   $$3   Added OtkTIntf3D_003.
14-Apr-11  L-05-45 pdeshmuk $$4  Added otk_intf3d_004/005
26-Apr-11  L-05-46 pdeshmuk $$5  Added otk_intf3d_006.
04-May-11 L-05-46 pdeshmuk $$6  Added otk_intf3d_007
26-May-11 L-05-47 pdeshmuk $$7  Added otk_intf3d_008
25-July-11 P-10-06 rkothari $$8 Added otk_intf3d_009
17-Nov-11  P-10-12   sbinawad  $$9   Added otk_intf3d_010
25-Nov-11  P-10-13 pdeshpande  $$10  Added otk_intf3d_011 and otk_intf3d_012
                   sbinawad          Added otk_intf3d_013   
13-Dec-11  P-10-14 rkumbhare  $$11   Added otk_intf3d_014/15/16/17/18.
14-Dec-11  P-10-14 tshmeleva  $$12  Changed to otk_test_with_id
22-Dec-11  P-10-14 rkumbhare  $$13  Added otk_intf3d_021p10.
02-Jan-12  P-10-14 sbinawad   $$14  Added otk_intf3d_022p10.
06-Feb-12  P-10-17 aphatak   $$15   Added otk_intf3d_023p10
	           sbinawad         Added otk_intf3d_024p10
09-Mar-12  P-10-17 sbinawad   $$16  Added 025p10.
13-Jul-12  P-20-09 sbinawad   $$17  Updated 001 002 and 003.
25-Oct-12  P-20-15 sbinawad   $$18  Added 026p20 and 027p20.
16-Jan-13  P-20-21 sbinawad   $$19  Added 028p20
31-Jan-13  P-20-22 rkumbhare  $$20  Added 031p20
		   mtyagi           Added 027p10
04-Feb-13  P-20-23 pdeshmuk   $$21  Added 030p20
				   sbinawad         Added 029p20
11-Feb-13  P-20-23 rkumbhare  $$22  Added 032p20
06-Mar-13  P-20-25 rkumbhare  $$23  Added 033p20
13-Mar-13  P-20-25 rkumbhare  $$24  Added 034p20
07-Jun-13  P-20-31 mtyagi     $$25  Added 028p10 for SPR 2173715 & SPR 2174606.
13-Jul-13  P-20-34 rkumbhare  $$26  Added 035p20.
09-Aug-13  P-20-36  asingla   $$27  Added spr2187594
09-Sep-13  P-20-37 rkumbhare  $$28  Added 036p20.
09-Oct-13  P-20-40 rkumbhare  $$29  Added 037p20.
09-Nov-13  P-20-42 rkumbhare  $$30  Added 038p20.
22-Nov-13  P-20-43 rkumbhare  $$31  Added intfdata_001p20.
18-Dec-13  P-20-44 rkumbhare  $$32  Added 039p20 and 040p20.
02-Jan-14  P-20-44 pdeshmuk   $$33  Added multibody001p20
09-Jan-14  P-20-45 rkumbhare  $$34  Added intfdata_002p20/ 003p20.
22-Jan-14  P-20-47 pkodre     $$35  Added multibody002p20
18-Feb-14  P-20-48  rkumbhare  $$36  Added intfdata_004p20.
28-Feb-14  P-20-48  pdeshmuk   $$37  Added Importfeat001p20
28-Feb-14  P-20-49  pkodre     $$38  Added multibody003p20
04-Mar-14 P-20-49  rkumbhare  $$39 Added 041p20.
10-Mar-14 P-20-49  rkumbhare  $$40 Added 042p20.
		   pkodre	   Added Importfeat002p20
10-Mar-14 P-20-49  pkodre     $$41 Added Importfeat004p20.
18-Mar-14 P-20-50  sbinawad   $$42 Added Importfeat003p20, ImportModel001p20
21-Mar-14 P-20-50  pkodre     $$43 Added 030p10.
27-Mar-14 P-20-51  rkumbhare  $$44  Added 043p20.
02-Apr-14 P-20-51  asingla    $$45  Added 044p20.
14-Apr-14 P-20-52  pkodre     $$46  Added ImportModel002p20.
22-Apr-14 P-20-52  pkodre     $$47  Added Importfeat005p20.
27-Apr-14 P-20-53  rkumbhare  $$48  Added 045p20.
07-May-14 P-20-53  rkumbhare  $$49  Added intfdata_005p20.
09-May-14 P-20-53  pkodre     $$50  Added UGExportImport_001p20.
02-June-14 P-20-54 asingla    $$51  Added 046p20
03-Sep-14  P-20-60 shkale     $$52  verified spr2193293
19-Nov-14  P-20-63 mrukshad   $$53  added 032p10
24-Mar-15  P-30-04 mrukshad   $$54 added 031p10 035p10
27-Mar-15  P-30-05 psakpal    $$55  Added for spr2244297.
26-Mar-15  P-30-05 sbinawad   $$56  added Importfeat006p20 and 034p10
01-Feb-16  P-30-25 pkumar     $$57  added 037p10
07-Apr-16  P-30-30 pkumar     $$58  Added sty4608307_01,sty4608307_02
23-May-16  P-30-32 sbinawad   $$59  Added slicefile_exportp30
31-May-16  P-30-32 pkumar     $$60  Added sty4608307_03p30
10-Jun-16  P-30-33 rjethwa    $$61  Added sty4608307_03
12-Jun-16  P-30-33 rjethwa    $$62  Added sty4608307_04
16-Jun-16  P-30-33 rjethwa    $$63  Added sty4608307_05
29-Jun-16  P-30-34 rjethwa    $$64  Added sty4608307_06, sty4608307_07
09-Aug-16  P-30-37 rkumbhare  $$65  Added 048p30.
24-Aug-16  P-30-38 isingh     $$66  Added 036p10.
06-Sept-16 P-30-39 achaudhary $$67  Added for SPR5765167.
15-Nov-16  P-30-41 achaudhary  $$68 Added for SPR5286270
22-Jun-17  P-50-14  isingh      $$69 Added for SPR6197629
13-Oct-17  P-50-34 rkothari   $$70 01p50
10-Nov-17  P-50-36 jtejaswi	  $$71  Added 048p20 for spr 6985933
12-Feb-18  P-50-48 shwdeshmukh  $$72 Added 049p20 for spr 2826563
27-Feb-18  P-50-48 shwdeshmukh  $$73 Added 051p30 for spr 5196159
29-Mar-18  P-50-49 shwdeshmukh  $$74 Added 053p20 for API ProIntfimportModelWithOptionsMdlnameCreate();
         		   yhatolkar         Added 052p20 for API ProIntf3DFileWriteWithDefaultProfile();
09-Apr-18  P-50-49 shwdeshmukh  $$75 Added 054p20 for API ProOutputAssemblyConfigurationIsSupported() & ProOutputBrepRepresentationIsSupported() for "PRO_INTF_EXPORT_3MF" file type.
19-Jun-18  P-60-07 shwdeshmukh  $$76 Added 055p50 for SPR 7368427
20-Aug-18  P-60-15 bbhagat	   $$77 Added 056p30  for spr 7373510
20-Sep-18  P-60-19 sbinawad    $$78  Added 057p30 for SPR 7636236 
23-Jan-19  P-60-31 sbinawad    $$79  Added 058p30
12-Jun-19  P-70-14 sbinawad    $$80  Added 059p70 for story 8396647
04-Jul-19  P-70-16 sbinawad    $$81  Added export001p60 for new export APIs (creo6 story 8405149)
06-Aug-19  P-70-22 sbinawad    $$82  Added 060p70 for story 8346348
18-Sep-19  P-70-28 sbinawad    $$83  Added 061p70 for story 7759858
25-Sep-19  P-70-28 sbinawad    $$84  Added 062p70 for story 8827660
02-Dec-19  P-70-36 rakerkar    $$85  Added export002p60_01, export002p60_02 for SPR 8013557
21-Jan-20  P-70-43 vsubbaia    $$86  Added 063p70 for story 9634530
04-Feb-20  P-70-44 sbinawad    $$87  Added 064p70, 065p70, 066p70 for story 9634546
21-Apr-20  P-80-01 ychavhan	   $$88	 Added 059p30 for spr9910268
26-May-20	P-80-05	sshrivastava	$$89	Added 001p60 for spr10056230
10-Jul-20  P-80-11 sbinawad    $$90  Added 061p30, 062p30 for story 10134643
10-Jul-20  P-80-12 sbinawad    $$91  Added 063p30, 064p30 for story 10134646
28-Jul-20  P-80-14 sbinawad    $$92  Added 067p70 for GMB ATB
11-Sep-20  P-80-20 sbinawad    $$93  Added 068p70 for SPR 10214122
07-Jan-21  P-80-35 sbinawad    $$94  Added 065p30 for SPR 11206426
11-May-21  P-90-08 skankarej   $$95  Added 069p70 for spr11276538
20-Jul-21  P-90-18 sbinawad   $$96  Replaced deprecated API from doc
13-Dec-21  P-90-38 cmandke     $$97 Added 070p70 for spr13305893
13-Jun-23  Q-11-16 sbinawad    $$98  Added 071q10 for SPR 14510008
07-Jul-23  Q-11-19 sbinawad    $$99  Added 071p80 for SPR 14634213
10-Oct-23  Q-11-33 sbinawad    $$100  Added 072q11 for story 14843886 
11-Jan-24  Q-11-46 aphatak     $$101  Added 073q11 for story 15040984 
18-Apr-24  Q-12-09 sbinawad    $$102  Added 074q12 for story 15277024
13-Jun-24  Q-12-16 sbinawad    $$103  Added 01q10, 02q10 for stories Added reg for CED stories 15186421, 15429199
18-Nov-24  Q-12-39 sbinawad    $$104  Added 075q12 for story 15816913
06-Feb-25  Q-12-50	sashtagi   $$105  Added 001p90 for spr15820632
10-Feb-25  Q-12-51  sarsewar   $$106  Added 074q11 for spr15893357
*/  

#define OTK_INTF3D(ID) OTK_TEST_FUNC(intf3d, ID)
#define OTK_INTF3D_ENTRY(ID, DESC) OTK_TEST_ENTRY(intf3d, ID, DESC)


ProError OtkTIntf3D_001 (int, char*[], char*, char*, wchar_t[]);
ProError OtkTIntf3D_002 (int, char*[], char*, char*, wchar_t[]);
ProError OtkTIntf3D_003 (int, char*[], char*, char*, wchar_t[]);
OTK_INTF3D(001)
OTK_INTF3D(002)
OTK_INTF3D(003)
OTK_INTF3D(004)
OTK_INTF3D(005)
OTK_INTF3D(006)
OTK_INTF3D(007)
OTK_INTF3D(008)
OTK_INTF3D(009)
OTK_INTF3D(010)
OTK_INTF3D(011)
OTK_INTF3D(012)
OTK_INTF3D(013)
OTK_INTF3D(014)
OTK_INTF3D(015)
OTK_INTF3D(016)
OTK_INTF3D(017)
OTK_INTF3D(018)
OTK_INTF3D(019)
OTK_INTF3D(020)
OTK_INTF3D(021p10)
OTK_INTF3D(022p10)
OTK_INTF3D(023p10)
OTK_INTF3D(024p10)
OTK_INTF3D(025p10)
OTK_INTF3D(026p20)
OTK_INTF3D(027p20)
OTK_INTF3D(028p20)
OTK_INTF3D(031p20)
OTK_INTF3D(027p10)
OTK_INTF3D(029p20)
OTK_INTF3D(030p20)
OTK_INTF3D(032p20)
OTK_INTF3D(033p20)
OTK_INTF3D(034p20)
OTK_INTF3D(028p10)
OTK_INTF3D(035p20)
OTK_INTF3D(036p20)
OTK_INTF3D(037p20)
OTK_INTF3D(038p20)
OTK_INTF3D(029p10)
OTK_INTF3D(intfdata_001p20)
OTK_INTF3D(039p20)
OTK_INTF3D(040p20)
OTK_INTF3D(041p20)
OTK_INTF3D(042p20)
OTK_INTF3D(043p20)
OTK_INTF3D(044p20)
OTK_INTF3D(045p20)
OTK_INTF3D(046p20)
OTK_INTF3D(050p30)
OTK_INTF3D(multibody001p20)
OTK_INTF3D(intfdata_002p20)
OTK_INTF3D(intfdata_003p20)
OTK_INTF3D(multibody002p20)
OTK_INTF3D(intfdata_004p20)
OTK_INTF3D(intfdata_005p20)
OTK_INTF3D(Importfeat001p20)
OTK_INTF3D(multibody003p20)
OTK_INTF3D(Importfeat002p20)
OTK_INTF3D(Importfeat003p20)
OTK_INTF3D(Importfeat004p20)
OTK_INTF3D(ImportModel001p20)
OTK_INTF3D(030p10)
OTK_INTF3D(ImportModel002p20)
OTK_INTF3D(Importfeat005p20)
OTK_INTF3D(Importfeat006p20)
OTK_INTF3D(UGExportImport_001p20)
OTK_INTF3D(047p20)
OTK_INTF3D(032p10)
OTK_INTF3D(031p10)
OTK_INTF3D(034p10)
OTK_INTF3D(035p10)
OTK_INTF3D(033p10)
OTK_INTF3D(037p10)
OTK_INTF3D(sty4608307_01)
OTK_INTF3D(sty4608307_02)
OTK_INTF3D(slicefile_exportp30)
OTK_INTF3D(sty4608307_03p30)
OTK_INTF3D(sty4608307_03)
OTK_INTF3D(sty4608307_04)
OTK_INTF3D(sty4608307_05)
OTK_INTF3D(sty4608307_06)
OTK_INTF3D(sty4608307_07)
OTK_INTF3D(048p30)
OTK_INTF3D(036p10)
OTK_INTF3D(038p10)
OTK_INTF3D(sty4608307_08)
OTK_INTF3D(01p50)
OTK_INTF3D(048p20)
OTK_INTF3D(049p20)
OTK_INTF3D(051p30)
OTK_INTF3D(052p20)
OTK_INTF3D(053p20)
OTK_INTF3D(054p20)
OTK_INTF3D(055p50)
OTK_INTF3D(056p30)
OTK_INTF3D(057p30)
OTK_INTF3D(058p30)
OTK_INTF3D(059p30)
OTK_INTF3D(059p70)
OTK_INTF3D(export001p60)
OTK_INTF3D(060p70)
OTK_INTF3D(061p70)
OTK_INTF3D(062p70)
OTK_INTF3D(export002p60)
OTK_INTF3D(063p70)
OTK_INTF3D(064p70)
OTK_INTF3D(065p70)
OTK_INTF3D(066p70)
OTK_INTF3D(001p60)
OTK_INTF3D(061p30)
OTK_INTF3D(062p30)
OTK_INTF3D(063p30)
OTK_INTF3D(064p30)
OTK_INTF3D(065p30)
OTK_INTF3D(067p70)
OTK_INTF3D(068p70)
OTK_INTF3D(069p70)
OTK_INTF3D(070p70)
OTK_INTF3D(071q10)
OTK_INTF3D(071p80)
OTK_INTF3D(072q11)
OTK_INTF3D(073q11)
OTK_INTF3D(074q12)
OTK_INTF3D(01q10)
OTK_INTF3D(02q10)

OTK_INTF3D(075q12)
OTK_INTF3D(001p90)
OTK_INTF3D(074q11)


struct otk_test_with_id otk_intf3d_tests [] = {
  {"001", OtkTIntf3D_001, "Testing ProIntfimportModelWithOptionsMdlnameCreate"},
  {"002", OtkTIntf3D_002, "Testing ProIntfimportModelWithOptionsMdlnameCreate for Unigraphics"},
  {"003", OtkTIntf3D_003, "Testing ProDatumcurveFromfileCreate for Unigraphics"},
  OTK_INTF3D_ENTRY(004, "Testing CoCreate .mi files import"),
  OTK_INTF3D_ENTRY(005, "Testing CoCreate .mi files import as append"),
  OTK_INTF3D_ENTRY(006, "Testing CoCreate 3D files import "),
  OTK_INTF3D_ENTRY(007, "Testing OTK example - Raster export "),
  OTK_INTF3D_ENTRY(008, "Testing CoCreate 3D files import "),
  OTK_INTF3D_ENTRY(009, "Testing SliceExport:With Step Size & FacetControlBitFlags"),
  OTK_INTF3D_ENTRY(010, "Testing negative cases for ATB models"),
  OTK_INTF3D_ENTRY(011, "Splitting test from ptn_importfeatfromfile"),
  OTK_INTF3D_ENTRY(012, "Splitting test from ptn_importfeatfromfile"),
  OTK_INTF3D_ENTRY(013, "Testing functional cases for ATB models"),
  OTK_INTF3D_ENTRY(014, "Testing functional cases for Quick Print for OTK"),
  OTK_INTF3D_ENTRY(015, "Testing functional cases for Quick Print for OTK"),
  OTK_INTF3D_ENTRY(016, "Testing functional cases for Quick Print for OTK"),
  OTK_INTF3D_ENTRY(017, "Testing functional cases for Quick Print for OTK"),
  OTK_INTF3D_ENTRY(018, "Testing negative cases for Quick Print for OTK"),
  OTK_INTF3D_ENTRY(019, "Testing functional cases for ImportAsFeat for OTK"),
  OTK_INTF3D_ENTRY(020, "Testing functional cases for ImportAsFeat for OTK"),
  OTK_INTF3D_ENTRY(021p10, "Testing functional cases for ImportAsModel for OTK"),
  OTK_INTF3D_ENTRY(022p10, "Testing functional cases for ATB/TIM APIs in OTK"),
  OTK_INTF3D_ENTRY(023p10, "Testing functional/negative cases of ProDatumcurveFromfileCreate"),
  OTK_INTF3D_ENTRY(024p10, "Splitting test from ptn_importfeatfromfile"),
  OTK_INTF3D_ENTRY(025p10, "Negative test for ProATBUpdated")
  , OTK_INTF3D_ENTRY(026p20, "Testing for creo3 intf3d import projects")
  , OTK_INTF3D_ENTRY(027p20, "Testing for creo3 intf3d export projects")
  , OTK_INTF3D_ENTRY(028p20, "Testing for creo3 intf3d import")
  , OTK_INTF3D_ENTRY(027p10, "Test case for SPR2127779")
  , OTK_INTF3D_ENTRY(029p20, "Testing for creo3 intf3d import for SolidWorks ATB feat")
  , OTK_INTF3D_ENTRY(030p20, "Testing for creo3 CoCreate import projects")
  , OTK_INTF3D_ENTRY(031p20, "Testing of .mi projects")
  , OTK_INTF3D_ENTRY(032p20, "Testing of .mi projects")
  , OTK_INTF3D_ENTRY(033p20, "Testing of ugnx export project")  
  , OTK_INTF3D_ENTRY(034p20, "Testing CV import improvement project")
  , OTK_INTF3D_ENTRY(028p10, "Created test case for SPR2173715 and SPR2174606")
  , OTK_INTF3D_ENTRY(035p20, "Testing wfcIntfInventorAsm/Part ")
  , OTK_INTF3D_ENTRY(036p20, "Testing JT export cases ")
  , OTK_INTF3D_ENTRY(037p20, "Testing Inventor layer visibility cases ")
  , OTK_INTF3D_ENTRY(038p20, "Testing unit setting while import cases ")
  ,OTK_INTF3D_ENTRY(029p10, "Created test case for SPR2187594")
  ,OTK_INTF3D_ENTRY(intfdata_001p20, "intfdata regtest")
  , OTK_INTF3D_ENTRY(039p20, "Testing SolidEdge import cases ")
  , OTK_INTF3D_ENTRY(040p20, "Testing SolidWorks export/import cases ")
  , OTK_INTF3D_ENTRY(multibody001p20, "Importing multibody part as PRO_MDL_UNUSED")
  ,OTK_INTF3D_ENTRY(intfdata_002p20, "intfdata regtest")
  ,OTK_INTF3D_ENTRY(intfdata_003p20, "creating sphere from intfdata regtest")
  , OTK_INTF3D_ENTRY(multibody002p20, "Test case for SPR2207137")
  ,OTK_INTF3D_ENTRY(intfdata_004p20, "intfdata regtest")  
  ,OTK_INTF3D_ENTRY(Importfeat001p20, "Tests ProImportfeatWithProfileCreate using non-NULL profile")
  , OTK_INTF3D_ENTRY(multibody003p20, "Test case for SPR2203571")
  ,OTK_INTF3D_ENTRY(041p20, "Testing CatiaProduct export/import cases")
  ,OTK_INTF3D_ENTRY(042p20, "Testcase for SPR2173086 - CV assembly color export-import")
  ,OTK_INTF3D_ENTRY(043p20, "Testcase for SPR2193029 - Jt export-import")
  ,OTK_INTF3D_ENTRY(044p20, "Testcase for SPR 2164486")
  ,OTK_INTF3D_ENTRY(045p20, "Testcase for SPR 2220389")
  ,OTK_INTF3D_ENTRY(046p20, "Testcase for SPR 2219172")
  ,OTK_INTF3D_ENTRY(Importfeat002p20, "Negative testing of ProImportfeatWithProfileCreate and ProImportfeatCreate")
  ,OTK_INTF3D_ENTRY(Importfeat003p20, "Testing ProImportfeatWithProfileCreate and ProImportfeatCreate")
  ,OTK_INTF3D_ENTRY(Importfeat004p20, "Negative testing of ProImportfeatWithProfileCreate and ProImportfeatCreate")
  ,OTK_INTF3D_ENTRY(intfdata_005p20, "Added for SPR ")
  ,OTK_INTF3D_ENTRY(ImportModel001p20, "Testing ProIntfimportModelWithOptionsMdlnameCreate")
  ,OTK_INTF3D_ENTRY(030p10, "Created test case for SPR2213246")
  ,OTK_INTF3D_ENTRY(ImportModel002p20, "Negative testing of ProIntfimportModelWithOptionsMdlnameCreate")
  ,OTK_INTF3D_ENTRY(Importfeat005p20, "Tests ProImportfeatWithProfileCreate using non-NULL profile")
  ,OTK_INTF3D_ENTRY(UGExportImport_001p20, "Export UG file via CCE")
  ,OTK_INTF3D_ENTRY(047p20, "Testcase for SPR 2193293")
  ,OTK_INTF3D_ENTRY(032p10, "Created test case for SPR2195275")
  ,OTK_INTF3D_ENTRY(Importfeat006p20, "Tests ImportAsFeat on SEdge (.par and .psm)")
  ,OTK_INTF3D_ENTRY(031p10, "Tetsing  ProImportfeatCreate SPR 2254131")
  ,OTK_INTF3D_ENTRY(034p10, "Tetsing multi sheet DXF export for SPR 2161875")  
  ,OTK_INTF3D_ENTRY(035p10, "Tetsing  ProImportfeatWithProfileCreate SPR 2254131")
  ,OTK_INTF3D_ENTRY(033p10, "Created test case for SPR2244297")
  ,OTK_INTF3D_ENTRY(037p10, "Created test case for SPR 5161053")
  ,OTK_INTF3D_ENTRY(sty4608307_01, "Created test case for ProImportfeatWithProfileCreate Api ")
  ,OTK_INTF3D_ENTRY(sty4608307_02, "Created test case for ProIntf3DFileWriteWithDefaultProfile Api ")
  ,OTK_INTF3D_ENTRY(slicefile_exportp30, "Testing API ProIntfSliceFileWithOptionsMdlnameExport for PRO_AMF_FILE")
  ,OTK_INTF3D_ENTRY(sty4608307_03p30, "Created test case for spr5277104 ")
  ,OTK_INTF3D_ENTRY(sty4608307_03, "Test for new Creo 4.0 API")
  ,OTK_INTF3D_ENTRY(sty4608307_04, "Test for new Creo 4.0 API")
  ,OTK_INTF3D_ENTRY(sty4608307_05, "Test for new Creo 4.0 API")
  ,OTK_INTF3D_ENTRY(sty4608307_06, "Test for new Creo 4.0 API")
  ,OTK_INTF3D_ENTRY(sty4608307_07, "Test for new Creo 4.0 API")
  ,OTK_INTF3D_ENTRY(048p30, "Testing import validation APIs")
  ,OTK_INTF3D_ENTRY(036p10, "Testcase for SPR4976188 APIs")
  ,OTK_INTF3D_ENTRY(038p10, "Testcase for SPR5765167")
  ,OTK_INTF3D_ENTRY(sty4608307_08, "Created test case for spr5286270 ")
  ,OTK_INTF3D_ENTRY(050p30, "Testcase for SPR6197629")
  ,OTK_INTF3D_ENTRY(01p50, "Testcase for Story 7021029")
  ,OTK_INTF3D_ENTRY(048p20, "Test case for SPR 6985933")
  ,OTK_INTF3D_ENTRY(049p20, "Test case for SPR 2826563")
  ,OTK_INTF3D_ENTRY(051p30, "Test case for SPR 5196159")
  ,OTK_INTF3D_ENTRY(052p20, "Test case for API ProIntf3DFileWriteWithDefaultProfile()")
  ,OTK_INTF3D_ENTRY(053p20, "Test case for API ProIntfimportModelWithOptionsMdlnameCreate()")
  ,OTK_INTF3D_ENTRY(054p20, "Test case for for API ProOutputAssemblyConfigurationIsSupported() & ProOutputBrepRepresentationIsSupported() for PRO_INTF_EXPORT_3MF file type")
  ,OTK_INTF3D_ENTRY(055p50, "Test case for SPR 7368427")
  ,OTK_INTF3D_ENTRY(056p30, "Test case for SPR 7373510")
  ,OTK_INTF3D_ENTRY(057p30, "Test case for SPR 7636236")
  ,OTK_INTF3D_ENTRY(058p30, "Test for API ExportIntf3D ie ProIntf3DFileWriteWithDefaultProfile")
  ,OTK_INTF3D_ENTRY(059p70,"Added for JT multibody story 8396647")
  ,OTK_INTF3D_ENTRY(export001p60, "Test for new export API for creo7 story 8405149")
  ,OTK_INTF3D_ENTRY(060p70, "Added for GMB story 8346348")
  ,OTK_INTF3D_ENTRY(061p70, "Added for GMB story 7759858")
  ,OTK_INTF3D_ENTRY(062p70, "Added for GMB story 8827660")
  ,OTK_INTF3D_ENTRY(export002p60, "Testcase for SPR 8013557")
  ,OTK_INTF3D_ENTRY(063p70, "Added for GMB story 9634530")
  ,OTK_INTF3D_ENTRY(064p70, "Added for GMB story 9634546 of import feat create")
  , OTK_INTF3D_ENTRY(065p70, "Added for GMB story 9634546 for nagative test cases")
  , OTK_INTF3D_ENTRY(066p70, "Added for GMB story 9634546 for import feat and redefine")
  ,OTK_INTF3D_ENTRY(059p30, "Test case for SPR 9910268" )
  , OTK_INTF3D_ENTRY(001p60, "Test for SPR 10056230")
  ,OTK_INTF3D_ENTRY(061p30, "Test for API ProIntfExportProfileLoad, story 10134643")
  ,OTK_INTF3D_ENTRY(062p30, "Test for API ProIntfExportProfileLoad, story 10134643")
  ,OTK_INTF3D_ENTRY(063p30, "Test for OTK API ExportProfileLoad, story 10134646")
  ,OTK_INTF3D_ENTRY(064p30, "Test for OTK API ExportProfileLoad on CV file, story 10134646")
  ,OTK_INTF3D_ENTRY(067p70, "Test for GMB ATB creo7 stories 9911440, 9911441, 9911442, 9908457, 9911668")
  , OTK_INTF3D_ENTRY(068p70, "Added for SPR 10214122")
  , OTK_INTF3D_ENTRY(065p30, "Test for SPR 11206426")
  , OTK_INTF3D_ENTRY(069p70, "Test for SPR 11276538")
  , OTK_INTF3D_ENTRY(070p70, "Test for SPR 13305893")
  , OTK_INTF3D_ENTRY(071q10, "Test for SPR 14510008")
  , OTK_INTF3D_ENTRY(071p80, "Test for SPR 14634213")
  , OTK_INTF3D_ENTRY(072q11, "Test for story 14843886")
  , OTK_INTF3D_ENTRY(073q11, "Test for story 15040984 - readonly model API tests")
  , OTK_INTF3D_ENTRY(074q12, "Test for story 15277024 -Enhancement in importing STEP asm to multibody part")
  , OTK_INTF3D_ENTRY(01q10, "Test for CED ATB story 15186435")
  , OTK_INTF3D_ENTRY(02q10, "Test for CED story 15429247")
  , OTK_INTF3D_ENTRY(075q12, "Test for STEP story 15816913")
  , OTK_INTF3D_ENTRY(001p90, "Test for SPR 15820632")
    , OTK_INTF3D_ENTRY(074q11, "Test for SPR 15893357")
  };

#endif /* OTK_INTF3D_TESTS_H */
