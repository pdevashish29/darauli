# darauli



	SELECT  		to_Char(EM.CREATION_DATE,'Day') as "days",
							EM.ESTIMATE_ID ,
							ESD.DESCRIPTION,
							ESD.HOURS,
							ESD.TECH,
							ESD.DESCRIPTION_ID, 
							ESD.START_TIME, 
							ESD.END_TIME, 
							ESD.TOTAL_HR 
							NO
							FROM 
							ESTIMATE_MAIN EM 
							LEFT JOIN ESTIMATE_DESCRIPTION ED ON EM.ESTIMATE_ID = ED.ESTIMATE_ID 
							LEFT JOIN   ESTIMATE_SERVICE ES ON ES.DESCRIPTION_ID = ED.DESCRIPTION_ID 
							LEFT JOIN   ESTIMATE_SER_DES ESD ON ES.SERVICE_ID = ESD.SERVICE_ID  
							WHERE  ES.DECLINED_FLAG='N' AND  EM.SENDER_ID =1 
              AND (ESD.HOURS IS NOT NULL AND ESD.HOURS !=0) AND ESD.TECH IS NOT NULL 
							AND EM.CREATION_DATE >=TO_DATE('06/17/2016 00:00:00', 'MM/DD/YYYY HH24:MI:SS') AND EM.CREATION_DATE <=TO_DATE('06/17/2016 23:59:59', 'MM/DD/YYYY HH24:MI:SS')
              
              UNION                          
							SELECT 
		                    to_Char(EM.CREATION_DATE,'Day') as "days", 
                      	EM.ESTIMATE_ID,
		                    ESD.DESCRIPTION,
		                    ESD.HOURS,
		                    ESD.TECH,
		                    ESD.DESCRIPTION_ID, 
		                    ESD.START_TIME, 
		                    ESD.END_TIME, 
		                    ESD.TOTAL_HR
		                     NO
		                    FROM ESTIMATE_MAIN EM LEFT JOIN ESTIMATE_DESCRIPTION ED ON EM.ESTIMATE_ID = ED.ESTIMATE_ID   LEFT JOIN ESTIMATE_PACKAGE_REL EPR ON ED.DESCRIPTION_ID = EPR.ESTIMATE_ID 
		                    LEFT JOIN ESTIMATE_PACKAGE EP ON EP.PACKAGE_ID = EPR.ID 
		                    LEFT JOIN ESTIMATE_SERVICE ES ON ES.PACKAGE_ID = EP.ID 
		                    LEFT JOIN ESTIMATE_SER_DES ESD ON ESD.SERVICE_ID = ES.SERVICE_ID 
		                    WHERE ES.DECLINED_FLAG='N' AND EM.SENDER_ID =1 
                        And
                        esd.tech is not null
		                    AND EM.CREATION_DATE >=TO_DATE('06/17/2016  00:00:00', 'MM/DD/YYYY HH24:MI:SS') AND EM.CREATION_DATE <=TO_DATE('06/17/2016 23:59:59', 'MM/DD/YYYY HH24:MI:SS') 
                        

union


