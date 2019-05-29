
$(document).on("turbolinks:load ready", function(){
  initNetwork(gon.networkData);

  function initNetwork(networkData){
    var container = document.getElementById('network');
    var network = new vis.Network(
      container,
      {nodes: networkData.nodes, edges: networkData.edges},
      networkData.options
    );
  }

});
