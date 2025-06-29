# 01/30/13   SJB    $$1  Introduce new test type QATitgms_pp

%TestTP;

$TestTP{'QATitg'}                       =1;  #Mechanism
$TestTP{'ProEQCR'}                      =1;  #Pro/FEM and Animation and other cases without SOs
$TestTP{'ProETM'}                       =1;  #Thermal Modeler 

$TestTP{'QATitgmm'}			=2;  #Integrated UI - Motion                   
$TestTP{'QATitgms'}			=2;  #Integrated UI - STructure/Thermal 
$TestTP{'QATitgms_pp'}			=2;  #Integrated UI - new P-20 post-processor

$TestTP{'QATasm'}			=3;  #Integrated/Standalone UI [Transfer of Assembly]
$TestTP{'QATprt'}			=3;  #Integrated/Standalone UI [Transfer of Part]  

$TestTP{'QATscrmm'}			=4;  #Standalone Motion UI

$TestTP{'QATscrms'}			=5;  #Standalone Structure UI - Structure
$TestTP{'QATugs'}			=5;  #Standalone Structure UI - UG translator                       
$TestTP{'QATdvs'}			=5;  #Standalone Structure UI [design variables]                     
$TestTP{'QATdvs_ug'}	        	=5;  #Standalone Structure UI [Unigraphics interface]
$TestTP{'QATdxf'}                       =5;  #Standalone Structure UI [AutoCAD interface]

$TestTP{'QATscrth'}			=6;  #Standalone UI - Thermal

$TestTP{'QATpgm_s'}                     =7;
$TestTP{'QATpgm_v'}                     =7;
                                                       
$TestTP{'QATitg_eng'}		        =8;  #Integrated UI - MStructure/Thermal engine                               
                                     
$TestTP{'QATmng_d'}			=9;  #Motion engine                                        
$TestTP{'QATmng_v'}			=9;  #Motion engine        
                            
$TestTP{'QATeng'}			=10;  #Structure/Thermal engine [DPI with assembly]
$TestTP{'QATengsi'}                     =10;  #Structure/Thermal engine [config.mech file]
$TestTP{'QATeng_link_asm'}	        =10;  #Structure/Thermal engine [DPI with part]             
$TestTP{'QATeng_link_prt'}	        =10;  #Structure/Thermal engine [DPI with Unigraphics part] 
$TestTP{'QATeng_ug'}		        =10;  #Structure/Thermal engine [DPI with UG model]
                             
$TestTP{'QATags'}			=11;  #Standalone Structure UI [surface automeshing]                  
$TestTP{'QATagv'}			=11;  #Standalone Structure UI [volume automeshing]
$TestTP{'QATigm_s'}                     =11;  #Standalone Structure UI [Meshing from IGES Part - Surface]
$TestTP{'QATigm_v'}                     =11;  #Standalone Structure UI [Meshing from IGES Part - Volume]

$TestTP{'QATvda'}			=12;  #Standalone Structure UI [VDA interface]

$TestTP{'QATigs_lsm'}		        =13;  #Standalone UI - IGES translator

$TestTP{'QATagm_awp'}                   =14;  # AutoGem Meshing
$TestTP{'QATagm_srf'}                   =14;  # AutoGem Meshing
$TestTP{'QATinria'}                     =14;  # FEM Meshing 

$TestTP{'QATmdx_perf'}                  =15;  #

$TestTP{'QATcta'}                       =16;  #Standalone Catia Translator

$TestTP{'QATitgeng_pp'}		        =17;  #Integrated UI - Structure/Thermal engine - post-process

$TestTP{'QATdev'}                       =99;  # Development type


%ScrTP;

