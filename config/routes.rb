Rails.application.routes.draw do
  get "/" => "cards#top"
  #cardsコントローラのtopアクションを呼び出してください。
  post "/judge" => "cards#judge"
  get "/judge" => "cards#top"
 # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
