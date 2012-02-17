Rails.application.routes.draw do

  mount Locomotive::Engine => '/locomotive', :as => 'locomotive'

end
