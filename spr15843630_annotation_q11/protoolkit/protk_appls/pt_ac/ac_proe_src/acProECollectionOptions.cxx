/**
 * @file
 *
 * Represents Pro/E tools to enable collection of groups of annotations.
 *
 * 12-NOV-07  JCN   L-01-41  $$1  First submitted version.
 * 19-NOV-07  JCN   L-01-41  $$2  Make sure all collected annotations are
 *                                convertible.  
 * 12-APR-08  SDJ   L-03-19  $$3  Added symbol support
 * 24-APR-08  SDJ   L-03-19  ""  Fixes for 1463919, 1465836.
 * 08-MAY-08 gshmelev L-03-19 "" included ProDtlnote_int.h
 * 03-Jun-08  SMB   L-03-19  ""  Updated for SPR1464622
 * 24-JUL-08  SDJ   L-03-19  ""  Fixes for 1468844.
 * 14-APR-11  SDJ   L-05-46  $$4  Fixes for 2054377.
 * 05-MAY-11  SDJ   L-05-46  $$5  Fix for 2070090.
 * 17-Apr-12  rkothari P-12-04 $$6  Fix for SPR 2078738,1464058,1464287
 * 27-Apr-12  rkothari P-20-03 $$7 Fixed typo made by $$6
 * 18-Nov-13  pdeshmuk P-20-43 $$8  Updated for THA 
 * 22-Dec-17  rkothari P-50-42 $$9 Fix SPR 6907213 + Additional check
 * 24-May-23  rkothari Q-11-13 $$10 ply view changes.
 * 07-Apr-25  cmandke  Q-11-57 $$11 Fix for SPR 15843630.
 */

using namespace std;

#include <vector>
#include <algorithm>

#include <acProECollectionOptions.h>
#include <acProEGtol.h>
#include <acProENote.h>
#include <acProESymbol.h>
#include <acProEDimension.h>
#include <acProESetDatumTag.h>
#include <acProESurfaceFinish.h>

#include <ProToolkit.h>
#include <ProSelection.h>
#include <ProDtlnote.h>
#include <ProDrawing.h>
#include <ProGeomitem.h>
#include <ProSetDatumTag.h>
#include <ProAxis.h>
#include <ProLayer.h>
#include <ProSolid.h>
#include <ProRule.h>
#include <ProDtlnote_int.h>

/*===========================================================================*/
struct acProEGtolCollectionData
{
	ProDrawing drawing;
	int sheet;
	ProView filterView;
	acProELayerFilter* layerFilter;
	acAnnotationVector* v;
};

/*===========================================================================*/
struct acProEDtlnoteCollectionData
{
	ProView filterView;
	acProELayerFilter* layerFilter;
	acAnnotationVector* v;
};

/*===========================================================================*/
struct acProESetDatumTagCollectionData
{
	ProSolid currentSolid;
	ProGeomitem* geomitems;
	acProELayerFilter* layerFilter;
	acAnnotationVector* v;
};

/*===========================================================================*/
struct acProEDrawingDimCollectionData
{
	ProView filterView;
	acProELayerFilter* layerFilter;
	acAnnotationVector* v;
};

/*===========================================================================*/
struct acProEShownDimCollectionData
{
	ProDrawing drawing;
	ProView filterView;
	ProType type;
	ProSolid* visitedComponents;
	acProELayerFilter* layerFilter;
	acAnnotationVector* v;
};
/*===========================================================================*/
struct acProESymbolCollectionData
{
	ProView filterView;
	acProELayerFilter* layerFilter;
	acAnnotationVector* v;
};

/*===========================================================================*/
extern "C" ProError acProEGtolCollectFilter (ProGtol* gtol, ProAppData data)
{
	ProError status;
	ProBoolean shown;
	acProEGtolCollectionData* collData = (acProEGtolCollectionData*)data;

	status = ProAnnotationIsShown (gtol, collData->drawing, &shown);

	if (status == PRO_TK_NO_ERROR && shown)
	{
		if (collData->layerFilter == 0 || 
			collData->layerFilter->includeAnnotation (collData->drawing, gtol))
			return PRO_TK_NO_ERROR;
	}
	
	return PRO_TK_CONTINUE;
}

/*===========================================================================*/
extern "C" ProError acProEGtolCollectAction (ProGtol* gtol, ProError errStatus, ProAppData data)
{
	ProError status;
	ProSelection gtolSel;
	acProEGtolCollectionData* collData = (acProEGtolCollectionData*)data;
	ProDtlnote dtlNote;
	ProDtlnotedata noteData;
	ProDtlattach attach;
	ProDtlattachType type;
	ProView view;
	ProVector location;
	ProSelection attachment;
	int sheet;

	status = ProGtolDtlnoteGet (gtol, collData->drawing, &dtlNote);

	status = ProDtlnoteDataGet (&dtlNote, 0, PRODISPMODE_NUMERIC, &noteData);

	status = ProDtlnotedataAttachmentGet (noteData, &attach);

	status = ProDtlattachGet (attach, &type, &view, location, &attachment);
	bool isPlyView = acProEDrawing::isPlyView((ProDrawing)gtol->owner, view);
	if (isPlyView == true)
		return PRO_TK_NO_ERROR;

	if (collData->filterView == 0 || collData->filterView == view)
	{
		status = ProDrawingViewSheetGet (collData->drawing, view, &sheet);

		if (collData->sheet < 0 || sheet == collData->sheet)
		{
			status = ProSelectionAlloc (0, gtol, &gtolSel);

			if (view != 0)
			{
				status = ProSelectionViewSet (view, &gtolSel);
				logTKCall ("ProSelectionViewSet", status);
			}

			writeSelectionViewOwner (gtolSel);

			acProEGtol* a = new acProEGtol (gtolSel);
			if (a->canConvertToModelOwned())
				collData->v->push_back (a);

			ProSelectionFree (&gtolSel);
		}
	}
	ProDtlnotedataFree (noteData);
	
	return PRO_TK_NO_ERROR;
}

