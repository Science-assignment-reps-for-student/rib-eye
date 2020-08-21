require 'sidekiq/web'

Rails.application.routes.draw do
  scope(path: '/rib-eye') do
    # personal file controller
    get '/personal-file/:file_id', to: 'personal_files#show'
    get '/personal-files/:assignment_id', to: 'personal_files#index'
    post '/personal-file/:assignment_id', to: 'personal_files#create'
    delete '/personal-file/:file_id', to: 'personal_files#destroy'

    # team file controller
    get '/team-file/:file_id', to: 'team_files#show'
    get '/team-files/:assignment_id', to: 'team_files#index'
    post '/team-file/:assignment_id', to: 'team_files#create'
    delete '/team-file/:file_id', to: 'team_files#destroy'

    # experiment file controller
    get '/experiment-file/:file_id', to: 'experiment_files#show'
    get '/experiment-files/:assignment_id', to: 'experiment_files#index'
    post '/experiment-file/:assignment_id', to: 'experiment_files#create'
    delete '/experiment-file/:file_id', to: 'experiment_files#destroy'

    # assignment controller
    get '/assignment/:assignment_id', to: 'assignments#show'
    get '/assignments/:assignment_id', to: 'assignments#index'
    post '/assignment', to: 'assignments#create'
    patch '/assignment/:assignment_id', to: 'assignments#update'
    delete '/assignment/:assignment_id', to: 'assignments#destroy'

    # assignment file controller
    get '/assignment-file/:file_id', to: 'assignment_files#show'
    get '/assignment-files/:assignment_id', to: 'assignment_files#index'
    delete '/assignment-file/:file_id', to: 'assignment_files#destroy'

    # excel file controller
    patch '/excel-file/:assignment_id', to: 'excel_files#update'
    get '/excel-file/:assignment_id', to: 'excel_files#show'

    # SideKiq
    mount Sidekiq::Web => '/sidekiq'
  end
end
