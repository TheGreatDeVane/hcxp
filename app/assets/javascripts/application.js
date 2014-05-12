// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.turbolinks
//= require turbolinks
//= require rails-timeago-all
//= require jquery_nested_form
//= require twitter/typeahead
//= require select2
//= require_tree .

$(document).ready(function() {
  $('#search-form input').typeahead([
  	{
  		name:   'events',
      remote: "/events/autocomplete?q=%QUERY",
      header: '<h3>Events</h3>',
  	},
    {
      name:   'venues',
      remote: '/venues/autocomplete?q=%QUERY',
      header: '<h3>Venues</h3>'
    },
    {
      name:   'bands',
      remote: '/bands/autocomplete?q=%QUERY',
      header: '<h3>Bands</h3>'
    },
  ]);

  // Apply select2 to bands list on event page
  $('.bands-list').select2({
    placeholder: "Search for band",
    minimumInputLength: 0,
    multiple: true,
    id: function(e) { return e.id+':'+e.name; },
    separator: ';',
    loadMorePadding: 100,
    ajax: {
      url: '/search/bands.json',
      dataType: 'json',
      quietMillis: 100,
      data: function(term, page) {
        return {
          q: term,
          page_limit: 10,
          page: page
        };
      },
      results: function(data, page) {
        console.log(data.total)
        var more = (page * 10) < data.total;
        return {
          results: data.bands, more: more
        };
      }
    },
    formatResult: formatResult,
    formatSelection: formatSelection,
    initSelection: function(element, callback) {
      var data = [];
      $(element.val().split(";")).each(function(i) {
        var item = this.split(':');
        data.push({
          id: item[0],
          name: item[1]
        });
      });
      //$(element).val('');
      callback(data);
    }
  });

  function formatResult(band) {
    console.log(band)
    return '<div>' + band.name + '</div>';
  }

  function formatSelection(data) {
    return data.name;
  }
});