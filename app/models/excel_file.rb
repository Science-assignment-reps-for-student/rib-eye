class ExcelFile < ApplicationRecord
  belongs_to :assignment

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
