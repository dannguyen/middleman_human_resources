#= require underscore/underscore
#= require jquery/jquery
#= require isotope/jquery.isotope
#= require bootstrap

(($) ->
  $(window).on('load', () ->

    $('.isotope').isotope
      itemSelector : '.item',
      layoutMode : 'masonry'


  )
)(jQuery)