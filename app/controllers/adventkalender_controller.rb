class AdventkalenderController < ApplicationController
  def window
    render partial: "window#{ params[:id] }"
    # render :js_show, locals: { partial: "window#{ params[:id] }"}
  end
end
