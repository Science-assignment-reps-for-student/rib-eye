Rails.application.routes.draw do
  scope(path: '/rib-eye') do
    # personal file controller
    get '/personal-file/:student_id', to: 'personal_files#show'
    get '/personal-files/:assignment_id', to: 'personal_files#index'
    post '/personal-file/:assignment_id', to: 'personal_files#create'
    delete '/personal-file/:assignment_id', to: 'personal_files#destroy'

    # team file controller
    get '/team-file/:team_id', to: 'team_files#show'
    get '/team-files/:assignment_id', to: 'team_files#index'
    post '/team-file/:assignment_id', to: 'team_files#create'
    delete '/team-file/:assignment_id', to: 'team_files#destroy'

    # experiment file controller
    get '/experiment-file/:student_id', to: 'experiment_files#show'
    get '/experiment-files/:assignment_id', to: 'experiment_files#index'
    post '/experiment-file/:assignment_id', to: 'experiment_files#create'
    delete '/experiment-file/:assignment_id', to: 'experiment_files#destroy'

    # assignment controller
    post '/assignment', to: 'assignments#create'
    patch '/assignment/:assignment_id', to: 'assignments#update_information'
    put '/assignment/:assignment_id', to: 'assignments#update_file'
    delete '/assignment/:assignment_id', to: 'assignments#destroy'

    # excel file controller
    patch '/personal-excel-file/:assignment_id', to: 'excel_files#update_personal'
    patch '/team-excel-file/:assignment_id', to: 'excel_files#update_team'
    patch '/experiment-excel-file/:assignment_id', to: 'excel_files#update_experiment'
    get '/excel-file/:assignment_id', to: 'excel_files#show'
  end
end