/*===========================================================================*/
extern "C" ProError acProEDtlnoteCollectFilter (ProDtlnote* dtlNote, ProAppData data)
{
	ProError status;
	ProBoolean shown;
	ProGtol gtol;
	ProError returnVal = PRO_TK_CONTINUE;
	ProDtlnotedata dtlNoteData;
	acProEDtlnoteCollectionData* noteCollectData = (acProEDtlnoteCollectionData*)data;
	ProBoolean isDisplayed;
	ProDtlattach attach, *attach_ldr;
	ProDtlattachType type, type_ldr;
	ProView view, view_ldr;
	ProVector location, location_ldr;
	ProSelection attachment, attachment_ldr;
	ProBoolean is_free, is_bom_balloon;
	ProMdl drawing;
	ProName view_names [2];
	int arr_size = 0, cmp_result;

	status = ProDtlnoteDataGet (dtlNote, 0, PRODISPMODE_NUMERIC, &dtlNoteData);
	
	status = ProMdlCurrentGet (&drawing);

	if (status == PRO_TK_NO_ERROR)
	{

	  status = ProDtlnoteIsFree(dtlNote, (ProDrawing)drawing, &is_free);

	  if(is_free)
	    {
	      ACLOG << "Skipping note id " << dtlNote->id << " because it is free" << endl;
	      return PRO_TK_CONTINUE;
	    }
	}

	status = ProDtlnoteIsBomBalloon(dtlNote, &is_bom_balloon);
	if(is_bom_balloon)
	  {
	    ACLOG << "Skipping note id " << dtlNote->id << " because it is a bom balloon" << endl;
	    return PRO_TK_CONTINUE;
	  }

	//Fix for 1469745
	//filter out notes whose attachment type is OFFSET
	status = ProDtlnotedataAttachmentGet(dtlNoteData, &attach);

	status = ProDtlattachGet (attach, &type, &view, location, &attachment);
	bool isPlyView = acProEDrawing::isPlyView((ProDrawing)dtlNote->owner, view);
	if (isPlyView == true)
	{
		ACLOG << "Skipping note id " << dtlNote->id << " because it is ply view" << endl;
		return PRO_TK_CONTINUE;
	}

	if (type == PRO_DTLATTACHTYPE_OFFSET)
	{
		ACLOG << "Skipping note id " << dtlNote->id << " because it is an offset note" << endl;
		return PRO_TK_CONTINUE;
	}

	//Fix for 1468844
	//filter out notes which reference more than one view.

	status = ProDtlnotedataLeadersCollect(dtlNoteData, &attach_ldr);
	status = ProArraySizeGet(attach_ldr, &arr_size);

	if(arr_size > 1)
	{
		for(int i = 0; i < arr_size; i++)
		{
			status = ProDtlattachGet(attach_ldr[i], &type_ldr, &view_ldr, location_ldr, &attachment_ldr);

			status = ProSelectionViewGet(attachment_ldr, &view_ldr);

			status = ProDrawingViewNameGet((ProDrawing)drawing, view_ldr, view_names[1]);
			
			if(status == PRO_TK_NO_ERROR)
			{
				if(i == 0)
					status  = ProWstringCopy(view_names[1], view_names[0], PRO_VALUE_UNUSED);

				status  = ProWstringCompare(view_names[0], view_names[1], PRO_VALUE_UNUSED, &cmp_result);	

				if(cmp_result != 0)
				{
					ACLOG << "Skipping note id " << dtlNote->id << " because it references more than 1 view" << endl;
					return PRO_TK_CONTINUE;
				}

			}
		}
	}

	status = ProDtlnotedataIsDisplayed (dtlNoteData, &isDisplayed);
	if (isDisplayed == PRO_B_TRUE)
	{
		gtol.id = PRO_VALUE_UNUSED;
		status = ProDtlnoteGtolGet (dtlNote, &gtol);
		if (status != PRO_TK_NO_ERROR)
		{
			if (noteCollectData->layerFilter == 0 || 
				noteCollectData->layerFilter->includeAnnotation ((ProDrawing)dtlNote->owner,
																dtlNote))
			{
				ACLOG << "Note id " << dtlNote->id << " marked for conversion." << endl;
					returnVal = PRO_TK_NO_ERROR;
			}
			else
			{
				ACLOG << "Skipping note id " << dtlNote->id << " because it is on a layer that is not marked for conversion." << endl;
			}
		}
		else
		{
			//TODO? add the gtols contained in the note to the collector?
		}
	}
	else
	{
		ACLOG << "Skipping note id " << dtlNote->id << " because it is not displayed. " << endl;
	}
	ProDtlnotedataFree (dtlNoteData);

	return (returnVal);
}

/*===========================================================================*/
extern "C" ProError acProEDtlnoteCollectAction (ProDtlnote* dtlNote, ProError errStatus, ProAppData data)
{
	ProError status;
	ProSelection noteSel;
	acProEDtlnoteCollectionData* noteCollectData = (acProEDtlnoteCollectionData*)data;
	ProDtlnotedata noteData;
	ProDtlattach attach;
	ProDtlattachType type;
	ProView view;
	ProVector location;
	ProSelection attachment;

	status = ProDtlnoteDataGet (dtlNote, 0, PRODISPMODE_NUMERIC, &noteData);

	status = ProDtlnotedataAttachmentGet (noteData, &attach);

	status = ProDtlattachGet (attach, &type, &view, location, &attachment);

	/* For parametric/offset attachments the view is contained inside the attachment selection. */
	if (type == PRO_DTLATTACHTYPE_PARAMETRIC || type == PRO_DTLATTACHTYPE_OFFSET)
	{
		status = ProSelectionViewGet (attachment, &view);
	}

	if (noteCollectData->filterView == 0 || noteCollectData->filterView == view)
	{
		status = ProSelectionAlloc (0, dtlNote, &noteSel);

		if (view != 0)
		{
			status = ProSelectionViewSet (view, &noteSel);

			writeSelectionViewOwner (noteSel);

			acProENote* a = new acProENote (noteSel);
			if (a->canConvertToModelOwned())
				noteCollectData->v->push_back (a);

			ProSelectionFree (&noteSel);
		}	
	}
	ProDtlnotedataFree (noteData);

	return PRO_TK_NO_ERROR;
}

