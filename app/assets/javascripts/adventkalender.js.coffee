# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

shuffle = (a) ->
  # From the end of the list to the beginning, pick element `i`.
  for i in [a.length-1..1]
    # Choose random element `j` to the front of `i` to swap with.
    j = Math.floor Math.random() * (i + 1)
    # Swap `j` with `i`, using destructured assignment
    [a[i], a[j]] = [a[j], a[i]]
  # Return the shuffled array.
  a

jQuery ->
  iDay = (new Date).getDay()
  for i in shuffle([1..28])
    $('.all_fenster').append("<div class='fenster'></div>")

    if i >= 1 and i <= 24
      console.log "#{ iDay } > #{ i }"
      cFenster  = if iDay > i
                    'pic click'
                  else if iDay == i
                    'nopic today click'
                  else
                    'nopic'
      $('.all_fenster .fenster:last()').addClass( cFenster ).
                                        data('number', i).
                                        append( "<div class='number'>#{ i }</div>")

  iSpaceWidth   = Math.ceil( ($(window).width() - 8 * $('.fenster').outerWidth(false)) / 16 )
  iSpaceWidth   = 20 if iSpaceWidth < 20
  $('.fenster').css('margin-left', iSpaceWidth)
  $('.fenster').css('margin-right', iSpaceWidth)

  iSpaceHeight  = Math.ceil( (($(window).height() - 160 - 7 * $('.fenster').outerHeight(false)) / 12) )
  iSpaceHeight  = 20 if iSpaceHeight < 20
  $('.fenster').css('margin-top', iSpaceHeight)
  $('.fenster').css('margin-bottom', iSpaceHeight)

  $('.click').click ->
    $(@).removeClass('nopic').addClass('pic') if ($(@).hasClass('nopic'))
    iNumber = $(@).data('number')
