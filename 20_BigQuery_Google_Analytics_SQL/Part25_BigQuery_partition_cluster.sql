-- create two similar tables - not partiotioned/clustered and partiotioned/clustered

create or replace table ecommerce.ga4_sample
as
(
  select 
  *
  from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  where _table_suffix between '20201101' AND '20210131'
);

alter table project-test-240327.ecommerce.ga4_sample
add column date_formatted date;

update project-test-240327.ecommerce.ga4_sample
set date_formatted=date(timestamp_micros(event_timestamp)) 
where event_timestamp is not null;

create or replace table ecommerce.ga4_sample_partitioned
partition by date_formatted
cluster by event_name
as
(
  select 
  date(timestamp_micros(event_timestamp)) as date_formatted, *
  -- from bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131
  from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  where _table_suffix between '20201101' AND '20210131'
);

-- check dates, count

select date_formatted, count(*) as cases,
sum(count(*)) over (order by count(*) desc rows between unbounded preceding and current row)
from project-test-240327.ecommerce.ga4_sample
group by 1
order by 2 desc;

select date_formatted, count(*) as cases,
sum(count(*)) over (order by count(*) desc rows between unbounded preceding and current row)
from project-test-240327.ecommerce.ga4_sample_partitioned
group by 1
order by 1 desc;

-- performance check - 20 times difference!

select event_name, count(*) as cases,
sum(count(*)) over (order by count(*) desc rows between unbounded preceding and current row)
from project-test-240327.ecommerce.ga4_sample
WHERE date_formatted BETWEEN '2021-01-30' AND '2021-01-31'
group by 1
order by 2 desc;

-- lapsed time
-- 1 sec
-- Slot time consumed 
-- 1 min 23 sec
-- Bytes shuffled 
-- 109.57 KB
-- Bytes spilled to disk 
-- 0 B

select event_name, count(*) as cases,
sum(count(*)) over (order by count(*) desc rows between unbounded preceding and current row)
from project-test-240327.ecommerce.ga4_sample_partitioned
WHERE date_formatted BETWEEN '2021-01-30' AND '2021-01-31'
group by 1
order by 2 desc;

-- Elapsed time
-- 1 sec
-- Slot time consumed 
-- 1 min 13 sec
-- Bytes shuffled 
-- 5.83 KB
-- Bytes spilled to disk 
-- 0 B
