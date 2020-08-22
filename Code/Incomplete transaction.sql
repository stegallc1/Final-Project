SELECT
  TV.truck_license_nbr [License Plate],
  TT.ctr_id CTR,
  TT.created Date,
  TV.changer [User]
FROM
  SparcsN4.dbo.road_truck_transactions TT
  JOIN road_truck_visit_details TV ON TV.tvdtls_gkey = TT.truck_visit_gkey
WHERE
  TT.created > '2020-02-14 06:14:31.140' AND
  TT.sub_type IN ('DI', 'DM') AND
  TT.status = 'COMPLETE' AND
  TV.exited_yard IS NULL
