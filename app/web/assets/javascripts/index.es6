//= require messages.js
//= require Chart.min.js

function fetchReportRun() {
  fetch(`/rest/v1/report/weekly/runs/last`)
    .then(response => response.json())
    .then(json => {
      this.runs = json;
      this.createNewReportGraph();
    })
    .catch(error => {
      this.showErrorMessage('Unable to fetch report batch run data');
      console.error('There was an error!', error);
    });
}

function createNewReportGraph() {
  let success = this.runs.map(x => x.success);
  let failure = this.runs.map(x => x.failure);
  new Chart(document.getElementById('lastReport'), {
    type: 'bar',
    data: {
      labels: this.runs.map(x => x.timezone),
      datasets: [{
        "fill": false,
        label: `Successful Send (${success.reduce((a, b) => a + b, 0)})`,
        data: success,
        backgroundColor: "rgba(50, 210, 80, 0.4)",
        borderColor: "rgb(50, 210, 80)",
        "borderWidth": 1,
      },
      {
        label: `Failures (${failure.reduce((a, b) => a + b, 0)})`,
        data: failure,
        backgroundColor: "rgba(247, 89, 89, 0.4)",
        borderColor: "rgb(247, 89, 89)",
        "borderWidth": 1
      }]
    },
    options: {
      scales: {
        xAxes: [{
          stacked: true
        }],
        yAxes: [{
          stacked: true
        }]
      }
    }
  });
}