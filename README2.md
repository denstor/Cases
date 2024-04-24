Building BigQuery data pipelines with Kestra (Workflow orchestrator)

Prerequisites:


1/ Docker


2/ Kestra



Two parts (.yml files):


1/ Creating a dataset and a table from an outsourced file


2/ Creating the Analysis dataset, updating the table with new data (if added) and building specific tables. The pipeline is triggered daily at midnight



Kestra is an open-source declarative data orchestration platform that aims to make data workflows accessible to more than just data engineers. It comes with a declarative YAML interface, which means almost anyone in your organization can participate in the data pipeline creation process.

The tool packs a wide range of plugins which means you can easily work with different cloud providers (AWS, Azure, GCP), databases, file systems, Git, Kafka, Spark, Kubernetes, PowerBI, and pretty much anything else you can imagine.

Kestra addresses many Airflow shortcomings, such as:

Scalability from a developer standpoint

API and event-driven workflows

Task failings due to heavy workload

Challenging Python environment management for non-Python users

General team-level isolation and sensitive data management


More info on Kestra plug-ins for GCP - https://kestra.io/plugins/plugin-gcp

Kestra & Big Query case - https://github.com/kestra-io/docs/blob/a6c96ff4ecbc24569978e977ec8f2f6b3669ef05/content/blogs/2022-11-19-create-data-pipeline-bigquery-google-cloud.md#L4 