/*===========================================================================*/
extern "C" ProError acProEFindAxisSetDatumAction (ProAxis axis, ProError filter_status, ProAppData data)
{
	acProESetDatumTagCollectionData* setDatumTagData = (acProESetDatumTagCollectionData*)data;
	ProGeomitem item, surf_item;
	ProBoolean inactive;
	ProBoolean set;
	ProGtolsetdatumValue value;
	ProError status;
	ProSurface surface;

	status = ProAxisToGeomitem (setDatumTagData->currentSolid, axis, &item);

	ACLOG << "Visit axis " << item.id << endl;

	if (status == PRO_TK_NO_ERROR)
	{
		status = ProGeomitemIsInactive (&item, &inactive);
		if (status == PRO_TK_NO_ERROR && !inactive)
		{
			ACLOG << "Axis is active" << endl;
	
			status = ProGeomitemSetdatumGet (&item, &set, &value);
			
			if (status == PRO_TK_NO_ERROR && set)
			{
				ACLOG << "Axis is Set datum" << endl;
				status = ProArrayObjectAdd ((ProArray*)&setDatumTagData->geomitems,
											-1, 1, &item);
			}
		}
	}
	return PRO_TK_NO_ERROR;
}

/*===========================================================================*/
extern "C" ProError acProEFindPlaneSetDatumAction (ProFeature* feat, ProError filter_status, ProAppData data)
{
	acProESetDatumTagCollectionData* setDatumTagData = (acProESetDatumTagCollectionData*)data;
	ProGeomitem item;
	ProSurface surface;
	ProBoolean isPlane;
	ProBoolean inactive;
	ProBoolean set;
	ProGtolsetdatumValue value;
	ProError status;

	item.owner = feat->owner;
	item.type = PRO_SURFACE;
	item.id = feat->id+1;

	status = ProGeomitemToSurface (&item, &surface);
	ACLOG << "Visit surface " << item.id << endl;

	if (status == PRO_TK_NO_ERROR)
	{
		status = ProSurfaceIsDatumPlane ((ProSolid)feat->owner, surface, &isPlane);
	
		if (isPlane)
		{
			ACLOG << "Visit surface " << item.id << endl;
			ACLOG << "Plane is datum" << endl;
			status = ProGeomitemIsInactive (&item, &inactive);

			if (status == PRO_TK_NO_ERROR && !inactive)
			{
				ACLOG << "Plane is active" << endl;
				item.type = PRO_DATUM_PLANE;
				status = ProGeomitemSetdatumGet (&item, &set, &value);

				if (set)
				{
					ACLOG << "Plane is Set datum" << endl;
					status = ProArrayObjectAdd ((ProArray*)&setDatumTagData->geomitems,
											-1, 1, &item);
				}
		
			}
		}
	}
	return PRO_TK_NO_ERROR;
}

/*===========================================================================*/
extern "C" ProError acProESetDatumTagCollectAction (ProDrawing drawing, ProView view, ProError filter_status, ProAppData data)
{
	acProESetDatumTagCollectionData* setDatumTagData = (acProESetDatumTagCollectionData*)data;
	ProSelection selSetDatum;
	ProGeomitem item;
	int numItems;
	int i;
	ProViewItemdisplayStatus dispStatus;
	ProError status;

	status = ProSelectionAlloc (0, 0, &selSetDatum);

	status = ProArraySizeGet (setDatumTagData->geomitems, &numItems);

	for (i = 0; i < numItems; i++)
	{
		memcpy (&item, &setDatumTagData->geomitems [i], sizeof (ProGeomitem));

		status = ProSelectionSet (selSetDatum, 0, &item);
		logTKCall ("ProSelectionSet", status);

		ACLOG << "Geomitem id " << setDatumTagData->geomitems [i].id << endl;

		/* It doesn't work: ProDrawingViewDatumdisplayGet SPR 992633 */
		status = ProDrawingViewDatumdisplayGet (drawing, view, selSetDatum, &dispStatus);
		logTKCall ("ProDrawingViewDatumdisplayGet", status);
		
		if (status == PRO_TK_NO_ERROR)
		{
			ACLOG << "Display status " <<  dispStatus << endl;
/*
			if (dispStatus == PRO_VIEWDISP_SHOWN)
			{
			*/
				acProESetDatumTag* a = new acProESetDatumTag (selSetDatum);

				if (a->canConvertToModelOwned())
					setDatumTagData->v->push_back (a);
				/*
			}
			*/
		}
	}
	ProSelectionFree (&selSetDatum);

	return PRO_TK_NO_ERROR;
}

/*===========================================================================*/
extern "C" ProError acProEDrawingDimCollectFilter (ProDimension* dim, 
											ProAppData data)
{
	acProEDrawingDimCollectionData* dimCollectData = (acProEDrawingDimCollectionData*)data;

	if (dimCollectData->layerFilter == 0 || 
		dimCollectData->layerFilter->includeAnnotation ((ProDrawing)dim->owner, dim))
			return PRO_TK_NO_ERROR;
	else
		return PRO_TK_CONTINUE;
}

/*===========================================================================*/
extern "C" ProError acProEDrawingDimCollectAction (ProDimension* dim, ProError filter_status, 
											ProAppData data)
{
	ProSelection selDim;
	acProEDrawingDimCollectionData* dimCollectData = (acProEDrawingDimCollectionData*)data;
	ProError status;
	ProView view;
	ProBoolean background = PRO_B_TRUE;
	bool isPlyView = false;

	status = ProDrawingDimensionViewGet ((ProDrawing)dim->owner, dim, &view);

	if (dimCollectData->filterView == 0 || dimCollectData->filterView == view)
	{

		if (status == PRO_TK_NO_ERROR)
		{
			status = ProDrawingViewIsBackground ((ProDrawing)dim->owner, view, &background);
			isPlyView = acProEDrawing::isPlyView((ProDrawing)dim->owner, view);
		}
	
		if (status == PRO_TK_NO_ERROR && !background && !isPlyView)
		{	
			status = ProSelectionAlloc (NULL, dim, &selDim);

			status = ProSelectionViewSet (view, &selDim);

			acProEDimension* a = new acProEDimension (selDim);
			if (a->canConvertToModelOwned())
				dimCollectData->v->push_back (a);
	
			ProSelectionFree (&selDim);
		}
	}

	return PRO_TK_NO_ERROR;
}

