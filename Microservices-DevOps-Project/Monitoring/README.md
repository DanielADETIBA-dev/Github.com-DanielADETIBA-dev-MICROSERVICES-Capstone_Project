# Montoring

First create the monitoring namespace using the `00-monitoring-ns.yaml` file:

    $ kubectl create -f 00-monitoring-ns.yaml


### Prometheus

To deploy simply apply all the prometheus manifests (01-10) in any order:

    kubectl apply $(ls *-prometheus-*.yaml | awk ' { print " -f " $1 } ')

The prometheus server will be exposed on Nodeport `9090`using the command:

    kubectl port-forward service/prometheus 9090:9090 -n monitoring

Access the Prometheus UI in your browser using:

    http://localhost:9090

### Grafana

First apply the grafana manifests from 20 to 22:

    kubectl apply $(ls *-grafana-*.yaml | awk ' { print " -f " $1 }'  | grep -v grafana-import)

Once the grafana pod is in the Running state apply the `23-grafana-import-dash-batch.yaml` manifest to import the Dashboards:

    kubectl apply -f 23-grafana-import-dash-batch.yaml

Grafana will be exposed on the NodePort `31300` with the command:

    kubectl port-forward service/grafana 31300:80 -n monitoring

Access the Grafana UI in your browser using:

    http://localhost:31300


### Setting-up and Configuring Grafana 

#### Update Grafana Data Source

Keep Prometheus running and accessible in your browser, then OPEN Grafana in another tab and update the data source URL in Grafana.

#### Log in to Grafana:

- Open Grafana in your browser using the URL above and log in. 
- Input `admin` as `username` and `admin` also as `password`.

#### Update Data Source:

- Go to Configuration -> Data Sources -> Add Data Sources
- Select Prometheus data source.
- Update the URL to `http://prometheus.monitoring.svc.cluster.local:9090`
- Click ON Save and Test

You will get a notification of `Data Source Working`.

#### Creating Custom Dashboards

`Add a New Dashboard:`

- Click on the Plus `+` icon on the left sidebar.
- Select Dashboard and then Add new panel.

`Configure the Panel:`

- Select the Prometheus data source.
- Use PromQL (Prometheus Query Language) to query the metrics you are interested in.
- Configure the visualization type, such as graph, table, or gauge.
- Input dashboard name and description (optional).
- Apply and Save the Dashboard

`Examples of Prometheus Queries:` 

    sum(rate(node_cpu_seconds_total{mode!="idle"}[5m])) by (instance)

This query shows the CPU Usage of all Nodes

---

    sum(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) by (instance)

This query shows the Memory usage of all Nodes