$ScrTP{'QATags'}		    = ['ags.scr']; # ---- Standalone UI [Surface automeshing]
$ScrTP{'QATagv'}		    = ['agv.scr']; # ---- Standalone UI [volume automeshing]                   
$ScrTP{'QATasm'}		    = ['asm.txt', 'asm1.txt', 'asm2.txt', 'asm5.txt', 'GenLSM.scr', 'exit_ui.scr', 'DoTopoCheck.scr', 'make_volume.scr', 'topo_check.scr', 'ImportMNF.scr']; # Integrated / standalone UI [transfer of assembly]
$ScrTP{'QATprt'}		    = ['prt.txt', 'GenLSM.scr', 'exit_ui.scr', 'DoTopoCheck.scr', 'make_volume.scr', 'topo_check.scr', 'ImportMNF.scr']; # IntegratedStandalone UI [Transfer of Part]  
$ScrTP{'QATigm_s'}		    = ['igm_s.scr']; #
$ScrTP{'QATigm_v'}		    = ['igm_v.scr']; #
$ScrTP{'QATpgm_v'}		    = ['prt.txt', 'pgm_v.scr']; #
$ScrTP{'QATpgm_s'}		    = ['prt.txt', 'pgm_s.scr']; #
$ScrTP{'QATdxf'}                    = ['dxf.scr', 'exit_ui.scr']; #
$ScrTP{'QATdvs'}		    = ['dvs.scr'];               # ---- Standalone UI [design variables]                     
$ScrTP{'QATdvs_ug'}	            = ['dvs_ug.scr'];            #      Standalone UI [Unigraphics interface]    
$ScrTP{'QATigs_lsm'}		    = ['igs_lsm.scr', 'DoTopoCheck.scr', 'topo_checker.scr', 'DoDVCheck.scr', 'dv_check.scr', 'iges_export_import.scr', 'exit_ui.scr', 'make_volume.scr'];    #  Integrated UI         
$ScrTP{'QATugs'}		    = ['ugs_lsm.scr', 'exit_ui.scr', 'ugs2.scr', 'make_volume.scr', 'new_topo_check.scr']; #      Standalone UI - VDA translator                       
$ScrTP{'QATvda'}		    = ['vda.scr']; # ---- Standalone UI [CATIA interface]
$ScrTP{'QATagm_awp'}                = ['AGEM_awp.txt', 'AGEM_awp_2d.txt'];
$ScrTP{'QATagm_srf'}                = ['AGEM_srf.txt'];
$ScrTP{'QATinria'}                  = ['inria.txt'];
$ScrTP{'QATmdx_perf'}               = ['QATmdx_perf.txt'];
$ScrTP{'QATcta'}                    = ['cta.scr','exit_ui.scr', 'DoTopoCheck.scr', 'make_volume.scr', 'topo_check.scr']; # --------------- Standalone Catia Translator

$ScrTP{'ProETM'}	            =[]; # --------------- Thermal Modeler                                            
$ScrTP{'ProEQCR'}	            =[]; # --------------- Animation and Pro/FEM

$ScrTP{'QATitg'}		    =[]; # --------------- Mechanism            
$ScrTP{'QATitg_eng'}		    =[]; #                 Integrated UI -> Structure/Thermal engine
$ScrTP{'QATitgmm'}	            =[]; # --------------- Integrated UI - Motion                    
$ScrTP{'QATitgms'}		    =[]; #                 Integrated UI - Structure/Thermal
$ScrTP{'QATitgms_pp'}		    =[]; #                 Integrated UI - new P-20 post-processor
$ScrTP{'QATscrmm'}		    =[]; # --------------- Standalone UI - Motion                    
$ScrTP{'QATscrms'}		    =[]; #                 Standalone UI - Structure/Thermal 
$ScrTP{'QATeng'}		    =[]; # --------------- Structure/Thermal engine [DPI with assembly]
$ScrTP{'QATengsi'}		    =[]; #
$ScrTP{'QATeng_link_asm'}	    =[]; #                 Structure/Thermal engine [DPI with part]             
$ScrTP{'QATeng_link_prt'}	    =[]; # --------------- Structure/Thermal engine [DPI with Unigraphics part] 
$ScrTP{'QATeng_ug'}		    =[]; #                 Standalone UI [Unigraphics inteface]
$ScrTP{'QATmng_d'}		    =[]; # --------------- Motion Engine                                        
$ScrTP{'QATmng_v'}		    =[]; #                 Motion Engine 
$ScrTP{'QATitgeng_pp'}		    =[]; #                 Integrated UI -> Structure/Thermal engine -> post-process
$ScrTP{'QATdev'}                    =[]; #              Development Type regr

1; #Important
