# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('#show-fields-for-bands').on 'click', (e) ->
    e.preventDefault()
    $('#fields-for-bands').toggleClass('hidden')