SELECT
	u.id															AS [unit_nbr],
	CONCAT(u.actual_ib_vesselId, u.actual_ib_voyage)				AS [i/b actual visit],
	CASE ISNULL(u.actual_ob_carrier_mode, u.intend_ob_carrier_mode)
		WHEN 'TRUCK' THEN 'T - TRUCK'
		WHEN 'VESSEL' THEN 'V - ' + ISNULL(u.actual_ob_voyage, u.intend_ob_voyage)
		WHEN 'TRAIN' THEN 'R - ' + ISNULL(u.actual_ob_voyage, u.intend_ob_voyage)
		ELSE 'GEN_TRUCK'
	END																AS [o/b actual visit],	
	u.line															AS [line_op],
	u.last_pos_name													AS position,
	u.time_in														AS time_in,
	a.[requested_time]												AS appt_time,
	u.last_free_day													AS LFD_Override,
	CONCAT(u.EQSZ_ID, u.EQTP_ID, u.EQHT_ID)							AS equip_type,
	u.discharge_point_id1											AS [POD],
	DATEDIFF(dd, u.time_in, GETDATE())								AS dwell,
	
	isnull(g.consignee, g.consignee_bzu_id)							AS consignee
	
FROM dbo.vwUnit u
LEFT OUTER JOIN [sparcsn4].[dbo].[road_gate_appointment]       AS a
ON a.unit_gkey = u.gkey
LEFT OUTER JOIN [dbo].vwGoods g ON g.gkey = u.goodgkey
WHERE

 u.LINE <> 'UNK'
AND u.category = 'IMPRT'
AND u.time_in IS NOT NULL
AND u.visit_state = '1ACTIVE'
AND u.last_pos_loctype='YARD'
AND u.last_pos_name LIKE 'Y-LAX-[A-Q]%'
AND u.discharge_point_id1 = 'USLAX'
ORDER BY u.line, u.id