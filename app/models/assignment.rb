require 'zip'

class Assignment < ApplicationRecord
  self.inheritance_column = :_type_disabled

  has_many :assignment_files, dependent: :delete_all
  has_many :personal_files, dependent: :delete_all
  has_many :team_files, dependent: :delete_all
  has_many :experiment_files, dependent: :delete_all
  has_one :excel_file, dependent: :delete

  has_many :teams, dependent: :delete_all
  has_many :self_evaluations, dependent: :delete_all
  has_many :mutual_evaluations, dependent: :delete_all

  enum type: { PERSONAL: 'PERSONAL', TEAM: 'TEAM', EXPERIMENT: 'EXPERIMENT' }

  def stored_dir
    File.join(super, "#{type.downcase}_file/#{id}")
  end

  def type_korean
    if type == 'PERSONAL'
      '개인'
    elsif type == 'TEAM'
      '팀'
    elsif type == 'EXPERIMENT'
      '실험'
    end
  end


  def generate_compressed_file
    FileUtils.rm_f(compressed_file_path)
    FileUtils.mkdir_p(File.dirname(compressed_file_path))

    Zip::File.open(compressed_file_path, Zip::File::CREATE) do |zip|
      search_directory_recursively(stored_dir).each do |path|
        zip.add(File.basename(path), path)
      end
    end
    File.open(compressed_file_path)
  end

  def compressed_file_path
    File.join(stored_dir, compressed_file_name)
  end

  def compressed_file_name
    "[#{type_korean}]#{title}.zip"
  end

  def search_directory_recursively(directory)
    Dir.glob("#{directory}/*").map do |path|
      if File.directory?(path)
        search_directory_recursively(path)
      else
        path
      end
    end.flatten
  end

  def generate_excel_file
    FileUtils.rm_rf(stored_dir)

    if type == 'PERSONAL'
      create_personal_assignment_excel_file
    else
      create_multiple_assignment_excel_file
    end
  end

  def create_multiple_assignment_excel_file
    book = Spreadsheet::Workbook.new
    sheets = [book.create_worksheet(name: '1반'),
              book.create_worksheet(name: '2반'),
              book.create_worksheet(name: '3반'),
              book.create_worksheet(name: '4반')]

    ExcelFile.set_form(sheets)

    row_set = [3, 3, 3, 3]
    Team.where(assignment_id: id).order(name: :asc).each do |team|
      class_number = team.student.class_number.to_i
      team.students.order(student_number: :asc).each do |student|
        row = row_set[class_number - 1]
        row_set[class_number - 1] += 3
        submit_file = team.team_files.last

        sheets[class_number - 1].row(row)[0] = team.name
        sheets[class_number - 1].row(row)[1] = student.student_number
        sheets[class_number - 1].row(row)[2] = student.name
        sheets[class_number - 1].row(row)[3] = submit_file&.created_at
                                                          &.strftime("%Y-%m-%d\n%T")
        mutual_evaluation = MutualEvaluation.joins(:student)
                                            .where(assignment_id: id,
                                                   target_id: student.id)
                                            .order(student_number: :asc)

        sheets[class_number - 1].row(row)[5..8] = mutual_evaluation.map do |evaluation|
          evaluation.student.name
        end
        sheets[class_number - 1].row(row + 1)[5..8] = mutual_evaluation.map(&:communication)
        sheets[class_number - 1].row(row + 2)[5..8] = mutual_evaluation.map(&:cooperation)
        sheets[class_number - 1].row(row + 1)[9] = mutual_evaluation.map(&:communication)
                                                                    .sum
        sheets[class_number - 1].row(row + 2)[9] = mutual_evaluation.map(&:cooperation)
                                                                    .sum

        self_evaluation = student.self_evaluations
                                 .find_by_assignment_id(id)

        sheets[class_number - 1].row(row)[10] = mutual_evaluation.map(&:communication).sum +
                                                mutual_evaluation.map(&:cooperation).sum

        next unless self_evaluation

        sheets[class_number - 1].row(row)[11] = self_evaluation.scientific_accuracy
        sheets[class_number - 1].row(row)[12] = self_evaluation.communication
        sheets[class_number - 1].row(row)[13] = self_evaluation.attitude
      end
    end

    store_excel(book)
  end

  def create_personal_assignment_excel_file
    book = Spreadsheet::Workbook.new
    sheets = [book.create_worksheet(name: '1반'),
              book.create_worksheet(name: '2반'),
              book.create_worksheet(name: '3반'),
              book.create_worksheet(name: '4반')]

    sheets.each do |sheet|
      sheet.default_format = Spreadsheet::Format.new(horizontal_align: :center)
      sheet.row(0).push('학번', '이름', '제출 시각')
    end

    row_set = [1, 1, 1, 1]
    Student.order(student_number: :asc).each do |student|
      single_file = student.personal_files.find_by_assignment_id(id)
      class_number = student.class_number.to_i

      row = row_set[class_number - 1]
      row_set[class_number - 1] += 1

      sheets[class_number - 1].row(row)[0] = student.student_number
      sheets[class_number - 1].row(row)[1] = student.name
      sheets[class_number - 1].row(row)[2] = single_file&.created_at
                                                        &.strftime("%Y-%m-%d\n%T")
    end

    store_excel(book)
  end

  def store_excel(book)
    file_name = "'[#{type_korean}] #{title}.xls'"
    path = File.join(ApplicationRecord.stored_dir,
                     "excel_file/#{id}",
                     file_name)

    if excel_file
      excel_file.update!(path: path, file_name: file_name)
    else
      ExcelFile.create!(assignment_id: id,
                        path: path,
                        file_name: file_name)
    end

    FileUtils.mkdir_p(File.dirname(path))
    book.write(path)
  end
end
