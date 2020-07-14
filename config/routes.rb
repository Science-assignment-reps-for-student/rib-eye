Rails.application.routes.draw do
  scope(path: '/rib-eye') do
    # single file controller
    get '/single-file/:user_id', to: 'single_files#show'
    get '/single-files/:homework_id', to: 'single_files#index'
    post '/single-file/:homework_id', to: 'single_files#create'
    delete '/single-file/:homework_id', to: 'single_files#destroy'

    # multi file controller
    get '/multi-file/:team_id', to: 'multi_files#show'
    get '/multi-files/:homework_id', to: 'multi_files#index'
    post '/multi-file/:homework_id', to: 'multi_files#create'
    delete '/multi-file/:homework_id', to: 'multi_files#destroy'

    # experiment file controller
    get '/experiment-file/:user_id', to: 'experiment_files#show'
    get '/experiment-files/:homework_id', to: 'experiment_files#index'
    post '/experiment-file/:homework_id', to: 'experiment_files#create'
    delete '/experiment-file/:homework_id', to: 'experiment_files#destroy'

    # homework controller
    post '/homework', to: 'homeworks#create'
    get '/homework/:homework_id', to: 'homeworks#show_information'
    get '/homework-file/:homework_id', to: 'homeworks#show_file'
    patch '/homework/:homework_id', to: 'homeworks#update_information'
    put '/homework/:homework_id', to: 'homeworks#update_file'
    delete '/homework/:homework_id', to: 'homeworks#destroy'

    # excel file controller
    patch '/single-excel-file/:homework_id', to: 'excel_files#update_single'
    patch '/multi-excel-file/:homework_id', to: 'excel_files#update_multi'
    patch '/experiment-excel-file/:homework_id', to: 'excel_files#update_experiment'
    get '/excel-file/:homework_id', to: 'excel_files#show'
  end
end
