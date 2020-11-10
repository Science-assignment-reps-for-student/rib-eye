# frozen_string_literal: true

class ExcelUtil
  def initialize(assignment:)
    @assignment = assignment
  end

  def generate_excel_file
    if @assignment.type == 'PERSONAL'
      create_personal_assignment_excel_file
    else
      create_multiple_assignment_excel_file
    end
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
      single_file = student.personal_files.find_by_assignment_id(@assignment.id)
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

  def create_multiple_assignment_excel_file
    book = Spreadsheet::Workbook.new
    sheets = [book.create_worksheet(name: '1반'),
              book.create_worksheet(name: '2반'),
              book.create_worksheet(name: '3반'),
              book.create_worksheet(name: '4반')]

    self.class.set_form(sheets)

    row_set = [3, 3, 3, 3]
    Team.where(assignment_id: @assignment.id).order(name: :asc).each do |team|
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
                                .where(assignment_id: @assignment.id,
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
                              .find_by_assignment_id(@assignment.id)

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

  def store_excel(book)
    file_name = "'[#{@assignment.type_korean}] #{@assignment.title}.xls'"
    path = File.join(ApplicationRecord.stored_dir,
                     "excel_file/#{@assignment.id}",
                     file_name)

    if @assignment.excel_file
      FileUtils.rm_rf(@assignment.excel_file.stored_dir)
      @assignment.excel_file.update!(path: path, file_name: file_name)
    else
      ExcelFile.create!(assignment_id: @assignment.id,
                        path: path,
                        file_name: file_name)
    end

    FileUtils.mkdir_p(File.dirname(path))
    book.write(path)
  end

  def self.set_form(sheets)
    sheets.each do |sheet|
      sheet.default_format = Spreadsheet::Format.new(horizontal_align: :center)
      sheet.merge_cells(0, 11, 0, 13)
      (11..13).each { |i| sheet.merge_cells(1, i, 2, i) }
      (0..13).each do |i|
        sheet.merge_cells(0, i, 2, i) unless (11..13).include?(i)
        (1..22).each { |j| sheet.merge_cells(j * 3, i, j * 3 + 2, i) unless (4..9).include?(i) }
      end

      sheet.row(0).push('조',
                        '학번',
                        '이름',
                        '제출 일시',
                        '평가 종류',
                        '모둠원 A',
                        '모둠원 B',
                        '모둠원 C',
                        '모둠원 D',
                        '모둠 합산',
                        '총 합산',
                        '자기평가')
      sheet.row(1)[11] = '과학적 정확성'
      sheet.row(1)[12] = '의사소통'
      sheet.row(1)[13] = '흥미/태도(협력)'
      (3..68).each do |i|
        sheet.row(i)[4] = if (i % 3).zero?
                            '평가자'
                          elsif i % 3 == 1
                            '의사소통'
                          else
                            '공동체(협력)'
                          end
      end
    end

    sheets
  end
end