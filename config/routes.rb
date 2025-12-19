Rails.application.routes.draw do
  # Chrome DevTools のリクエストを無視
  get '/.well-known/appspecific/com.chrome.devtools.json', to: proc { [404, {}, ['']] }

  root to: 'top#index'
end
