# Some demo content in vw_aggregrated.sql
SELECT 
   user_pseudo_id, count(*) as quantity
FROM
   `terraform-420806.demoset.demotable`
   group by 1
   order by 2 desc