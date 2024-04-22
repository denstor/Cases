# Some demo content in vw_aggregrated.sql
   
create temporary function GetVar(params any type, target_key any type)
as
((select `value` from unnest(params) where key=target_key));

with sessions_info as
(
select
user_pseudo_id,
GetVar(event_params,'ga_session_id').int_value AS session_id,
coalesce(GetVar(event_params,'value').int_value,
  GetVar(event_params,'value').float_value,
  GetVar(event_params,'value').double_value,0.0) AS spend_value

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
and event_name='purchase'
)
select 
user_pseudo_id,
count(distinct session_id) AS session_count,
round(sum(spend_value)/count(distinct session_id),2) AS avg_spend_per_session_by_user
from sessions_info
where session_id is not null
group by 1
order by 3 desc