select 
               to_Char(EM.CREATION_DATE,'Day') as "days",
						  EM.ESTIMATE_ID, 
						  'Package:' ||EPR.PACKAGE_NAME,
						  0 ,
						  EPR.TECH, 
						  EPR.ID,  
						  EPR.START_TIME, 
						  EPR.END_TIME, 
						  EPR.TOTAL_HR
						  YES
						  from ESTIMATE_MAIN EM,ESTIMATE_PACKAGE_REL EPR,ESTIMATE_DESCRIPTION ED WHERE EPR.ID IN
              (1085, 1288, 1310, 1324, 1453, 1470, 1482, 1492, 1494, 1546, 1570, 1735, 1736, 1745, 1812, 1816, 1822, 1861, 1894, 1906, 1938, 2069, 2082, 2088, 2092, 2095, 2097, 2173, 2179, 2180, 2181, 2182, 2183, 2184, 2185, 2193, 2202, 2214, 2216, 2251, 2252, 2253, 2277, 2278, 2303, 2328, 2366, 2417, 2460, 2564, 2935, 2994, 3007, 3011, 3014, 3039, 3104, 3131, 3145, 3149, 3170, 3183, 3212, 3257, 3281, 3289, 3290, 3291, 3292, 3297, 3298, 3306, 3307, 3308, 3309, 3312, 3313, 3315, 3316, 3317, 3318, 3320, 3321, 3323, 3324, 3325, 3326, 3327, 3328, 3340, 3341, 3342, 3344, 3408, 3417, 3418, 3425, 3464, 3495, 3496, 3505, 3558, 3565, 3566, 3608, 3617, 3618, 3629, 3724, 3739, 3741, 3742, 3743, 3809, 3820, 3865, 3901, 3928, 3929, 3933, 4008, 4014, 4026, 4036, 4041, 4056, 4058, 4144, 4188, 4203, 4204, 4338, 4508, 4559, 4788, 4896, 4897, 4898, 4899, 4900, 4988, 5004, 5185, 5250, 5289, 5315, 5334, 5338, 5339, 5361, 5391, 5490, 5518, 5539, 5565, 5566, 5582, 5597, 5608, 5659, 5708, 5768, 5774, 5900, 5973, 5980, 5984, 6015, 6102, 6133, 6140, 6144, 6145, 6151, 6182, 6186, 6193, 6194, 6195, 6220, 6236, 6239, 6276, 6280, 6286, 6311, 6324, 6347, 6350, 6373, 6375, 6376, 6447, 6461, 6488, 6491, 6629, 6823, 6847, 6853, 6935, 6936, 6944, 6954, 7069, 7157, 7167, 7292, 7338, 7391, 7437, 7507, 7625, 7633, 7685, 7967, 7979, 8181, 8294, 8329, 8330, 8398, 8409, 8566, 8581, 8582, 8625, 8636, 8649, 8710, 8711, 8714, 8719, 8824, 8825, 8840, 8859, 8998, 9059, 9096, 9097, 9100, 9139, 9178, 9212, 9365, 9382, 9466, 9467, 9468, 9469, 9514, 9515, 9567, 9578, 9579, 9584, 9591, 9674, 9691, 9721, 9729, 9798, 9802, 9803, 9838, 9885, 9909, 9910, 9956, 9973, 9994, 10091, 10092, 10108, 10129, 10130, 10168, 10179, 10252, 10316, 10381, 10394, 10531, 10557, 10558, 10591, 10601, 10639, 10647, 10864, 10875, 11172, 11173, 11190, 11199, 11239, 11255, 11392, 11398, 11479, 11522, 11524, 11525, 11528, 11552, 11576, 11594, 11595, 11613, 11615, 11657, 11667, 11679, 11700, 11701, 11731, 11748, 11749, 11752, 11791, 11812, 11813, 12020, 12044, 12060, 12322, 12323, 12505, 12548, 12592, 12598, 12626, 12628, 12681, 12682, 12683, 12684, 12709, 12713, 12714, 12743, 12775, 12776, 12777, 12810, 12814, 12843, 12872, 12899, 12923, 12953, 12954, 13008, 13009, 13038, 13039, 13041, 13172, 13187, 13246, 13379, 13437, 13442, 13533, 13570, 13575, 13576, 13615, 13631, 13646, 13647, 13707, 13821, 13827, 13828, 13846, 13900, 13902, 13988, 13997, 14005, 14053, 14065, 14066, 14081, 14115, 14140, 14161, 14166, 14316, 14343, 14368, 14371, 14388, 14438, 14487, 14496, 14507, 14524, 14531, 14575, 14643, 14686, 14723, 14784, 14794, 14812, 14817, 14839, 14840, 14864, 14878, 14886, 14887, 14896, 14900, 14963, 14976, 14989, 15056, 15062, 15066, 15311, 15317, 15384, 15385, 15389, 15390, 15393, 15434, 15437, 15438, 15439, 15442, 15443, 15444, 15445, 15446, 15447, 15449, 15478, 15589, 15827, 15828, 15862, 15893, 15908, 15910, 15931, 16006, 16145, 16146)

              AND  EM.ESTIMATE_ID =ED.ESTIMATE_ID AND ED.DESCRIPTION_ID = EPR.ESTIMATE_ID 
						  AND EPR.TECH IS NOT NULL AND EPR.DECLINED_FLAG='N'  AND EM.CREATION_DATE >=TO_DATE('06/17/2016 00:00:00', 'MM/DD/YYYY HH24:MI:SS') AND EM.CREATION_DATE <=TO_DATE('06/17/2016 23:59:59', 'MM/DD/YYYY HH24:MI:SS') AND EM.SENDER_ID=1
             
            
              order by Tech;
              
              
              select  er.tech, er.TOTAL_HR from ESTIMATE_SER_DES er where er.tech is not null and  er.TOTAL_HR is not null; 
				
        ========================================================================================================================
        
        
        	SELECT  		to_Char(EM.CREATION_DATE,'Day') as "days",
							EM.ESTIMATE_ID ,
							ESD.DESCRIPTION,
							ESD.HOURS,
							ESD.TECH,
							ESD.DESCRIPTION_ID, 
							ESD.START_TIME, 
							ESD.END_TIME, 
							ESD.TOTAL_HR 
							NO
							FROM 
							ESTIMATE_MAIN EM 
							LEFT JOIN ESTIMATE_DESCRIPTION ED ON EM.ESTIMATE_ID = ED.ESTIMATE_ID 
							LEFT JOIN   ESTIMATE_SERVICE ES ON ES.DESCRIPTION_ID = ED.DESCRIPTION_ID 
							LEFT JOIN   ESTIMATE_SER_DES ESD ON ES.SERVICE_ID = ESD.SERVICE_ID  
							WHERE  ES.DECLINED_FLAG='N' AND  EM.SENDER_ID =1 
              AND (ESD.HOURS IS NOT NULL AND ESD.HOURS !=0) AND ESD.TECH IS NOT NULL 
							AND EM.CREATION_DATE >=TO_DATE('06/01/2016 00:00:00', 'MM/DD/YYYY HH24:MI:SS') AND EM.CREATION_DATE <=TO_DATE('06/30/2016 23:59:59', 'MM/DD/YYYY HH24:MI:SS')
              
              UNION                          
							SELECT 
		                    to_Char(EM.CREATION_DATE,'Day') as "days", 
                      	EM.ESTIMATE_ID,
		                    ESD.DESCRIPTION,
		                    ESD.HOURS,
		                    ESD.TECH,
		                    ESD.DESCRIPTION_ID, 
		                    ESD.START_TIME, 
		                    ESD.END_TIME, 
		                    ESD.TOTAL_HR
		                     NO
		                    FROM ESTIMATE_MAIN EM LEFT JOIN ESTIMATE_DESCRIPTION ED ON EM.ESTIMATE_ID = ED.ESTIMATE_ID   LEFT JOIN ESTIMATE_PACKAGE_REL EPR ON ED.DESCRIPTION_ID = EPR.ESTIMATE_ID 
		                    LEFT JOIN ESTIMATE_PACKAGE EP ON EP.PACKAGE_ID = EPR.ID 
		                    LEFT JOIN ESTIMATE_SERVICE ES ON ES.PACKAGE_ID = EP.ID 
		                    LEFT JOIN ESTIMATE_SER_DES ESD ON ESD.SERVICE_ID = ES.SERVICE_ID 
		                    WHERE ES.DECLINED_FLAG='N' AND EM.SENDER_ID =1 
                        And
                        esd.tech is not null
		                    AND EM.CREATION_DATE >=TO_DATE('06/01/2016  00:00:00', 'MM/DD/YYYY HH24:MI:SS') AND EM.CREATION_DATE <=TO_DATE('06/30/2016 23:59:59', 'MM/DD/YYYY HH24:MI:SS') 
                        

