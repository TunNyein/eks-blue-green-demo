# Install the Datadog Agent on Kubernetes with fleet automation

https://app.datadoghq.com/fleet/install-agent/latest?platform=kubernetes&_gl=1*xlxlw8*_gcl_au*MTUxMDgxNjk2NC4xNzYzMDQ0MTc4LjYyNTI3ODM0LjE3NjM0Mzc1MDIuMTc2MzQzNzUxMQ..*_ga*MTE4MDUzMjQ5Mi4xNzYzNDM3MDgx*_ga_KN80RDFSQK*czE3NjM0MzcwODEkbzEkZzEkdDE3NjM0MzgxMTkkajEzJGwwJGgxOTc4MDA1NjUx

- Create Datadog Account 
- Install Add on DATA Operation in EKS Console 

- Create secret 

# kubectl create secret generic datadog-secret --from-literal api-key=6ec7cd6051dcf2e12d9fd50afc92e582 -n datadog-agent

# Apply Datadog agent yaml 

