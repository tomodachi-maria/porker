  class HomeController < ApplicationController
    require_relative "../services/check"
    include Check  #include モジュール

      def top
      end

      def judge
        @tefuda = HandCheck.new(params[:hand]) #paramsのデータを持ったインスタンスができる。
        @tefuda.errorcheck #@tefudaがerrorcheckメソッドを通る。
          if   @tefuda.error != "any errors"
          　render :error
          else @tefuda.handcheck
            render :result
          end #ifのend
      end #defのend

  end#classのend