/*===========================================================================*/
extern "C" ProError acProEShownModelDimFilterAction (ProDimension* dim, ProAppData app_data)
{
	ProError status;
	ProError filter_status = PRO_TK_CONTINUE;
	ProView view;
	ProBoolean background;

	acProEShownDimCollectionData* dimCollectData = (acProEShownDimCollectionData*)app_data;

	if (dimCollectData->layerFilter == 0 || 
		dimCollectData->layerFilter->includeAnnotation (dimCollectData->drawing, dim))
	{
		status = ProDrawingDimensionViewGet (dimCollectData->drawing, dim, &view);

		if (status == PRO_TK_NO_ERROR)
		{
			if (dimCollectData->filterView == 0 || dimCollectData->filterView == view)
			{
				status = ProDrawingViewIsBackground (dimCollectData->drawing, view, &background);

				if (!background)
					filter_status = PRO_TK_NO_ERROR;
			}
		}
		else
		{
			/* Not displayed in the drawing.  */
		}
	}

	return filter_status;
}

/*===========================================================================*/
extern "C" ProError acProEShownModelDimCollectAction (ProDimension* dim, ProError filter_status, 
											ProAppData app_data)
{
	ProError status;
	ProSelection selDim;
	ProView view;

	acProEShownDimCollectionData* dimCollectData = (acProEShownDimCollectionData*)app_data;

	status = ProDrawingDimensionViewGet (dimCollectData->drawing, dim, &view);

	status = ProSelectionAlloc (NULL, dim, &selDim);
	status = ProSelectionViewSet (view, &selDim);

	acProEDimension* a = new acProEDimension (selDim);
	if (a->canConvertToModelOwned())
		dimCollectData->v->push_back (a);
	
	ProSelectionFree (&selDim);

	return PRO_TK_NO_ERROR;
}

/*===========================================================================*/
extern "C" ProError acProEComponentDimCollectFilter (ProAsmcomppath* path, ProSolid solid, 
										   ProAppData data)
{
	ProMdlName name;
	char c_name[PRO_MDLNAME_SIZE];
	int i, visitedSize;

	ProMdlMdlnameGet (solid, name);

	ProWstringToString (c_name, name);

	ACLOG << "ProSolidDispCompVisit in filter: model name:" << c_name << endl;

	acProEShownDimCollectionData* dimCollectData = (acProEShownDimCollectionData*)data;
	
	ProArraySizeGet (dimCollectData->visitedComponents, &visitedSize);

	bool found = false;
	for (i = 0;
	     i < visitedSize;
	     i ++)
	  {
	    ProSolid item = dimCollectData->visitedComponents[i];
	    if (item == solid)
	      {
		found = true;
		break;
	      }
	    
	  }

	if (found)
		return PRO_TK_CONTINUE;
	else
	{
	  ProArrayObjectAdd ((ProArray*)&dimCollectData->visitedComponents,
			     -1, 1, &solid);
	  return PRO_TK_NO_ERROR;
	}
}

/*===========================================================================*/
extern "C" ProError acProEComponentDimCollectAction (ProAsmcomppath* path, ProSolid solid, 
										   ProBoolean down, ProAppData data)
{
	ProMdlName name;
	char c_name[PRO_MDLNAME_SIZE];

	ProMdlMdlnameGet (solid, name);

	ProWstringToString (c_name, name);

	ACLOG << "ProSolidDispCompVisit in action: model name:" << c_name << endl;


	ProError status;
	acProEShownDimCollectionData* dimCollectData = (acProEShownDimCollectionData*)data;

	status = ProSolidDimensionVisit (solid, (dimCollectData->type == PRO_DIMENSION ? PRO_B_FALSE : PRO_B_TRUE), 
					 acProEShownModelDimCollectAction,
					 acProEShownModelDimFilterAction, 
					 data);
	logTKCall ("ProSolidDimensionVisit()", status);

	return PRO_TK_NO_ERROR;
}

/*===========================================================================*/
extern "C" ProError acProEDtlsyminstCollectFilter (ProDtlsyminst* dtlSymInst, ProAppData data)
{
	ProError status;
	ProBoolean shown;
	ProError returnVal = PRO_TK_CONTINUE;
	ProDtlsyminstdata dtlSymInstData;
	acProESymbolCollectionData* symbolCollectData = (acProESymbolCollectionData*)data;
	ProBoolean isDisplayed;
	ProSurfFinish srf_fin; 
	
	status = ProDtlsyminstSurffinGet(dtlSymInst, &srf_fin);
	if (status == PRO_TK_NO_ERROR && srf_fin.id >=0)
		return PRO_TK_CONTINUE;

	status = ProDtlsyminstDataGet (dtlSymInst, PRODISPMODE_NUMERIC, &dtlSymInstData);

	{

		{
			if (symbolCollectData->layerFilter == 0 || 
				symbolCollectData->layerFilter->includeAnnotation ((ProDrawing)dtlSymInst->owner,
																dtlSymInst))
			{
				ACLOG << "Symbol id " << dtlSymInst->id << " marked for conversion." << endl;
					returnVal = PRO_TK_NO_ERROR;
			}
			else
			{
				ACLOG << "Skipping symbol id " << dtlSymInst->id << " because it is on a layer that is not marked for conversion." << endl;
			}
		}

	}

	ProDtlsyminstdataFree (dtlSymInstData);

	return (returnVal);
}

