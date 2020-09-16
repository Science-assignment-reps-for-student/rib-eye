class NoticeMailer < ApplicationMailer
  def submission(target, assignment)
    @name = Student.find_by_email(target.email)
    @title = assignment.title
    @type = assignment.type_korean
    @subject = "[제출 알림][#{@type}]#{@title}"

    if assignment.type == 'TEAM'
      @is_late = if assignment.files.find_by_leader_id(target.id).is_late
                   '지각'
                 else
                   '제출'
                 end

      return Team.find_by_leader_id_and_assignment_id(target.id,
                                                      assignment.id)
                 .students.each do |student|
               mail(from: 'notify@scarfs.hs.kr',
                    to: student.email,
                    subject: @subject,
                    content_type: 'text/html')
             end
    end

    @is_late = if assignment.files.find_by_student_id(target.id).is_late
                 '지각'
               else
                 '제출'
               end

    mail(from: 'notify@scarfs.hs.kr',
         to: target.email,
         subject: @subject,
         content_type: 'text/html')
  end
end
