//set up map start
var map = L.map('map', {
 center: [37.8393, -85.7585],
 minZoom: 7,
 zoom: 7
});
//end

//add tile layers start
// L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
//  attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
//  subdomains: ['a', 'b', 'c']
// }).addTo(map);

// L.tileLayer('http://services.arcgisonline.com/arcgis/rest/services/NatGeo_World_Map/MapServer/tile/{z}/{y}/{x}', {
//  attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
//  subdomains: ['a', 'b', 'c']
// }).addTo(map);

// var Thunderforest_Pioneer = L.tileLayer('https://{s}.tile.thunderforest.com/pioneer/{z}/{x}/{y}.png?apikey={evkG1NtNlmaJecx4EkLGTg3Pt7Zf5HxCwsIgIJ1VHyk}', {
// 	attribution: '&copy; <a href="http://www.thunderforest.com/">Thunderforest</a>, &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
// 	maxZoom: 22
// });addTo(map)
// add Stamen Watercolor to map.
L.tileLayer.provider('Stamen.Toner').addTo(map);

var myStyle = {
    "color": "#000000",
    "weight": 1,
    "opacity": 0.1,
    "fill": false
};

L.geoJSON(geojsonFeature, {
      style: myStyle
}).addTo(map);

//add data
var markerClusters = L.markerClusterGroup();

for (var i = 0; i < markers.length; ++i) {
    var popup =
        '<b>marker: <b>' + markers[i].marker +
        '<br/><b>name: <b>' +markers[i].name +
        '<br/><b>county: <b> ' + markers[i].county +
        '<br/><b>founded: <b>' + markers[i].founding +
        '<br/><b>county_seat: <b>' + markers[i].county_seat;

    var m = L.marker([markers[i].lat, markers[i].lon]).bindPopup(popup);

    markerClusters.addLayer(m);
}
map.addLayer(markerClusters);
