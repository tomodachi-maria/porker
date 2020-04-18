class HomeController < ApplicationController
  require_relative "concerns/check"
  include Check  #include モジュール

  def top
  end

  def judge
    @tefuda = HandCheck.new(params[:hand]) #paramsのデータを持ったインスタンスができる。
    @tefuda.errorcheck #@tefudaがcheckメソッドを通る。
    @kekka = @tefuda.messages
    render :top
  end
end#classのend