/*===========================================================================*/
extern "C" ProError acProEDtlsyminstCollectAction (ProDtlsyminst* dtlSymInst, ProError errStatus, ProAppData data)
{
	ProError status;
	ProSelection symInstSel;
	acProESymbolCollectionData* symbolCollectData = (acProESymbolCollectionData*)data;
	ProDtlsyminstdata dtlSymInstData;

	ProDtlattach attach;
	ProDtlattachType type;
	ProView view;
	ProVector location;
	ProSelection attachment;

	status = ProDtlsyminstDataGet (dtlSymInst, PRODISPMODE_SYMBOLIC, &dtlSymInstData);

	status = ProDtlsyminstdataAttachmentGet (dtlSymInstData, &attach);

	status = ProDtlattachGet (attach, &type, &view, location, &attachment);

	bool isPlyView = acProEDrawing::isPlyView((ProDrawing)dtlSymInst->owner, view);
	if (isPlyView == true)
		return PRO_TK_NO_ERROR;

	/* For parametric/offset attachments the view is contained inside the attachment selection. */
	if (type == PRO_DTLATTACHTYPE_PARAMETRIC || type == PRO_DTLATTACHTYPE_OFFSET)
	{
		status = ProSelectionViewGet (attachment, &view);
	}

	if (symbolCollectData->filterView == 0 || symbolCollectData->filterView == view)
	{
		status = ProSelectionAlloc (0, dtlSymInst, &symInstSel);

		if (view != 0)
		{
			status = ProSelectionViewSet (view, &symInstSel);

			writeSelectionViewOwner (symInstSel);

			acProESymbol* a = new acProESymbol (symInstSel);
			if (a->canConvertToModelOwned())
				symbolCollectData->v->push_back (a);

			ProSelectionFree (&symInstSel);
		}	
	}
			
	ProDtlsyminstdataFree (dtlSymInstData);

	return PRO_TK_NO_ERROR;
}

/*===========================================================================*/
ProDrawing acProECollectionOptions::getCurrentDrawing ()
{
	ProMdl mdl;
	ProError status;

	status = ProMdlCurrentGet (&mdl);
	if (status == PRO_TK_NO_ERROR)
	{
		return ((ProDrawing)mdl);
	}
	return (0);
}

/*===========================================================================*/
acAnnotation* acProECollectionOptions::getAnnotationFromSelection (ProSelection s)
{
	acAnnotation* a;
	ProModelitem item;
	ProError status;	

	status = ProSelectionModelitemGet (s, &item);

	if (status != PRO_TK_NO_ERROR)
		return NULL;

	ACLOG<< "Selection type "<<item.type << " status " << status << endl;

	switch (item.type)
	{
	case PRO_GTOL:
		{
			a = new acProEGtol(s);
			break;
		}
	case PRO_NOTE:
		{
			a = new acProENote(s);
			break;
		}
	case PRO_SYMBOL_INSTANCE:
		{
			a = new acProESymbol(s);
			break;
		}
	case PRO_SURF_FIN:
		{
			a = new acProESurfaceFinish(s);
			break;
		}
	case PRO_DIMENSION:
	case PRO_REF_DIMENSION:
		{
			a = new acProEDimension (s);
			break;
		}
	case PRO_AXIS:	
	case PRO_DATUM_PLANE:
	case PRO_SURFACE:
		{
			a = new acProESetDatumTag (s);
			break;
		}
	default:
		return NULL;

	}
	if (a->canConvertToModelOwned())
		return a;
	else
	{
		delete a;
		return 0;
	}
}

/*===========================================================================*/
void acProECollectionOptions::addSelectionToCollection (ProSelection s, acAnnotationVector::iterator p)
{
	acAnnotation* a = getAnnotationFromSelection (s);

	if (a != 0)
		*p = a;
}

/*===========================================================================*/
acProEAllCollectionOptions::~acProEAllCollectionOptions ()
{
	if (mTypeFilter != 0)
		delete mTypeFilter;
	if (mLayerFilter != 0)
		delete mLayerFilter;
}

/*===========================================================================*/
void acProEAllCollectionOptions::addAllGtolsToCollection (acAnnotationVector* v)
{
	ProSolid solid;
	ProError status;
	acProEGtolCollectionData data;
	
	data.drawing = getCurrentDrawing ();
	data.filterView = mFilterView;
	data.layerFilter = mLayerFilter;
	data.v = v;

	status = ProDrawingCurrentSheetGet (data.drawing, &data.sheet);
	
	// Model owned gtols
	status = ProDrawingCurrentsolidGet (data.drawing, &solid);

	status = ProMdlGtolVisit (solid, acProEGtolCollectAction, acProEGtolCollectFilter, (ProAppData)&data);

	// Drawing owned gtols
	status = ProMdlGtolVisit (data.drawing, acProEGtolCollectAction, acProEGtolCollectFilter, (ProAppData)&data);
}

/*===========================================================================*/
void acProEAllCollectionOptions::addAllNotesToCollection (acAnnotationVector* v)
{
	ProError status;
	ProDrawing drawing = getCurrentDrawing ();
	acProEDtlnoteCollectionData data;
	data.filterView = mFilterView;
	data.v = v;
	data.layerFilter = mLayerFilter;
	int numSheets;

	int currentSheet;
	status = ProDrawingCurrentSheetGet (drawing, &currentSheet);

	status = ProDrawingDtlnoteVisit (drawing, 0, currentSheet, acProEDtlnoteCollectAction, 
										acProEDtlnoteCollectFilter, (ProAppData)&data);
}

/*===========================================================================*/
void acProEAllCollectionOptions::addAllSetDatumTagsToCollection (acAnnotationVector* v)
{
	ProError status;
	ProDrawing drawing = getCurrentDrawing ();
	acProESetDatumTagCollectionData setDatumTagData;
	int numSheets;
	ProSolid* solids;
	int numSolids;
	int i;

	setDatumTagData.v = v;
	setDatumTagData.layerFilter = mLayerFilter;

	ProArrayAlloc (0, sizeof (ProGeomitem), 5, (ProArray*)&setDatumTagData.geomitems);

	status = ProDrawingSolidsCollect (drawing, &solids);

	status = ProArraySizeGet (solids, &numSolids);

	for (i = 0; i < numSolids; i++)
	{
		setDatumTagData.currentSolid = solids[i];
		status = ProSolidAxisVisit (solids[i], 
									acProEFindAxisSetDatumAction, 0, 
									(ProAppData)&setDatumTagData);

		status = ProSolidFeatVisit (solids[i], 
									acProEFindPlaneSetDatumAction, acIsDatumPlane, 
									(ProAppData)&setDatumTagData);
	}

	status = ProDrawingViewVisit (drawing, acProESetDatumTagCollectAction, 
						NULL, (ProAppData)&setDatumTagData);
}

