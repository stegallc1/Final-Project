SELECT
  SparcsN4.dbo.road_truck_transactions.created,
  SparcsN4.dbo.road_truck_transactions.creator,
  SparcsN4.dbo.road_truck_transactions.had_trouble,
  SparcsN4.dbo.road_truck_transactions.sub_type,
  SparcsN4.dbo.road_truck_transactions.status,
  SparcsN4.dbo.road_truck_transactions.appointment_nbr,
  SparcsN4.dbo.road_truck_transactions.trkco_id,
  SparcsN4.dbo.road_truck_transactions.ctr_id
FROM
  SparcsN4.dbo.road_truck_transactions
WHERE
  ((SparcsN4.dbo.road_truck_transactions.sub_type = 'RE' OR
    SparcsN4.dbo.road_truck_transactions.sub_type = 'DI' OR
    SparcsN4.dbo.road_truck_transactions.sub_type = 'DM' OR
    SparcsN4.dbo.road_truck_transactions.sub_type = 'RM') AND
  SparcsN4.dbo.road_truck_transactions.created > '2/17/2020 00:00:00' AND
  SparcsN4.dbo.road_truck_transactions.creator = 'NASCENTAPI' AND
  SparcsN4.dbo.road_truck_transactions.had_trouble IS NULL AND
  SparcsN4.dbo.road_truck_transactions.status = 'Complete') OR
  (SparcsN4.dbo.road_truck_transactions.status = 'ok')
