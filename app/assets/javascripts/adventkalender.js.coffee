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
  iSpaceWidth   = 5 if iSpaceWidth < 5
  $('.fenster').css('margin-left', iSpaceWidth)
  $('.fenster').css('margin-right', iSpaceWidth)

  console.log $('.all_fenster').position().top
  iSpaceHeight  = Math.ceil( (($(window).height() - $('.all_fenster').position().top - 5 * $('.fenster').outerHeight(false)) / 10) )
  iSpaceHeight  = 5 if iSpaceHeight < 5
  $('.fenster').css('margin-top', iSpaceHeight)
  $('.fenster').css('margin-bottom', iSpaceHeight)

  $('.click').click ->
    $(@).removeClass('nopic').addClass('pic') if ($(@).hasClass('nopic'))
    iNumber = $(@).data('number')
    sUrl    = $('.all_fenster:first()').data('url').replace '_nr_', iNumber

    $.ajax
            url:    sUrl,
            method: "get",
            error:  (data, ajaxOptions, thrownError) ->
              console.log data
              console.log ajaxOptions
              console.log thrownError
              console.log 'Error'

            success:  (data) ->
              $('#overlay #content').html( data )
              $('#overlay').show()