/*===========================================================================*/
void acProEAllCollectionOptions::addAllDrawingDimsToCollection (ProType type, 
															 acAnnotationVector* v)
{
	ProError status;
	ProDrawing drawing = getCurrentDrawing ();
	acProEDrawingDimCollectionData data;

	data.filterView = mFilterView;
	data.layerFilter = mLayerFilter;
	data.v = v;

	status = ProDrawingDimensionVisit (drawing, type, acProEDrawingDimCollectAction,
										acProEDrawingDimCollectFilter, (ProAppData)&data);

	//Commenting out to capture only drawing dims
	//addAllDrivingDimsToCollection (type, v);

}

/*===========================================================================*/
void acProEAllCollectionOptions::addAllDrivingDimsToCollection (ProType type, 
																acAnnotationVector* v)
{
	ProError status;
	ProDrawing drawing = getCurrentDrawing ();
	acProEShownDimCollectionData shownDimData;
	ProSolid currSolid;
	ProMdlType mdlType;

	shownDimData.drawing = drawing;
	shownDimData.filterView = mFilterView;
	shownDimData.layerFilter = mLayerFilter;
	shownDimData.type = type;
	shownDimData.v = v;

	ProArrayAlloc (0, sizeof (ProSolid), 1, (ProArray*)&shownDimData.visitedComponents);

	status = ProDrawingCurrentsolidGet (drawing, &currSolid);
	logTKCall ("ProDrawingCurrentsolidGet()", status);
	
	status = ProSolidDimensionVisit (currSolid, (type == PRO_DIMENSION ? PRO_B_FALSE : PRO_B_TRUE), 
									acProEShownModelDimCollectAction,
									acProEShownModelDimFilterAction, 
									(ProAppData)&shownDimData);
	logTKCall ("ProSolidDimensionVisit()", status);

	/* Collect subcomponent driving dims */
	status = ProMdlTypeGet (currSolid, &mdlType);
	logTKCall ("ProMdlTypeGet()", status);

	if (mdlType == PRO_MDL_ASSEMBLY)
	{
		ProRule rule;
		ProName nameMask;
		ProAsmcomppath* paths;
		int numPaths;
		ProSolid pathSolid;

		ProStringToWstring (nameMask, "*");

		status = ProRuleInitName (nameMask, &rule);
		logTKCall ("ProRuleInitName()", status);

		status = ProRuleEval (currSolid, &rule, &paths, &numPaths);
		logTKCall ("ProRuleEval()", status);

		for (int i = 0; i < numPaths; i++)
		{
			status = ProAsmcomppathMdlGet (&paths[i], (ProMdl*)&pathSolid);
			logTKCall ("ProAsmcomppathMdlGet()", status);

			status = acProEComponentDimCollectFilter (&paths[i], pathSolid,
													(ProAppData)&shownDimData);

			if (status == PRO_TK_NO_ERROR)
			{
				status = acProEComponentDimCollectAction (&paths[i], pathSolid,
														PRO_B_TRUE, (ProAppData)&shownDimData);
			}
		}

		ProArrayFree ((ProArray*)&paths);

#if 0
			/* WTF is this function doing?  It hits action->filter->action again and 
				ignored PRO_TK_CONTINUE from the return.  */
		status = ProSolidDispCompVisit (currSolid, 
										acProEComponentDimCollectAction, 
										acProEComponentDimCollectFilter,
										(ProAppData)&shownDimData);
		logTKCall ("ProSolidDispCompVisit()", status);
#endif
	}
	/* TODO later(?) collect inheritance feature driving dims */

	ProArrayFree ((ProArray*)&shownDimData.visitedComponents);
	
}
/*===========================================================================*/
void acProEAllCollectionOptions::addAllSymbolsToCollection (ProType type, 
															 acAnnotationVector* v)
{
	ProError status;
	ProDrawing drawing = getCurrentDrawing ();
	acProESymbolCollectionData data;
	data.filterView = mFilterView;
	data.v = v;
	data.layerFilter = mLayerFilter;
	int numSheets;

	int currentSheet;
	status = ProDrawingCurrentSheetGet (drawing, &currentSheet);

	status = ProDrawingDtlsyminstVisit (drawing, currentSheet, acProEDtlsyminstCollectAction, 
										acProEDtlsyminstCollectFilter, (ProAppData)&data);

}
/*===========================================================================*/
void acProEAllCollectionOptions::setViewForFilter (ProView view)
{
	mFilterView = view;
}

/*===========================================================================*/
acAnnotationVector* acProEAllGtolCollectionOptions::collectTargets ()
{
	collection = new acAnnotationVector;

	addAllGtolsToCollection (collection);

	return collection;
}

/*===========================================================================*/
acAnnotationVector* acProEAllNoteCollectionOptions::collectTargets ()
{
	collection = new acAnnotationVector;

	addAllNotesToCollection (collection);

	return collection;
}

/*===========================================================================*/
acAnnotationVector* acProEAllSetDatumTagCollectionOptions::collectTargets ()
{
	collection = new acAnnotationVector;

	addAllSetDatumTagsToCollection (collection);

	return collection;
}

/*===========================================================================*/
void acProETypeFilter::setCollectNotes (bool value)
{
	mCollectNotes = value;
}

/*===========================================================================*/
bool acProETypeFilter::getCollectNotes ()
{
	return mCollectNotes;
}

/*===========================================================================*/
void acProETypeFilter::setCollectGtols (bool value)
{
	mCollectGtols = value;
}

/*===========================================================================*/
bool acProETypeFilter::getCollectGtols ()
{
	return mCollectGtols;
}
/*===========================================================================*/
void acProETypeFilter::setCollectDrawingDims (bool value)
{
	mCollectDrawingDims = value;
}

/*===========================================================================*/
bool acProETypeFilter::getCollectDrawingDims ()
{
	return mCollectDrawingDims;
}

/*===========================================================================*/
void acProETypeFilter::setCollectModelDims (bool value)
{
	mCollectModelDims = value;
}

