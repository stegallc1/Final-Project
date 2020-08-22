SELECT
  TOSGateway.dbo.vwTruckVisitDetails.entered_yard,
  TOSGateway.dbo.vwTruckVisitDetails.exited_yard,
  TOSGateway.dbo.vwTruckVisitDetails.truck_license_nbr,
  TOSGateway.dbo.vwTruckVisitDetails.trkco_name,
  TOSGateway.dbo.vwTruckTransactions.seq_within_facility,
  TOSGateway.dbo.vwTruckTransactions.sub_type,
  TOSGateway.dbo.vwTruckTransactions.had_trouble,
  TOSGateway.dbo.vwTruckTransactions.ctr_ticket_pos_id,
  TOSGateway.dbo.vwTruckTransactions.line_id,
  TOSGateway.dbo.vwTruckTransactions.is_oog,
  TOSGateway.dbo.vwTruckTransactions.ctr_id_assigned,
  TOSGateway.dbo.vwTruckTransactions.status AS status1
FROM
  TOSGateway.dbo.vwTruckTransactions
  INNER JOIN TOSGateway.dbo.vwTruckVisitDetails ON TOSGateway.dbo.vwTruckTransactions.truck_visit_gkey =
    TOSGateway.dbo.vwTruckVisitDetails.tvdtls_gkey
WHERE
  TOSGateway.dbo.vwTruckTransactions.sub_type = 'DI' AND
  TOSGateway.dbo.vwTruckTransactions.had_trouble IS NULL AND
  TOSGateway.dbo.vwTruckTransactions.is_oog = 'False' AND
  TOSGateway.dbo.vwTruckVisitDetails.entered_yard >= DateAdd(DAY, DateDiff(DAY, 0, GetDate()), 0) AND
  TOSGateway.dbo.vwTruckTransactions.ctr_id_assigned = 'TGBU2321622' AND
  TOSGateway.dbo.vwTruckTransactions.status = 'OK'
