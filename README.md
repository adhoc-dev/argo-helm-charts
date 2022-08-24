# test-helm-charts






### Chart Releaser Action to Automate GitHub Page Charts

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

  helm repo add adhoc-dev-test-helm-charts https://adhoc-dev.github.io/test-helm-charts

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo
adhoc-dev-test-helm-charts` to see the charts.

To install the <chart-name> chart:

    helm install my-<chart-name> adhoc-dev-test-helm-charts/<chart-name>

To uninstall the chart:

    helm delete my-<chart-name>

The charts will be published to a website with URL like this:

https://adhoc-dev.github.io/test-helm-charts