/*===========================================================================*/
bool acProETypeFilter::getCollectModelDims ()
{
	return mCollectModelDims;
}

/*===========================================================================*/
void acProETypeFilter::setCollectSetDatumTags (bool value)
{
	mCollectSetDatumTags = value;
}

/*===========================================================================*/
bool acProETypeFilter::getCollectSetDatumTags ()
{
	return mCollectSetDatumTags;
}

/*===========================================================================*/
void acProETypeFilter::setCollectSymbols (bool value)
{
	mCollectSymbols = value;
}

/*===========================================================================*/
bool acProETypeFilter::getCollectSymbols ()
{
	return mCollectSymbols;
}

/*===========================================================================*/
void acProETypeFilter::setCollectSurfaceFinish (bool value)
{
	mCollectSurfaceFinish = value;
}

/*===========================================================================*/
bool acProETypeFilter::getCollectSurfaceFinish ()
{
	return mCollectSurfaceFinish;
}

/*===========================================================================*/
ProError acProELayerCount (ProLayer* layer, ProAppData data)
{
	int* count = (int*) data;

	*count = *count + 1;

	return PRO_TK_NO_ERROR;
}

/*===========================================================================*/
ProError acProELayerFilterPopulate (ProLayer* layer, ProAppData data)
{
	acProELayerFilter* filter = (acProELayerFilter*) data;
	ProName name;
	ProError status;

	status = ProModelitemNameGet (layer, name);

	filter->addLayer (layer->id, name);

	return PRO_TK_NO_ERROR;
}

/*===========================================================================*/
acProELayerFilter::~acProELayerFilter()
{
	if (mNumLayers >= 0)
	{
		for (int i = 0; i < mNumLayers; i++)
		{
			if (mLayerNames != 0)
			{
				delete mLayerNames [i];
			}
			if (mLayerLabels != 0)
			{
				delete mLayerLabels [i];
			}
		}
		if (mLayerNames != 0)
		{
			delete mLayerNames;
		}
		if (mLayerLabels != 0)
		{
			delete mLayerLabels;
		}
		if (mLayerIds != 0)
		{
			delete mLayerIds;
		}
	}
}

/*===========================================================================*/
void acProELayerFilter::addLayer (int id, wchar_t* name)
{
	int length;

	mLayerNames [mLayerIndex] = new char [10];
	sprintf (mLayerNames [mLayerIndex], "%d", id);

	ProWstringLengthGet (name, &length);
	mLayerLabels [mLayerIndex] = new wchar_t [length + 1];
	ProWstringCopy (name, mLayerLabels [mLayerIndex], PRO_VALUE_UNUSED);

	mLayerIndex ++;
}

/*===========================================================================*/
bool acProELayerFilter::includeAnnotation (ProDrawing drawing, ProAnnotation* annotation)
{
	ProLayerItem layerItem;
	ProLayer* layers;
	int numLayers;
	bool ret = false;
	ProError status;

	ACLOG << "Include annotation called for id " << annotation->id << " type " 
		<< annotation->type << endl;

	layerItem.type = (ProLayerType)annotation->type;
	layerItem.id = annotation->id;
	layerItem.owner.owner_type = PRO_LAYITEM_FROM_MODEL;
	layerItem.owner.owner_union.layitem_model = annotation->owner;

	status = ProLayeritemLayersGet (drawing, &layerItem, &layers);

	if (status == PRO_TK_E_NOT_FOUND && includeNonLayerOwnedItems ())
	{
		ACLOG << "No layers found for id " << annotation->id << " type " 
			<< annotation->type << endl;
		return true;
	}

	if (status == PRO_TK_NO_ERROR)
	{
		status = ProArraySizeGet (layers, &numLayers);

		for (int i = 0; i < numLayers; i++)
		{
			if (includeLayer (&layers[i]))
			{
				ret = true;
				break;
			}
		}

		ProArrayFree ((ProArray*)&layers);
	}

	return ret;
}

/*===========================================================================*/
void acProELayerFilter::enableLayers (vector<string>* selections)
{
	if(selections != NULL)
	{
		for (vector<string>::iterator v = selections->begin(); v != selections->end(); v++)
		{
			if ((*v).compare ("-1") == 0)
				mNonLayerItems = true;
			else
			{
				int layerId = atoi ((*v).c_str());

				mLayerIds->push_back (layerId);
			}
		}
	}
}

/*===========================================================================*/
bool acProELayerFilter::includeLayer (ProLayer* layer)
{
	ACLOG << "Include layer called for layer id " << layer->id << endl;
	
	for (vector<int>::iterator i = mLayerIds->begin(); i != mLayerIds->end(); i++)
	{
		if (*i == layer->id)
			return true;
	}
	return false;
}

/*===========================================================================*/
bool acProELayerFilter::includeNonLayerOwnedItems ()
{
	return mNonLayerItems;
}

/*===========================================================================*/
void acProELayerFilter::initialize ()
{
	ProMdl model;
	ProError status;
	mNumLayers = 0;

	status = ProMdlCurrentGet (&model);

	status = ProMdlLayerVisit (model, acProELayerCount, NULL, &mNumLayers);

	if (mNumLayers > 0)
	{
		ACLOG << "Layers: " << mNumLayers << endl;
		mNumLayers++;
		mLayerNames = new char* [mNumLayers];
		mLayerLabels = new wchar_t* [mNumLayers];
		mLayerIndex = 0;
		addLayer (-1, L"Not on any layer");

		status = ProMdlLayerVisit (model, acProELayerFilterPopulate, NULL, this);

		mLayerIds = new vector<int>;
	}
	else
		mNumLayers = -1;
}

/*===========================================================================*/
int acProELayerFilter::getNumberOfLayers()
{
	return mNumLayers;
}

/*===========================================================================*/
char** acProELayerFilter::getLayerNames ()
{
	return mLayerNames;
}

/*===========================================================================*/
wchar_t** acProELayerFilter::getLayerLabels ()
{
	return mLayerLabels;
}

/*===========================================================================*/
void acProEAllCollectionOptions::setTypeFilter (acProETypeFilter* filter)
{
	if (mTypeFilter != 0)
		delete mTypeFilter;

	mTypeFilter = filter;
}

