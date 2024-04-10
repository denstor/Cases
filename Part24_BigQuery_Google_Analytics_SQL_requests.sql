-- Examples of building requests for Google Analytics

-- Opion 1: Average amount of money spent per purchase session by user (inside request)
create temporary function GetVar(params any type, target_key any type)
as
((select `value` from unnest(params) where key=target_key));

select
user_pseudo_id,
GetVar(event_params,'ga_session_id').int_value AS session_id,
coalesce(GetVar(event_params,'value').int_value,
  GetVar(event_params,'value').float_value,
  GetVar(event_params,'value').double_value,0.0) AS spend_value

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
and event_name='purchase';

-- Opion 1: Average amount of money spent per purchase session by user (full solution)

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
round(sum(spend_value)/count(distinct session_id),2) AS avg_spend_per_session_by_user,
sum(round(sum(spend_value)/count(distinct session_id),2)) over (order by round(sum(spend_value)/count(distinct session_id),2) desc rows between unbounded preceding and current row) as cumulative_avg_psend
from sessions_info
where session_id is not null
group by 1
order by 3 desc;

-- Option 2: Average amount of money spent per purchase session by user (inside request)
create temporary function GetVar(params any type, target_key any type)
as
((select coalesce(`value`.int_value,`value`.float_value,`value`.double_value) from unnest(params) where key=target_key));

select
user_pseudo_id,
GetVar(event_params,'ga_session_id') AS session_id,
GetVar(event_params,'value') AS spend_value

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
and event_name='purchase';

-- Option 2: Average amount of money spent per purchase session by user (full solution)

create temporary function GetVar(params any type, target_key any type)
as
((select coalesce(`value`.int_value,`value`.float_value,`value`.double_value) from unnest(params) where key=target_key));

with sessions_info as
(
select
user_pseudo_id,
GetVar(event_params,'ga_session_id') AS session_id,
GetVar(event_params,'value') AS spend_value

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
and event_name='purchase'
)
select 
user_pseudo_id,
count(distinct session_id) AS session_count,
round(sum(spend_value)/count(distinct session_id),2) AS avg_spend_per_session_by_user,
sum(round(sum(spend_value)/count(distinct session_id),2)) over (order by round(sum(spend_value)/count(distinct session_id),2) desc rows between unbounded preceding and current row) as cumulative_avg_psend
from sessions_info
where session_id is not null
group by 1
order by 3 desc;

-- Option 3: Average amount of money spent per purchase session by user with Left Join (inside request)

select 
events.user_pseudo_id,
session.value.int_value AS session_id,
coalesce(value.value.int_value,value.value.float_value,value.value.double_value,0.0) AS spend_value

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` as events
  left join unnest(events.event_params) as session
  on session.key='ga_session_id'

  left join unnest(events.event_params) as value
  on value.key='value'
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
and event_name='purchase';

-- Option 3: Average amount of money spent per purchase session by user with Left Join (full solution)

with sessions_info as
(
select 
events.user_pseudo_id,
session.value.int_value AS session_id,
coalesce(value.value.int_value,value.value.float_value,value.value.double_value,0.0) AS spend_value

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` as events
  left join unnest(events.event_params) as session
  on session.key='ga_session_id'

  left join unnest(events.event_params) as value
  on value.key='value'
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
and event_name='purchase'
)
select 
user_pseudo_id,
count(distinct session_id) AS session_count,
sum(spend_value)/count(distinct session_id) AS avg_spend_per_session_by_user,
sum(sum(spend_value)/count(distinct session_id)) over (order by sum(spend_value)/count(distinct session_id) desc rows between unbounded preceding and current row) as cumulative_avg_psend
from sessions_info
where session_id is not null
group by 1
order by 3 desc;

-- Products purchased by customers who purchased a specific product (inside request)

select
user_pseudo_id,
array_agg(struct(item_name,quantity)) AS item_list

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
unnest(items)

WHERE _TABLE_SUFFIX BETWEEN '20201201' AND '20201210'
and event_name='purchase'
group by 1;


-- Products purchased by customers who purchased a specific product (full solution)

declare target_item string default 'Google Navy Speckled Tee';

with item_info as
(
select
user_pseudo_id,
array_agg(struct(item_name,quantity)) AS item_list

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
unnest(items)

WHERE _TABLE_SUFFIX BETWEEN '20201201' AND '20201210'
and event_name='purchase'
group by 1
)
select
IL.item_name AS item_name,
sum(IL.quantity) AS quantity

from item_info,
unnest(item_list) as IL

where target_item in (select item_name from unnest(item_list))
and IL.item_name!=target_item
group by 1
order by 2 desc;

-- Get the latest ga_session_id and ga_session_number for specific users (draft solution)

declare user_list array<string> default
['1011733.4592975850','1031513.2105440683','1040884.6872894995'];

create temporary function GetVar(params any type, target_key any type)
as
((select `value`.int_value from unnest(params) where key=target_key));

select
user_pseudo_id,
GetVar(event_params,'ga_session_id') AS ga_session_id,
GetVar(event_params,'ga_session_number') AS ga_session_number,
row_number() over (partition by user_pseudo_id order by event_timestamp desc) as rank_by_user

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
and user_pseudo_id in unnest(user_list)
order by 1, event_timestamp desc;

-- Get the latest ga_session_id and ga_session_number for specific users (full optimized solution)

declare user_list array<string> default
['1011733.4592975850','1031513.2105440683','1040884.6872894995'];

create temporary function GetVar(params any type, target_key any type)
as
((select `value`.int_value from unnest(params) where key=target_key));

select
distinct user_pseudo_id,
first_value(GetVar(event_params,'ga_session_id')) over (UserWindow) AS ga_session_id,
first_value(GetVar(event_params,'ga_session_number')) over (UserWindow) AS ga_session_number

FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20210131'
and user_pseudo_id in unnest(user_list)
window UserWindow as (partition by user_pseudo_id order by event_timestamp desc);



