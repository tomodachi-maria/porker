Rails.application.routes.draw do
    get "/" => "home#top"
    #homeコントローラのtopアクションを呼び出してください。
    post "/judge" => "home#judge"
    get "/result" => "home#result"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
