
$(document).on("turbolinks:load ready", function(){
  initNetwork();

  function initNetwork(){
    var container = document.getElementById('network');
    var network = new vis.Network(
      container,
      {nodes: gon.networkData.nodes, edges: gon.networkData.edges},
      gon.networkData.options
    );
  }

});
