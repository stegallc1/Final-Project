SELECT va.[unit_id] AS eq_nbr,
       CASE va.[arrive_pos_loctype]
           WHEN 'RAILCAR' THEN 'R'
           WHEN 'TRAIN' THEN 'R'
           WHEN 'TRUCK' THEN 'T'
           WHEN 'VESSEL' THEN 'V'
           WHEN 'YARD' THEN 'Y'
       END AS [in_loc_type],	
       va.[arrive_pos_locid] AS in_loc_id,
       va.[actual_ib_vesselId] AS IN_VISIT_ID,
       --IIF(va.[category] = 'IMPRT', 'I', '') AS CATEGORY, 
	   va.[category] AS CATEGORY,            
       IIF(va.[freight_kind] = 'MTY', 'E', 'F') AS STATUS,
       'DISCHARGE' AS DISCHARGE,
       va.[PERFORMED],
       va.[eqsz_id],
       va.[eqtp_id],
       va.[eqht_id],
       va.[load_point_id],
       va.[discharge_point_id1],
       va.[line_id],
       CONVERT(VARCHAR(12), va.[gross_weight]) + ' ' + 'KG' EU_GROSS_WEIGHT______EU_GROSS_UNITS,
       --hazinfo.[imdg_class] as HAZ_CLASS,
	   invg.[imdg_types] AS HAZ_CLASS,
       CASE
           WHEN va.[oog_back_cm] IS NOT NULL OR 
		        va.[oog_front_cm] IS NOT NULL OR
                va.[oog_left_cm] IS NOT NULL OR 
				va.[oog_right_cm] IS NOT NULL OR 
                va.[oog_top_cm] IS NOT NULL THEN 
               'X'
		   ELSE
		       NULL
       END AS oog,
       IIF(convert(varchar(50),va.[temp_reqd_C]) IS NULL, '', convert(varchar(50),va.[temp_reqd_C])) AS temp_required,
        CASE
           WHEN Round([dbo].[SFN_ConvertKgToLb](va.[gross_weight])/ 2204,1) BETWEEN wc.[weight_class_1] 
		                                           AND wc.[weight_class_2] THEN
               '1'
           WHEN Round([dbo].[SFN_ConvertKgToLb](va.[gross_weight])/ 2204,1) BETWEEN wc.[weight_class_2] 
		                                           AND wc.[weight_class_3] THEN
               '2'
           WHEN Round([dbo].[SFN_ConvertKgToLb](va.[gross_weight])/ 2204,1) BETWEEN wc.[weight_class_3] 
		                                           AND wc.[weight_class_4] THEN
               '3'
           WHEN (Round([dbo].[SFN_ConvertKgToLb](va.[gross_weight])/ 2204,1) BETWEEN wc.[weight_class_4] 
		                                            AND wc.[weight_class_5]) OR 
                (Round([dbo].[SFN_ConvertKgToLb](va.[gross_weight])/ 2204,1) >= wc.[weight_class_4] AND
                 wc.[weight_class_5] is null) then
               '4'
           ELSE 
               '5'
       END AS weight_class
FROM   dbo.[vwVesselActivity] va
--LEFT   JOIN (SELECT invg.[hazards_gkey],
--                    invg.[gkey], 
--					ihzi.[gkey] hazard, 
--					ihzi.[hzrd_gkey],
--					ihzi.[imdg_class] 
--             FROM   [SparcsN4R]..[inv_goods] invg  
--	JOIN   [SparcsN4R]..[inv_hazard_items] ihzi on invg.[hazards_gkey] =ihzi.[hzrd_gkey]) AS hazinfo ON hazinfo.[gkey] = va.[goods]
LEFT   JOIN [SparcsN4R]..[inv_goods] AS invg ON invg.[gkey] = va.[goods]
LEFT   JOIN dbo.[WEIGHT_CLASSES] wc ON wc.[service] = va.[actual_ib_service] AND
                                       wc.[eqsz_id] = CASE
                                                          WHEN va.[actual_ib_service] = '811' THEN 
														      va.[EQSZ_ID] 
													      ELSE 
														     '1' 
													  END
WHERE  va.[VESSEL] in (UPPER(@Vessel))
AND    va.[VOYAGE] in (UPPER(@VoyageIn))
AND    va.[category] NOT IN ('STRGE','THRGH')
AND    va.[PERFORMED] IS NOT NULL
AND    (va.[line_id] IN (@Line) OR 'ALL' IN (@Line))
AND    va.[EVENT] = 'DSCH'
AND    (SELECT SUM(CASE b.[EVENT]
                       WHEN 'LOAD' THEN
	                       1
                       ELSE 
					      -1
                   END)
        FROM   dbo.[vwVesselActivity] b 
        WHERE  b.[gkey] = va.[gkey]         
        AND    b.[VESSEL] = va.[VESSEL]
        AND    b.[EVENT] in ('LOAD', 'DSCH')) <> 0