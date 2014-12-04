class AdventkalenderController < ApplicationController
  def window
    render partial: "window#{ params[:id].to_i }"
    # render :js_show, locals: { partial: "window#{ params[:id] }"}
  end
end
