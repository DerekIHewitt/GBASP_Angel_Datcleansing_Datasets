SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		DIH
-- Create date: 03/02/2020
-- Description:	List of accouint provided for first test run
--
-- 1	04/02/2020	DIH		Created
-- 2	04/02/2020	DIH		Some customers are newer than the current backup (These have been removed)
-- 3	04/02/2020	DIH		Replacement customers added.
-- 4	10/02/2020	DiH		Added dependent 'INVOICE to' / 'Parent account' required by the sub set
-- 5	17/02/2020	DIH		Added additional accounts (Richards 'invoice account' list differs - probable different ProWat backups)
-- 6    11/03/2020  ARG		Added parent 'key' accounts for key account hierarchies to be loaded
-- 7	12/03/2020	ARG		Added as per RR email 12/03/2020	
-- 8    17/03/2020  ARG		Added extra customer for key account hierarchy
-- 9    23/03/2020  ARG		Added more for hierarchies
-- =============================================
Create FUNCTION [Dataset].[sysSubSetA_Customers]
(
	@CustomerID varchar(20)
)
RETURNS bit
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ResultVar bit = 0;

	IF @CustomerID IN (
					/* Customers on the Sheet */
					'1235465', -- CBRE Managed services Ltd (UK) - Consuma
					'1098980', -- CBRE Managed services Ltd (UK) - Rental 
					'1209730', -- COMPASS CONTRACT SERVICES               
					'1233596', -- ISS Facility Services                   
					'1168562', -- ISS Facility Services Ltd-c/o Royal Mail
					'1131740', -- AWS T/A Waterlogic                      
					'1112018', -- ARAMARK Ltd                             
					'1112627', -- Aramark Ltd                             
					'1216971', -- Aramark Ltd                             
					'1232419', -- Aramark Ltd                             
					'1239161', -- Aramark Ltd                             
					'1240024', -- Aramark Ltd                             
					'1240029', -- Aramark Ltd                             
					'1245350', -- Aramark Ltd                             
					'1116462', -- ARAMARK LTD T/A ARCADION                
					'1112719', -- Lear Corporation                        
					'1122290', -- Lear Corporation                        
					'1130220', -- Lear Corporation                        
					'1134068', -- Lear Corporation                        
					'1167941', -- Clarion Housing                         
					'1121595', -- CLARION HOUSING ASSOCIATION REGE        
					'1215973', -- Clarion Housing BEAC                    
					'1215975', -- CLARION HOUSING BLOX                    
					'1160535', -- CLARION HOUSING GROUP                   
					'1205192', -- CLARION HOUSING GROUP                   
					'1114536', -- CLARION HOUSING GROUP CORS              
					'1205994', -- CLARION HOUSING GROUP MICK              
					'1077549', -- THIRSTY WORK - KEY BOTTLED ACCOUNT      
					'1077550', -- THIRSTY WORK - POU KEY ACCOUNT          
					'945788', -- THIRSTY WORK LTD                        
					'1227350', -- Thirsty Work Water Coolers Ltd          
					'1231072', -- Red Funnel                              
					'1209119', -- Red Funnel                              
					'1209120', -- RED FUNNEL                              
					'1209315', -- RED FUNNEL                              
					'1209317', -- RED FUNNEL                              
					'1241826', -- Red Funnel                              
					'1240795', -- Red Funnel East Cowes Terminal          
					'1113086', -- Red Funnel Ltd                          
					'1148367', -- Red Funnel Ltd                          
					'1039167', -- MCLAREN CONSTRUCTION                    
					'1088773', -- MCLAREN CONSTRUCTION                    
					'1101678', -- MCLAREN CONSTRUCTION                    
					'1171970', -- Mclaren Construction                    
					'1191009', -- MCLAREN CONSTRUCTION                    
					'1192275', -- MCLAREN CONSTRUCTION                    
					'1199780', -- MCLAREN CONSTRUCTION                    
					'1207509', -- MCLAREN CONSTRUCTION                    
					'1208362', -- MCLAREN CONSTRUCTION                    
					'1245496', -- Mclaren Construction - London           
					'1054185', -- MCLAREN CONSTRUCTION LIMITED            
					'1109902', -- MCLAREN CONSTRUCTION LTD                
					'1116136', -- McLaren Construction Ltd                
					'1218960', -- McLaren Construction Ltd                
					'1103232', -- BALFOUR BEATTY CIVIL ENGINEERING        
					'1250064', -- Helliwellflowers                        
					'1188597', -- HORBURY GARAGE                          
					'1247188', -- Hotel Sea Breeze                        
					'1192943', -- MR KEMAR JACKSON                        
					'1200085', -- SDC BUILDERS                            
					'1215886', -- SDC BUILDERS                            
					'1218408', -- SDC Builders                            
					'1228965', -- SDC Builders                            
					'1230394', -- SDC Builders                            
					'1230682', -- SDC Builders                            
					'1234366', -- SDC Builders                            
					'1234567', -- SDC Builders                            
					'1236353', -- SDC Builders                            
					'1237881', -- SDC Builders                            
					'1238216', -- SDC Builders                            
					'1238282', -- SDC Builders                            
					'1238866', -- SDC Builders                            
					'1238992', -- SDC Builders                            
					'1239951', -- SDC Builders                            
					'1239952', -- SDC Builders                            
					'1240133', -- SDC Builders                            
					'1240625', -- SDC Builders                            
					'1240762', -- SDC Builders                            
					'1241077', -- SDC Builders                            
					'1241303', -- SDC Builders                            
					'1241986', -- SDC Builders                            
					'1246339', -- SDC Builders                            
					'1250034', -- SDC Builders                            
					'1250575', -- SDC Builders                            
					'1106739', -- SDC BUILDERS - KEY ACCOUNT BOTTLED      
					'1106740', -- SDC BUILDERS - KEY ACCOUNT POU          
					'1197106', -- SDC BUILDERS - KEY ACCOUNT SOLD POU     
					'927529', -- SDC BUILDERS LTD                        
					'953747', -- SDC BUILDERS LTD                        
					'954495', -- SDC BUILDERS LTD                        
					'1054764', -- SDC BUILDERS LTD                        
					'1074156', -- SDC BUILDERS LTD                        
					'1074213', -- SDC BUILDERS LTD                        
					'1106580', -- SDC BUILDERS LTD                        
					'1107454', -- SDC BUILDERS LTD                        
					'1166553', -- SDC BUILDERS LTD                        
					'1172002', -- SDC BUILDERS LTD                        
					'1175943', -- SDC BUILDERS LTD                        
					'1177996', -- SDC BUILDERS LTD                        
					'1189190', -- SDC BUILDERS LTD                        
					'1189461', -- SDC BUILDERS LTD                        
					'1189612', -- SDC BUILDERS LTD                        
					'1191572', -- SDC BUILDERS LTD                        
					'1192245', -- SDC BUILDERS LTD                        
					'1195993', -- SDC BUILDERS LTD                        
					'1199624', -- SDC BUILDERS LTD                        
					'1201683', -- SDC BUILDERS LTD                        
					'1206899', -- SDC BUILDERS LTD                        
					'1207332', -- SDC BUILDERS LTD                        
					'1207406', -- SDC BUILDERS LTD                        
					'1207829', -- SDC BUILDERS LTD                        
					'1208801', -- SDC BUILDERS LTD                        
					'1209387', -- SDC BUILDERS LTD                        
					'1213348', -- SDC BUILDERS LTD                        
					'1213683', -- SDC BUILDERS LTD                        
					'1213962', -- SDC BUILDERS LTD                        
					'1214352', -- SDC BUILDERS LTD                        
					'1214475', -- SDC BUILDERS LTD                        
					'1214626', -- SDC BUILDERS LTD                        
					'1216855', -- SDC Builders Ltd                        
					'1216899', -- SDC Builders Ltd                        
					'1232918', -- SDC Builders Ltd                        
					'1246995', -- SDC Builders LTD                        
					'1246998', -- SDC Builders LTD                        
					'1154253', -- SDC Trailers Ltd                        
					'1094304', -- GLL                                     
					'1096871', -- GLL                                     
					'1098977', -- GLL                                     
					'1110464', -- GLL                                     
					'1204743', -- GLL                                     
					'1204744', -- GLL                                     
					'1204746', -- GLL                                     
					'1204765', -- GLL                                     
					'1204769', -- GLL                                     
					'1204779', -- GLL                                     
					'1205829', -- GLL                                     
					'1212702', -- GLL                                     
					'1237817', -- GLL                                     
					'1250223', -- GLL                                     
					'1250366', -- GLL                                     
					'1250524', -- GLL                                     
					-- '1251262', -- GLL                                     (Removed 04/02/2020)
					-- '1250978', -- GLL - Barnet Burnt Oak Leisure Centre    (Removed 04/02/2020)
					'1188354', -- GLL - OASIS SPORTS CENTRE               
					'1213540', -- GLL - OASIS SPORTS CENTRE LTD           
					'1112477', -- GLL (Greenwich Leisure Limited)         
					'1208418', -- GLL BETTER GYM PORTSMOUTH               
					'1250749', -- GLL BWC KEY ACCOUNT                     
					'1134963', -- GLL C/O Alderwood Childrens Centre      
					'1244813', -- GLL C/O Alderwood Childrens Centre      
					'1247055', -- GLL C/O Llanishen Leisure Centre        
					'1241905', -- GLL C/O London Greenacres Children's Ctr
					'1153195', -- GLL C/O Rivermead Leisure Complex       
					'1122299', -- GLL C/O Shooters Hill Children Centre   
					'1133327', -- GLL C/O Shooters Hill Children Centre   
					'1113988', -- GLL C/O Storkway Children Centre        
					'1154475', -- GLL C/O Storkway Children Centre        
					'1129841', -- GLL C/O Streatham Ice & Leisure Centre  
					'1237824', -- GLL Dorcan Recreation Complex Ltd       
					'1017289', -- GLL FINANCE DEPARTMENT                  
					'1216668', -- GLL Hough End Leisure Centre            
					'1217985', -- GLL Hough End Leisure Centre            
					'1218607', -- Gll Manchester Aquatics Centre          
					'1217847', -- GLL Moss Side Leisure Centre            
					'1175774', -- GLL MULBERRY PARK CHILDRENS CENTRE      
					'1213304', -- GLL OASIS LEISURE CENTRE                
					'1213306', -- GLL OASIS LEISURE CENTRE                
					'1250750', -- GLL POU RENT KEY ACCOUNT                
					'1120155', -- The Royal Marsden Hospital              
					'1126932', -- The Royal Marsden Hospital              
					'1127810', -- The Royal Marsden Hospital              
					'1132536', -- The Royal Marsden Hospital              
					'1133831', -- The Royal Marsden Hospital              
					'1140208', -- The Royal Marsden Hospital              
					'1146343', -- The Royal Marsden Hospital              
					'1159040', -- The Royal Marsden Hospital              
					'1160187', -- The Royal Marsden Hospital              
					'1230250', -- The Royal Marsden Hospital              
					'1112372', -- The Royal Marsden NHS Foundation Trust  
					'1114056', -- The Royal Marsden NHS Foundation Trust  
					'1114736', -- Royal Marsden FT RPY Payable            
					'1020459', -- CANARY WHARF CONTRACTORS                
					'1202412', -- CANARY WHARF CONTRACTORS                
					'1208715', -- CANARY WHARF CONTRACTORS                
					'921277', -- CANARY WHARF CONTRACTORS LTD            
					'921285', -- CANARY WHARF CONTRACTORS LTD            
					'940741', -- CANARY WHARF CONTRACTORS LTD            
					'947899', -- CANARY WHARF CONTRACTORS LTD            
					'948511', -- CANARY WHARF CONTRACTORS LTD            
					'1013084', -- CANARY WHARF CONTRACTORS LTD            
					'1064002', -- Canary Wharf Contractors Ltd            
					'1073771', -- CANARY WHARF CONTRACTORS LTD            
					'1076176', -- CANARY WHARF CONTRACTORS LTD            
					'1076180', -- CANARY WHARF CONTRACTORS LTD            
					'1090266', -- CANARY WHARF CONTRACTORS LTD            
					'1109945', -- CANARY WHARF CONTRACTORS LTD            
					'1175502', -- CANARY WHARF CONTRACTORS LTD            
					'1190042', -- CANARY WHARF CONTRACTORS LTD            
					'1114043', -- The Salvation army                      
					'1120865', -- The Salvation Army                      
					'1121041', -- The Salvation Army                      
					'1122366', -- The Salvation Army                      
					'1125500', -- The Salvation Army                      
					'1135038', -- The Salvation Army                      
					'1172780', -- THE SALVATION ARMY                      
					'1110850', -- The Salvation Army (Social)             
					'924722', -- Destiny Hair Design                     
					-- '1251065', -- Owl Homes Ltd              (Removed 04/02/2020)
					'1166927', -- STOCKTON DRILLING YARD                  
					'971158', -- STOCKTON DRILLING LTD                   
					-- '1251044', -- Eve Afriyie (Resi)         (Removed 04/02/2020)
					-- '1251033', -- Maureen Cameron-Sameul		(Removed 04/04/2020)                
					'1218269', -- D K R Accountants Ltd                   
					'1093827', -- Isabel Hospice                          
					'1094886', -- Isabel Hospice                          
					'1098212', -- Isabel Hospice                          
					'1099184', -- Isabel Hospice                          
					'1171824', -- THE SALVATION ARMY                      
					'1109582', -- THE SENECIO PRESS LTD                   
					'1073845', -- THE SHED                                
					-- '1251132', -- THE UK CENTRE FOR ECOLOGY & HYDROLOGY   (Removed 04/02/2020))          
					-- '1251137', -- THE UK CENTRE FOR ECOLOGY & HYDROLOGY   (Removed 04/02/2020))          
					-- '1251163', -- THE UK CENTRE FOR ECOLOGY & HYDROLOGY   (Removed 04/02/2020))          
					'1164512', -- HIGH DOWN JUNIOR SCHOOL                 
					-- '1250977', -- High Down Junior School        (Removed 04/02/2020))          
					'1115600', -- AAK (UK) Limited                        
					'1147808', -- AAK (UK) Limited                        
					'1117235', -- Abbey Infant School                     
					'1160862', -- Abbey Infant School                     
					'1239774', -- Abbey Infant School                     
					'1193964', -- G COMMUNICATIONS                        
					'1247200', -- G Communications Ltd                    
					'1071511', -- THE SECOND HAND SHOP                    
					-- '1251275', -- CONVEX CAPITAL LTD                      (Remnoved 04/02/2020)
					-- '1251075', -- True Recruitment kent                   (Remnoved 04/02/2020)
					-- '1251068', -- TC Networks Ltd                         (Removed 04/02/2020)
					-- '1251020', -- Nexus People							(Removed 04/02/2020)              
					-- '1251016', -- MUK Global Trading UK Ltd               (Removed 04/02/2020)
					'1218522', -- Arcum Ltd                               
					'1218185', -- Out of Town Beauty                      
					'1246329', -- STOCKTON DRILLING LTD                   
					'1244417', -- Alton Towers Theme Park                 
					'1133849', -- CWG Roofing Ltd                         
					'1243565', -- The Griffin
					'1243569', -- Rosa's Thai Cafe Soho                   
					'1243570', -- Rosa's Thai Cafe Seven Dials            
					'1243571', -- Terroir Tapas                           
					'1243572', -- Nobu Hotel                              
					'1243573', -- Rosa's Thai Cafe Spitalfields           
					'1243574', -- Rosa's Thai Cafe Brixton    
					--
					-- Accounts added 04/02/2020
					'1080604', --	MERCY CORPS                             
					'1174919', --	MERCY CORPS                             
					'1218102', --	Mercy Corps                             
					'1218125', --	Mercy Corps                             
					'1218143', --	Heel & Toe Ltd                          
					'1218145', --	Croydon Boxing Club                     
					'1056362', --	Woods Group Ltd                         
					'1218157', --	Woods Group Ltd                         
					'1218158', --	Woods Group Ltd                         
					'1230784', --	Woods Group Ltd                         
					'919662',   --	Mrs Stetson  
					--
					-- Added 10/02/2020 as it is a parent account that recieves invoices for several companies.
					'1243611',   
					--
					-- Added 17/02/2020 as Richards list of accounts has different 'invoice accounts' in the ProWat version used       
					'914929',
					'1111883',
					'1113226',
					'1113617',
					'1115161',
					'1117363',
					'1178009',
					'1195883',
					'1208253',
					'1210320',
					-- Added 11/03/2020 ARG - for key account hierarchies
					'1003385', -- CAMERON WATER KEY BOTTLED ACC           
					'1008078', -- CAMERON WATER KEY ACCOUNT POU           
					'1019544', -- CANARY WHARF - KEY ACCOUNT BOTTLED      
					'1019547', -- CANARY WHARF - KEY ACCOUNT POU          
					'1082504', -- INEOS - BOTTLE KEY ACCOUNT              
					'1106739', -- SDC BUILDERS - KEY ACCOUNT BOTTLED      (Already in list)
					'1106740', -- SDC BUILDERS - KEY ACCOUNT POU		  (Already in list)
					'1168563', -- ISS - ROYAL MAIL BWC KEY                
					'1177282', -- ARAMARK KEY ACCOUNT                     
					'1197106', -- SDC BUILDERS - KEY ACCOUNT SOLD POU     (Already in list)
					'1250749', -- GLL BWC KEY ACCOUNT					  (Already in list)
					'1250750', -- GLL POU RENT KEY ACCOUNT				  (Already in list)
					-- Added 12/03/2020 RR - to support Equipment File that Safeena has classified for us
					'100', -- MAGNOR PLANT HIRE LTD                       (Added 12/03/2020)
					'101', -- MAGNOR PLANT HIRE LTD                       (Added 12/03/2020)
					'111', -- MAGNOR PLANT HIRE LTD                       (Added 12/03/2020)
					'240', -- Allied Machine & Engineering                (Added 12/03/2020)
					'410', -- AF BLAKEMORE & SONS                         (Added 12/03/2020)
					'418', -- AF BLAKEMORE & SONS-COMPUTER RM             (Added 12/03/2020)
					'420', -- BORGERS LTD                                 (Added 12/03/2020)
					'470', -- ACE TOWNSEND COATERS                        (Added 12/03/2020)
					'550', -- EAGLE ENVELOPES LTD                         (Added 12/03/2020)
					'570', -- CIRCUIT COATINGS LTD                        (Added 12/03/2020)
					'790', -- CASTOLIN EUTECTIC LIMITED                   (Added 12/03/2020)
					'910', -- UNDERHILL LANGLEY & WRIGHT LIMITED          (Added 12/03/2020)
					'980', -- H L SMITH LTD                               (Added 12/03/2020)
					'1040', -- Surespan Ltd                                (Added 12/03/2020)
					'1050', -- SURESPAN LTD                                (Added 12/03/2020)
					'1070', -- GLASSWORKS HOUNSELL LTD                     (Added 12/03/2020)
					'1170', -- HENSHALL WEALTH MANAGEMENT LTD              (Added 12/03/2020)
					'1340', -- McDONALDS DIE CASTING                       (Added 12/03/2020)
					'1380', -- MIDLAND POLISHING AND PLATING               (Added 12/03/2020)
					'1390', -- MIDLAND STEEL SECTIONS LTD                  (Added 12/03/2020)
					'1940', -- McAuliffe Civil Engineering Limited         (Added 12/03/2020)
					'1980', -- SYDNEY MITCHELL SOLICITORS LLP              (Added 12/03/2020)
					'2120', -- WALL JAMES CHAPPELL                         (Added 12/03/2020)
					'2150', -- D.S. WILLETTS (STAINLESS) LTD               (Added 12/03/2020)
					'2590', -- GORDANO PACKAGING                           (Added 12/03/2020)
					'2760', -- INTERNATIONAL PLYWOOD                       (Added 12/03/2020)
					'3010', -- QPS LIMITED                                 (Added 12/03/2020)
					'3021', -- Bibby Distribution Ltd                      (Added 12/03/2020)
					'3090', -- DENSIT WEAR PROTECTION UK LTD               (Added 12/03/2020)
					'3190', -- RONALD SHAW & CO                            (Added 12/03/2020)
					'3390', -- QUANTA TRAINING                             (Added 12/03/2020)
					'3410', -- RALPH MARTINDALE & CO LTD                   (Added 12/03/2020)
					'3480', -- STAFFORDSHIRE SPORTS INJURY CLINIC          (Added 12/03/2020)
					'3560', -- PREMIER ELECTRICAL LTD                      (Added 12/03/2020)
					'3670', -- Argos Distribution Ltd                      (Added 12/03/2020)
					'3750', -- PITT GODDEN & TAYLOR                        (Added 12/03/2020)
					'3990', -- PROJECT MANAGEMENT LTD                      (Added 12/03/2020)
					'4070', -- WHITING LANDSCAPES                          (Added 12/03/2020)
					'4350', -- FBC Manby Steward Bowdler LLP               (Added 12/03/2020)
					'4400', -- HOWARD BROTHERS (ENGRAVERS LTD)             (Added 12/03/2020)
					'4410', -- HONEYWELL HYMATIC                           (Added 12/03/2020)
					'4470', -- KL PLESTER INSURANCE                        (Added 12/03/2020)
					'4510', -- R V ASTLEY LTD                              (Added 12/03/2020)
					'4630', -- 101 ENGINEERING LTD                         (Added 12/03/2020)
					'4660', -- SECAL SHEET METAL LTD                       (Added 12/03/2020)
					'5120', -- OLIVER JONES ASSOCIATES                     (Added 12/03/2020)
					'6610', -- FIBERCILL                                   (Added 12/03/2020)
					'6611', -- FIBERCILL                                   (Added 12/03/2020)
					'7050', -- HICKMAN INDUSTRIES LIMITED                  (Added 12/03/2020)
					'7260', -- PRUFTECHNIK LTD                             (Added 12/03/2020)
					'8310', -- USBOURNE PUBLISHING                         (Added 12/03/2020)
					'8912', -- Mortgage Advice Bureau                      (Added 12/03/2020)
					'9090', -- BHYLLSACRE COUNTY PRI SCH                   (Added 12/03/2020)
					'9150', -- ROSSI CLOTHING                              (Added 12/03/2020)
					'9530', -- REIS ENGINEERING LTD                        (Added 12/03/2020)
					'9610', -- E W S MANUFACTURING LTD                     (Added 12/03/2020)
					'9830', -- WARDTEC LIMITED                             (Added 12/03/2020)
					'10060', -- JONATHON LEE RECRUITMENT                    (Added 12/03/2020)
					'10300', -- INDUSTRIAL ENGINEERING PLASTICS LTD         (Added 12/03/2020)
					'10430', -- ALW FINISHING                               (Added 12/03/2020)
					'10540', -- CASTLEWAY DENTAL CARE                       (Added 12/03/2020)
					'10930', -- AUTOTECHNIK SYSTEMS                         (Added 12/03/2020)
					'10960', -- G E ROBINSON & CO LTD                       (Added 12/03/2020)
					'11283', -- BUPA DENTAL CTR-NEWCTLE UNDER LYME P0626    (Added 12/03/2020)
					'11800', -- ATHLONE EXTRUSIONS (UK) LTD                 (Added 12/03/2020)
					'12350', -- GADSBY NICHOLS                              (Added 12/03/2020)
					'12860', -- Palletways UK Ltd - FULFILMENT              (Added 12/03/2020)
					'13040', -- BLESSED WILLIAM HOWARD - SCC                (Added 12/03/2020)
					'13340', -- BELMONT PRIMARY SCHOOL                      (Added 12/03/2020)
					'13400', -- WALMLEY DENTAL PRACTICE                     (Added 12/03/2020)
					'13520', -- GOODWINS FUNERAL DIRECTORS                  (Added 12/03/2020)
					'13730', -- STIKIT LABEL COMPANY LTD                    (Added 12/03/2020)
					'13840', -- Kasdon Electronics Ltd                      (Added 12/03/2020)
					'14730', -- QUALITY OFFICE SUPPLIES                     (Added 12/03/2020)
					'14920', -- YOUNGS HOME BREW LTD                        (Added 12/03/2020)
					'14990', -- Cars Refrigeration Ltd                      (Added 12/03/2020)
					'15070', -- ALBANY DAY SERVICE - APRIL HAMLIN           (Added 12/03/2020)
					'15160', -- Kason Europe Limited                        (Added 12/03/2020)
					'15340', -- VOSA/ Vehicle Testing                       (Added 12/03/2020)
					'15430', -- METTEX FASTENERS LTD                        (Added 12/03/2020)
					'15490', -- CAVAGNA GROUP                               (Added 12/03/2020)
					'16060', -- FOREMARKE HALL                              (Added 12/03/2020)
					'16180', -- PROMOPACK DIGITAL STUDIOS LTD               (Added 12/03/2020)
					'16270', -- CENTRAL PLUMBING & HEATING                  (Added 12/03/2020)
					'16330', -- USED STORAGE SYSTEMS LTD                    (Added 12/03/2020)
					'16760', -- DENSTONE COLLEGE - SCC                      (Added 12/03/2020)
					'68820', -- KEY FINANCIAL SERVICES                      (Added 12/03/2020)
					'884383', -- A F BLAKEMORE & SONS LTD                    (Added 12/03/2020)
					'896686', -- PROMOPACK DIGITAL STUDIOS                   (Added 12/03/2020)
					'910769', -- EAGLE ENVELOPES LTD                         (Added 12/03/2020)
					'913003', -- GORDANO PACKAGING                           (Added 12/03/2020)
					'995313', -- 3TL LTD                                     (Added 12/03/2020)
					'1012146', -- ARGOS LTD                                   (Added 12/03/2020)
					'1023117', -- PM TRAINGING NEWCASTLE                      (Added 12/03/2020)
					'1030476', -- NOTTINGHAM CITY COUNCIL                     (Added 12/03/2020)
					'1112001', -- Oasis Dental Care Ltd - C0085               (Added 12/03/2020)
					'1165861', -- McDONALDS DIE CASTING                       (Added 12/03/2020)
					-- added extra for Customer Hierarchies ARG 17/03/2020
					'1243644', -- BELU WATER
					-- added more for hierarchies ARG 23/03/2020
					'912031',	--STAFFS PURCHASING KEY ACC BOTTLED       
					'999408',	--INTERSERVE PLC - POU KEY ACCOUNT        
					'1009859',	--ARGOS + HOMEBASE KEY ACC BOTTLED        
					'1046741'	--ALLMANHALL - KEY ACC BOTTLED    
					
					)
					BEGIN
						SET @ResultVar = 1;
					END


	RETURN @ResultVar

END
GO
