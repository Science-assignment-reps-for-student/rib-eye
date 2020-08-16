class NoticeMailer < ApplicationMailer
  def submission(target, assignment)
    @name = Student.find_by_email(target.email)
    @title = assignment.title
    @type = assignment.type_korean
    @is_late = if assignment.is_late
                 '지각'
               else
                 '제출'
               end
    @subject = "[제출 알림][#{@type}]#{@title}"

    if assignment.type == 'TEAM'
      return Team.find_by_leader_id_and_assignment_id(target.id,
                                                      assignment.id)
                 .students.each do |student|
               mail(from: 'notify@scarfs.hs.kr',
                    to: student.email,
                    subject: @subject,
                    content_type: 'text/html')
             end
    end

    mail(from: 'notify@scarfs.hs.kr',
         to: target.email,
         subject: @subject,
         content_type: 'text/html')
  end
end
