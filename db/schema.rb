ActiveRecord::Schema.define(version: 0) do
  create_table 'student', options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string :email, null: false, unique: true
    t.string :password, null: false
    t.string :student_number, null: false, unique: true
    t.string :name, null: false
  end

  create_table 'admin', options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string :email, null: false, unique: true
    t.string :password, null: false
    t.string :name, null: false
  end

  create_table 'single_file', options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint :student_id, null: false
    t.bigint :homework_id, null: false
    t.index [:student_id], name: 'index_single_file_on_student_id'
    t.index [:homework_id], name: 'index_single_file_on_homework_id'
    t.index %i[student_id homework_id], name: 'index_single_file_on_student_id_and_homework_id', unique: true
    t.string :file_name, null: false, unique: true
    t.string :path, null: false
    t.datetime :created_at, null: false
    t.boolean :is_late, null: false
  end

  create_table 'team_file', options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint :team_id, null: false
    t.bigint :homework_id, null: false
    t.index [:team_id], name: 'index_team_file_on_team_id'
    t.index [:homework_id], name: 'index_team_file_on_homework_id'
    t.index %i[team_id homework_id], name: 'index_team_file_on_team_id_and_homework_id', unique: true
    t.string :file_name, null: false, unique: true
    t.string :path, null: false
    t.datetime :created_at, null: false
    t.boolean :is_late, null: false
  end

  create_table 'experiment_file', options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint :student_id, null: false
    t.bigint :homework_id, null: false
    t.index [:student_id], name: 'index_experiment_file_on_student_id'
    t.index [:homework_id], name: 'index_experiment_file_on_homework_id'
    t.index %i[student_id homework_id], name: 'index_experiment_file_on_student_id_and_homework_id', unique: true
    t.string :file_name, null: false, unique: true
    t.string :path, null: false
    t.datetime :created_at, null: false
    t.boolean :is_late, null: false
  end

  create_table 'excel_file', options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint :homework_id, null: false
    t.index [:homework_id], name: 'index_excel_file_on_homework_id'
    t.string :file_name, null: false
    t.string :path, null: false
  end

  create_table 'homework_file', options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint :homework_id, null: false
    t.index [:homework_id], name: 'index_homework_file_on_homework_id'
    t.string :file_name, null: false
    t.string :path, null: false
  end

  create_table 'homework', options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime :deadline_1, null: false
    t.datetime :deadline_2, null: false
    t.datetime :deadline_3, null: false
    t.datetime :deadline_4, null: false
    t.string :title, null: false
    t.text :description
    t.string :type, null: false
    t.datetime :created_at, null: false
  end

  create_table 'self_evaluation', options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint :student_id, null: false
    t.bigint :homework_id, null: false
    t.index [:student_id], name: 'index_self_evaluation_on_student_id'
    t.index [:homework_id], name: 'index_self_evaluation_on_homework_id'
    t.index %i[student_id homework_id], name: 'index_self_evaluation_on_student_id_and_homework_id', unique: true
    t.integer :scientific_accuracy, null: false
    t.integer :communication, null: false
    t.integer :attitude, null: false
    t.datetime :created_at, null: false
  end

  create_table 'mutual_evaluation', options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint :student_id, null: false
    t.bigint :homework_id, null: false
    t.bigint :target_id, null: false
    t.index [:student_id], name: 'index_mutual_evaluation_on_student_id'
    t.index [:homework_id], name: 'index_mutual_evaluation_on_homework_id'
    t.index [:target_id], name: 'index_mutual_evaluation_on_target_id'
    t.index %i[student_id homework_id target_id], name: 'student_id_and_homework_id_and_target_id', unique: true
    t.integer :communication, null: false
    t.integer :cooperation, null: false
    t.datetime :created_at, null: false
  end

  create_table 'team', options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint :leader_id, null: false
    t.bigint :homework_id, null: false
    t.index [:leader_id], name: 'index_team_on_leader_id'
    t.index [:homework_id], name: 'index_team_on_homework_id'
    t.index %i[leader_id homework_id], name: 'index_team_on_leader_id_and_homework_id', unique: true
    t.string :name, null: false
  end

  create_table 'member', options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint :team_id, null: false
    t.bigint :student_id, null: false
    t.index [:team_id], name: 'index_member_on_team_id'
    t.index [:student_id], name: 'index_member_on_student_id'
  end
end