/*===========================================================================*/
void acProEAllCollectionOptions::setLayerFilter (acProELayerFilter* filter)
{
	if (mLayerFilter != 0)
		delete mLayerFilter;

	mLayerFilter = filter;
}

/*===========================================================================*/
acAnnotationVector* acProEAllCollectionOptions::collectTargets ()
{
	collection = new acAnnotationVector;

	if (mTypeFilter == 0 || mTypeFilter->getCollectGtols())
		addAllGtolsToCollection (collection);

	if (mTypeFilter == 0 || mTypeFilter->getCollectNotes())
		addAllNotesToCollection (collection);

	if (mTypeFilter == 0 || mTypeFilter->getCollectDrawingDims())
	{
		addAllDrawingDimsToCollection (PRO_DIMENSION, collection);
		addAllDrawingDimsToCollection (PRO_REF_DIMENSION, collection);
	}

	if (mTypeFilter == 0 || mTypeFilter->getCollectModelDims())
	{
		addAllDrivingDimsToCollection (PRO_DIMENSION, collection);
		addAllDrivingDimsToCollection (PRO_REF_DIMENSION, collection);
	}

	if (mTypeFilter == 0 || mTypeFilter->getCollectSetDatumTags())
	{
		;//addAllSetDatumTagsToCollection (collection);
	}

	if (mTypeFilter == 0 || mTypeFilter->getCollectSymbols())
	{
		addAllSymbolsToCollection (PRO_SYMBOL_INSTANCE, collection);
	}

	if (mTypeFilter == 0 || mTypeFilter->getCollectSurfaceFinish())
	{
		//addAllSurfaceFinishToCollection (collection);
	}

	return collection;
}

/*===========================================================================*/
acAnnotationVector* acProESingleViewCollectionOptions::collectTargets ()
{
	ProSelection* sels;
	int nSels;
	ProView view;
	ProError status;
	ProSelectionEnv sel_env;
	ProSelectionEnvOption sel_env_opt[1];

	sel_env_opt[0].attribute = PRO_SELECT_HIDE_SEL_DLG;
	sel_env_opt[0].value = 1;
	
	status = ProSelectionEnvAlloc(sel_env_opt, 1, &sel_env);

	status = ProSelect ("dwg_view", 1, NULL, NULL, sel_env, NULL, &sels, &nSels);

	if (status == PRO_TK_NO_ERROR && (nSels == 1))
	{
		status = ProSelectionViewGet (sels[0], &view);

		setViewForFilter (view);

		return acProEAllCollectionOptions::collectTargets();
	}



	return 0;
}

/*===========================================================================*/
extern "C" ProError acProEAOSelectionFilter (ProSelection s, ProAppData data)
{
	acAnnotation* a = acProECollectionOptions::getAnnotationFromSelection (s);

	if (a == 0)
	{
		return PRO_TK_BAD_INPUTS;
	}
	else
	{
		ProView selView = 0;
		ProDrawing selDrw = 0;
		ProError status;
		status = ProSelectionViewGet(s, &selView);
		status = ProSelectionDrawingGet(s, &selDrw);

		if (acProEDrawing::isPlyView(selDrw, selView))
			return PRO_TK_BAD_INPUTS;

		delete a;
		return PRO_TK_NO_ERROR;
	}
}
/*===========================================================================*/
void acProEAOSelectionOptions::setTypeFilter(acProETypeFilter* filter)
	{

	  if (mTypeFilter != 0)
		delete (this->mTypeFilter);
	  
	  this->mTypeFilter = filter;

	  return;
	}

/*===========================================================================*/
acAnnotationVector* acProEAOSelectionOptions::collectTargets ()
{
	ProError status;
	ProSelection* sels;
	int n_sels=0;
	int i = 0;
	ProModelitem item;
	ProSelFunctions functions;
	char selOptions [PRO_LINE_SIZE] = "\0";

	functions.pre_filter = 0;
	functions.post_filter = acProEAOSelectionFilter;
	functions.post_selact = 0;
	functions.app_data = 0;

	if(mTypeFilter)
		{
   if (mTypeFilter->getCollectGtols())
	   strcat(selOptions,"gtol,");

   if (mTypeFilter->getCollectNotes())
		strcat(selOptions,"any_note,");

   if (mTypeFilter->getCollectSymbols())
		strcat(selOptions,"dtl_symbol,");

   if (mTypeFilter->getCollectDrawingDims() || mTypeFilter->getCollectModelDims())
		strcat(selOptions,"dimension,ref_dim");

    if(selOptions[strlen(selOptions) - 1] == ',')
			selOptions[strlen(selOptions) - 1] = '\0';

	if(strlen(selOptions) == 0)
	return 0;
	
   
   status = ProSelect (selOptions,-1, NULL, &functions, NULL, NULL, &sels, &n_sels);
  	}

   else
   status = ProSelect ("gtol,any_note,dtl_symbol,dimension,ref_dim",-1, NULL, &functions, NULL, NULL, &sels, &n_sels);
   
   if (status != PRO_TK_NO_ERROR)
	return 0;

	acAnnotationVector* v = new acAnnotationVector (n_sels);
	for (acAnnotationVector::iterator p = v->begin(); p != v->end(); ++p, i++)
	{
		addSelectionToCollection (sels[i], p);
	}

	return v;
}

/*===========================================================================*/
acProEOACollectionOptions::acProEOACollectionOptions (ProSelection* preselected):
	mPreselected (preselected)
{
}

/*===========================================================================*/
acProEOACollectionOptions::~acProEOACollectionOptions ()
{
	ProSelectionarrayFree (mPreselected);
}

/*===========================================================================*/
acAnnotationVector* acProEOACollectionOptions::collectTargets ()
{
	int nSels, i = 0;
	ProError status;

	status = ProArraySizeGet (mPreselected, &nSels);

	acAnnotationVector* v = new acAnnotationVector (nSels);
	for (acAnnotationVector::iterator p = v->begin(); p != v->end(); ++p, i++)
	{
		addSelectionToCollection (mPreselected[i], p);
	}

	return v;
}