union


select 
               to_Char(EM.CREATION_DATE,'Day') as "days",
						  EM.ESTIMATE_ID, 
						  'Package:' ||EPR.PACKAGE_NAME,
						  0 ,
						  EPR.TECH, 
						  EPR.ID,  
						  EPR.START_TIME, 
						  EPR.END_TIME, 
						  EPR.TOTAL_HR
						  YES
						  from ESTIMATE_MAIN EM,ESTIMATE_PACKAGE_REL EPR,ESTIMATE_DESCRIPTION ED WHERE EPR.ID IN
              (1085, 1288, 1310, 1324, 1453, 1470, 1482, 1492, 1494, 1546, 1570, 1735, 1736, 1745, 1812, 1816, 1822, 1861, 1894, 1906, 1938, 2069, 2082, 2088, 2092, 2095, 2097, 2173, 2179, 2180, 2181, 2182, 2183, 2184, 2185, 2193, 2202, 2214, 2216, 2251, 2252, 2253, 2277, 2278, 2303, 2328, 2366, 2417, 2460, 2564, 2935, 2994, 3007, 3011, 3014, 3039, 3104, 3131, 3145, 3149, 3170, 3183, 3212, 3257, 3281, 3289, 3290, 3291, 3292, 3297, 3298, 3306, 3307, 3308, 3309, 3312, 3313, 3315, 3316, 3317, 3318, 3320, 3321, 3323, 3324, 3325, 3326, 3327, 3328, 3340, 3341, 3342, 3344, 3408, 3417, 3418, 3425, 3464, 3495, 3496, 3505, 3558, 3565, 3566, 3608, 3617, 3618, 3629, 3724, 3739, 3741, 3742, 3743, 3809, 3820, 3865, 3901, 3928, 3929, 3933, 4008, 4014, 4026, 4036, 4041, 4056, 4058, 4144, 4188, 4203, 4204, 4338, 4508, 4559, 4788, 4896, 4897, 4898, 4899, 4900, 4988, 5004, 5185, 5250, 5289, 5315, 5334, 5338, 5339, 5361, 5391, 5490, 5518, 5539, 5565, 5566, 5582, 5597, 5608, 5659, 5708, 5768, 5774, 5900, 5973, 5980, 5984, 6015, 6102, 6133, 6140, 6144, 6145, 6151, 6182, 6186, 6193, 6194, 6195, 6220, 6236, 6239, 6276, 6280, 6286, 6311, 6324, 6347, 6350, 6373, 6375, 6376, 6447, 6461, 6488, 6491, 6629, 6823, 6847, 6853, 6935, 6936, 6944, 6954, 7069, 7157, 7167, 7292, 7338, 7391, 7437, 7507, 7625, 7633, 7685, 7967, 7979, 8181, 8294, 8329, 8330, 8398, 8409, 8566, 8581, 8582, 8625, 8636, 8649, 8710, 8711, 8714, 8719, 8824, 8825, 8840, 8859, 8998, 9059, 9096, 9097, 9100, 9139, 9178, 9212, 9365, 9382, 9466, 9467, 9468, 9469, 9514, 9515, 9567, 9578, 9579, 9584, 9591, 9674, 9691, 9721, 9729, 9798, 9802, 9803, 9838, 9885, 9909, 9910, 9956, 9973, 9994, 10091, 10092, 10108, 10129, 10130, 10168, 10179, 10252, 10316, 10381, 10394, 10531, 10557, 10558, 10591, 10601, 10639, 10647, 10864, 10875, 11172, 11173, 11190, 11199, 11239, 11255, 11392, 11398, 11479, 11522, 11524, 11525, 11528, 11552, 11576, 11594, 11595, 11613, 11615, 11657, 11667, 11679, 11700, 11701, 11731, 11748, 11749, 11752, 11791, 11812, 11813, 12020, 12044, 12060, 12322, 12323, 12505, 12548, 12592, 12598, 12626, 12628, 12681, 12682, 12683, 12684, 12709, 12713, 12714, 12743, 12775, 12776, 12777, 12810, 12814, 12843, 12872, 12899, 12923, 12953, 12954, 13008, 13009, 13038, 13039, 13041, 13172, 13187, 13246, 13379, 13437, 13442, 13533, 13570, 13575, 13576, 13615, 13631, 13646, 13647, 13707, 13821, 13827, 13828, 13846, 13900, 13902, 13988, 13997, 14005, 14053, 14065, 14066, 14081, 14115, 14140, 14161, 14166, 14316, 14343, 14368, 14371, 14388, 14438, 14487, 14496, 14507, 14524, 14531, 14575, 14643, 14686, 14723, 14784, 14794, 14812, 14817, 14839, 14840, 14864, 14878, 14886, 14887, 14896, 14900, 14963, 14976, 14989, 15056, 15062, 15066, 15311, 15317, 15384, 15385, 15389, 15390, 15393, 15434, 15437, 15438, 15439, 15442, 15443, 15444, 15445, 15446, 15447, 15449, 15478, 15589, 15827, 15828, 15862, 15893, 15908, 15910, 15931, 16006, 16145, 16146)

              AND  EM.ESTIMATE_ID =ED.ESTIMATE_ID AND ED.DESCRIPTION_ID = EPR.ESTIMATE_ID 
						  AND EPR.TECH IS NOT NULL AND EPR.DECLINED_FLAG='N'  AND EM.CREATION_DATE >=TO_DATE('06/01/2016 00:00:00', 'MM/DD/YYYY HH24:MI:SS') AND EM.CREATION_DATE <=TO_DATE('06/30/2016 23:59:59', 'MM/DD/YYYY HH24:MI:SS') AND EM.SENDER_ID=1
             
            
              order by Tech;
        
        
        
    
      
      
      ========================================================================
      
      
      select level as dow,
    to_char(trunc(sysdate ,'day') + level , 'Day',
        'NLS_DATE_LANGUAGE=ENGLISH') as day
from dual
connect by level <= 5;
=========================================================================================
select to_char(em.CREATION_DATE,'Day') as "days" , count(*) from ESTIMATE_MAIN em  GROUP BY to_char(em.CREATION_DATE,'Day') ;





 	SELECT  		to_Char(EM.CREATION_DATE,'Day') as "days",
  EM.CREATION_DATE,
							EM.ESTIMATE_ID ,
							ESD.DESCRIPTION,
							ESD.HOURS,
							ESD.TECH,
							ESD.DESCRIPTION_ID, 
							ESD.START_TIME, 
							ESD.END_TIME, 
							ESD.TOTAL_HR NO
							FROM 
							ESTIMATE_MAIN EM 
							LEFT JOIN ESTIMATE_DESCRIPTION ED ON EM.ESTIMATE_ID = ED.ESTIMATE_ID 
							LEFT JOIN   ESTIMATE_SERVICE ES ON ES.DESCRIPTION_ID = ED.DESCRIPTION_ID 
							LEFT JOIN   ESTIMATE_SER_DES ESD ON ES.SERVICE_ID = ESD.SERVICE_ID  
							WHERE  ES.DECLINED_FLAG='N' AND  EM.SENDER_ID =1 
              AND (ESD.HOURS IS NOT NULL AND ESD.HOURS !=0) AND ESD.TECH IS NOT NULL 
							AND EM.CREATION_DATE >=TO_DATE('06/072016 00:00:00', 'MM/DD/YYYY HH24:MI:SS') AND EM.CREATION_DATE <=TO_DATE('06/07/2016 23:59:59', 'MM/DD/YYYY HH24:MI:SS')
              





============================================================================================================

select to_char(em.creation_date,'day'), em.creation_date ,count(em.creation_date) from estimate_main em group by em.creation_date;














